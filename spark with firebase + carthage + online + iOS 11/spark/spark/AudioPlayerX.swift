//
//  AudioPlayer.swift
//  spark
//
//  Created by Vikesh on 04/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import Foundation
import AVFoundation

public enum AudioPlayerErrorX: Error {
    case fileExtension, fileNotFound
}

open class AudioPlayerX: NSObject {
    
    public static let SoundDidFinishPlayingNotification = Notification.Name(rawValue: "SoundDidFinishPlayingNotification")
    public typealias SoundDidFinishCompletion = (_ didFinish: Bool) -> Void
    
    /// Name of the used to initialize the object
    open var name: String?
    
    /// URL of the used to initialize the object
    public var url: URL? = nil
    
    /// A callback closure that will be called when the audio finishes playing, or is stopped.
    open var completionHandler: SoundDidFinishCompletion?
    
    /// is it playing or not?
    open var isPlaying: Bool {
        get {
            if let nonNilsound = sound {
                return nonNilsound.isPlaying
            }
            return false
        }
    }
    
    /// the duration of the sound.
    open var duration: TimeInterval {
        get {
            if let nonNilsound = sound {
                return nonNilsound.duration
            }
            return 0.0
        }
    }
    
    /// currentTime is the offset into the sound of the current playback position.
    open var currentTime: TimeInterval {
        get {
            if let nonNilsound = sound {
                return nonNilsound.currentTime
            }
            return 0.0
        }
        set {
            sound?.currentTime = newValue
        }
    }
    
    /// The volume for the sound. The nominal range is from 0.0 to 1.0.
    open var volume: Float = 1.0 {
        didSet {
            volume = min(1.0, max(0.0, volume))
            targetVolume = volume
        }
    }
    
    /// "numberOfLoops" is the number of times that the sound will return to the beginning upon reaching the end.
    /// A value of zero means to play the sound just once.
    /// A value of one will result in playing the sound twice, and so on..
    /// Any negative number will loop indefinitely until stopped.
    open var numberOfLoops: Int = 0 {
        didSet {
            sound?.numberOfLoops = numberOfLoops
        }
    }
    
    /// set panning. -1.0 is left, 0.0 is center, 1.0 is right.
    open var pan: Float = 0.0 {
        didSet {
            sound?.pan = pan
        }
    }
    
    // MARK: Private properties
    
    fileprivate var sound: AVAudioPlayer?
    fileprivate var startVolume: Float = 1.0
    fileprivate var targetVolume: Float = 1.0 {
        didSet {
            sound?.volume = targetVolume
        }
    }
    
    fileprivate var fadeTime: TimeInterval = 0.0
    fileprivate var fadeStart: TimeInterval = 0.0
    fileprivate var timer: Timer?
    
    // MARK: Init
    public convenience init(fileName: String) throws {
        
        let fixedFileName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)
        var soundFileComponents = fixedFileName.components(separatedBy: ".")
        if soundFileComponents.count == 1 {
            throw AudioPlayerErrorX.fileExtension
        }
        
        guard let path = Bundle.main.path(forResource: soundFileComponents[0], ofType: soundFileComponents[1]) else {
            throw AudioPlayerErrorX.fileNotFound
        }
        
        try self.init(path: path)
    }
    
    public convenience init(path: String) throws {
        let fileURL = URL(fileURLWithPath: path)
        try self.init(contentsOf: fileURL)
    }
    
    public convenience init(contentsOf url: URL) throws {
        self.init()
        self.url = url
        name = url.lastPathComponent
        do {
            sound = try AVAudioPlayer(contentsOf: url)
            sound?.delegate = self
        } catch let error  {
            print(error.localizedDescription)
            print("error loading sound @ \(url.absoluteString)")
        }
        
       
    }
    
    public override init() {}
    
    deinit {
        timer?.invalidate()
        sound?.delegate = nil
    }
    
    // MARK: Play / Stop
    
    open func play() {
        toggleSoundPlay()
    }
    
    open func stop() {
        toggleSoundPlay()
    }
    
    open func toggleSoundPlay(){
        if let playing = sound?.isPlaying,  let sound = sound {
            if(!playing) {
                 sound.play()
            }
            else {
                 soundDidFinishPlayingSuccessfully(false)
            }
        }
    }
    
    // MARK: Fade
    
    open func fadeTo(_ volume: Float, duration: TimeInterval = 1.0) {
        startVolume = sound?.volume ?? SparkDataService.user.backgroundMusicVolume
        targetVolume = volume
        fadeTime = duration
        fadeStart = Date().timeIntervalSinceReferenceDate
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.015, target: self, selector: #selector(handleFadeTo), userInfo: nil, repeats: true)
        }
    }
    
    open func fadeIn(_ duration: TimeInterval = 1.0) {
        volume = 0.0
        fadeTo(SparkDataService.user.backgroundMusicVolume, duration: duration)
    }
    
    open func fadeOut(_ duration: TimeInterval = 1.0) {
        fadeTo(0.0, duration: duration)
    }
    
    // MARK: Private
    
    @objc internal func handleFadeTo() {
        let now = Date().timeIntervalSinceReferenceDate
        let delta: Float = (Float(now - fadeStart) / Float(fadeTime) * (targetVolume - startVolume))
        let volume = startVolume + delta
        sound?.volume = volume
        if delta > 0.0 && volume >= targetVolume ||
            delta < 0.0 && volume <= targetVolume {
            sound?.volume = targetVolume
            timer?.invalidate()
            timer = nil
            if sound?.volume == 0 {
                stop()
            }
        }
    }
    
}

extension AudioPlayerX: AVAudioPlayerDelegate {
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        soundDidFinishPlayingSuccessfully(flag)
    }
}

fileprivate extension AudioPlayerX {
    
    func soundDidFinishPlayingSuccessfully(_ didFinishSuccessfully: Bool) {
        sound?.stop()
        timer?.invalidate()
        timer = nil
        
        if let nonNilCompletionHandler = completionHandler {
            nonNilCompletionHandler(didFinishSuccessfully)
        }
        
        NotificationCenter.default.post(name: AudioPlayerX.SoundDidFinishPlayingNotification, object: self)
    }
    
}
