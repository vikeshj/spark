//
//  SparkAudioService.swift
//  spark
//
//  Created by Vikesh on 04/11/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import Foundation
import AVFoundation

let kJukeBoxStateNotification:String = "kJukeBoxStateNotification"

class SparkAudioService: AudioPlayerDelegate {
    
    
    static var shared: SparkAudioService = SparkAudioService()
    static let SoundDidFinishPlayingNotification = Notification.Name(rawValue: "SoundDidFinishPlayingNotification")
    
    
    var user: User { return SparkDataService.user }
    let task = DispatchWorkItem { print("background timer cancel") }
    let fileManager = FileManager.default
    var audioPlayer: AudioPlayerX! = nil
    var backgroundPlayer: AudioPlayerX! = nil
    var configurationPlayer: AudioPlayerX! = nil
    var currentBackgroundSound: String!
    var currentPlaylist: FirePlaylist!
    var miniPlayer: MiniPlayerContentViewControler!
    
    var mediaPlayer: AudioPlayer!
    var audioItems:[AudioItem]!
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print("error AVAudioSession")
        }
    }
    
    func playMonoSound(_ sound: String, completion:@escaping (_ didFinish: Bool) -> ()){
        
        if(audioPlayer != nil){
            if audioPlayer.isPlaying {
                audioPlayer.stop()
            }
        }
        
        do {
            audioPlayer = try AudioPlayerX(path: sound)
            guard let player = audioPlayer else { return }
            player.play()
            player.completionHandler = completion
            
        } catch let error { print("error loading file", error) }
    }
    
    func playConfigurationSound(_ sound: String){
        
        if(configurationPlayer != nil && configurationPlayer.isPlaying && configurationPlayer.name! == sound) {
            return
        }
        
        do {
            configurationPlayer = try AudioPlayerX(fileName: sound)
            configurationPlayer.numberOfLoops = 0
            configurationPlayer.volume = SparkDataService.user.backgroundMusicVolume
            configurationPlayer.play()
            
            delayWithSeconds(15, completion: {
                self.configurationPlayer.fadeOut()
            })
            
            
            
        } catch let error { print("background sound ", error) }
        
    }
    
    func prepareBackgroundSound(_ sound: String) {
        do {
            backgroundPlayer = try AudioPlayerX(fileName: sound)
            backgroundPlayer.numberOfLoops = -1
            backgroundPlayer.volume = SparkDataService.user.backgroundMusicVolume
            
        } catch let error { print("background sound ", error) }
    }
    
    func playBackgroundSound(_ sound: String, isPreview: Bool = false, completion: @escaping (_ didFinish: Bool) -> ()) {
        if currentBackgroundSound != nil && currentBackgroundSound == sound {
            if(!backgroundPlayer.isPlaying) {
                task.cancel()
                backgroundPlayer.stop()
            }
            return
        }
        
        prepareBackgroundSound(sound)
        backgroundPlayer.play()
        
        if isPreview {
            delayWithSeconds(15, completion: {
                self.backgroundPlayer.fadeOut()
                completion(true)
            })
        }
        
        
    }
    
    func isSoundExist(_ name: String) -> Bool {
        return Bundle.main.path(forResource: name, ofType: ".mp3") != nil
    }
    
    func pauseConfigurationSound(){
        if(configurationPlayer != nil) {
            if configurationPlayer.isPlaying {
                configurationPlayer.fadeOut()
            }
        }
    }
    
    func pauseBackgroundSound(){
        if(backgroundPlayer != nil) {
            if backgroundPlayer.isPlaying {
                backgroundPlayer.fadeOut(0.5)
            }
        }
    }
    
    func stopAllSound(){
        if audioPlayer != nil { audioPlayer.fadeOut() }
        if backgroundPlayer != nil { backgroundPlayer.fadeOut() }
        if configurationPlayer != nil { configurationPlayer.fadeOut() }
    }
    
    func delayWithCancel(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: task)
        completion()
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    //mediaplayer
    func letsJumpAround(_ playlist: FirePlaylist){
        pauseBackgroundSound()
        if let player = self.mediaPlayer{
            player.stop()
        }
        
        SparkAudioService.jukeboxLoader(playlist, completion: { (success) in
            if(success) {
                SparkAudioService.shared.getFileInDocumentDirectory(playlist, completion: { (audioItems) in
                    self.mediaPlayer = AudioPlayer()
                    self.mediaPlayer.mode = .repeatAll
                    self.mediaPlayer.delegate = self
                    self.audioItems = audioItems
                    self.mediaPlayer.add(items: audioItems)
                    print("** jukebox ready **")
                    SwiftSpinner.hide()
                })
                return
            }
            else {
                SwiftSpinner.hide()
            }
        })
        
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, to state: AudioPlayerState) {
        ApplicationViewController.sharedInstance.menuViewController.delegate.audioDidChanged(state)
        switch(state){
        case .playing:
            if(!backgroundPlayer.isPlaying) {
                backgroundPlayer.fadeIn(0.3)
                backgroundPlayer.play()
            }
            if let album = audioPlayer.currentItem?.album {
                ApplicationViewController.sharedInstance.menuViewController.delegate.titleForMiniPlayer("\(album)")
            }
            break
        case .paused, .stopped:
            pauseBackgroundSound()
            if let album = audioPlayer.currentItem?.album {
                ApplicationViewController.sharedInstance.menuViewController.delegate.titleForMiniPlayer("\(album)")
            }
            break
        default: break
        }
        miniPlayer.audioPlayer(audioPlayer, didChangeStateFrom: from, to: state)
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, willStartPlaying item: AudioItem) {
        
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateProgressionTo time: TimeInterval, percentageRead: Float) {
        miniPlayer.audioPlayer(audioPlayer, didUpdateProgressionTo: time, percentageRead: percentageRead)
    }
    
    
}

extension SparkAudioService {
    
    class func jukeboxLoader(_ playlist: FirePlaylist, completion:  @escaping (_ success: Bool) -> ()) {
        var counter = 0
        if let voices = playlist.voices {
            for item in voices {
                let directory = "\(FireBaseKey.themes)/\(item.themeType)/\(playlist.locale)/\(playlist.peopleId)/"
                let track = item.track
                
                let file = SparkAudioService.shared.m4aExists(file: directory + track)
                if(file.success) {
                    counter = counter + 1
                    if let count = playlist.voices?.count {
                        if(count == counter) {
                            completion(true)
                        }
                    }
                    print("success + --> ", file.destination.path)
                    
                } else {
                   
                    let ref = SparkDataService.shared.fireabaseStorageNode(directory + track)
                    ref.downloadURL(completion: { (url, error) in
                        if error != nil {
                            //if no connection
                            SwiftSpinner.hide()
                            SparkFirebaseService.shared.createSnackBarWithIcon(Localization(key: Spark.NO_CONNECTION), icon: #imageLiteral(resourceName: "warning"), time: .middle)
                            return
                        }
                        if url != nil {
                            DispatchQueue.global(qos: .background).async {
                                
                                SparkAudioService.downloadM4aFiles(url!, subDirectory: directory, completion: { (path) in
                                    
                                    counter = counter + 1
                                    if let count = playlist.voices?.count {
                                        if(count == counter) {
                                            completion(true)
                                        }
                                    }
                                })
                            }
                        }
                    })
                }
            }
        }
    }
    
    
    class func downloadM4aFiles(_ audioUrl: URL, subDirectory: String, completion: @escaping (_ path: String) -> ()) {
        
        SparkAudioService.shared.createDirectory(name: subDirectory)
        
        let file = SparkAudioService.shared.m4aExists(file: subDirectory + audioUrl.lastPathComponent)
        if(file.success) {
            completion(file.destination.path)
        } else {
            URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) in
                // after downloading your data you need to save it to your destination url
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("audio"),
                    let location = location, error == nil
                    else { return }
                do {
                    if(!FileManager().fileExists(atPath: file.destination.path))
                    {
                        try FileManager.default.moveItem(at: location, to: file.destination)
                        print(file.destination.path)
                        completion(file.destination.path)
                    }
                   
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }).resume()
        }
    }
    
    func getFileInDocumentDirectory(_ playlist: FirePlaylist, completion: @escaping (_ playlists:[AudioItem]) -> ()){
        var audioItems = [AudioItem]()
        var trackId = 0
        if let voices = playlist.voices {
            for item in voices {
                let directory = "\(FireBaseKey.themes)/\(item.themeType)/\(playlist.locale)/\(playlist.peopleId)/"
                let track = item.track
                
                let file = SparkAudioService.shared.m4aExists(file: directory + track)
                if(file.success) {
                    if let audio = AudioItem(mediumQualitySoundURL: URL(fileURLWithPath: file.destination.path)){
                        audio.title = item.title
                        audio.album = playlist.title
                        audio.trackNumber = trackId as NSNumber
                        audioItems.append(audio)
                    }
                }
                trackId = trackId + 1
            }
            
            completion(audioItems)
        }
    }
    
    /// create user directory if not exists
    func createDirectory(name: String) {
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else {
            //print("Directory exists \(paths)")
        }
    }
    
    /// checks if a file exists in the user local directory
    func m4aExists(file: String) -> (success: Bool, destination:URL, fileSize:UInt64) {
        
        let documentsPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let destination = documentsPath.appendingPathComponent(file)
        var fileSize:UInt64 = UInt64(0)
        
        if(FileManager().fileExists(atPath: destination.path)) {
            fileSize = (try! FileManager.default.attributesOfItem(atPath: destination.path)[FileAttributeKey.size] as! NSNumber).uint64Value
        }
        return (success: FileManager().fileExists(atPath: destination.path), destination: destination, fileSize: fileSize)
    }
    
    //clear m4a temp files
    func clearDiskCache(directory folder: String) {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let diskCacheStorageBaseUrl = myDocuments.appendingPathComponent(folder)
        guard let filePaths = try? fileManager.contentsOfDirectory(at: diskCacheStorageBaseUrl, includingPropertiesForKeys: nil, options: []) else { return }
        for filePath in filePaths {
            try? fileManager.removeItem(at: filePath)
        }
    }
    
}

