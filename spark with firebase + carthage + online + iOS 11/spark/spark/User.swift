//
//  User.swift
//  spark
//
//  Created by Vikesh on 14/11/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import Foundation
//import Firebase

class User: NSObject {
    
    //locale
    var locale: String? {
        didSet {
            if let locale = locale {
                SetLanguage(locale)
                localeId = SparkLocale(rawValue: locale)?.index
            }
        }
    }
    var localeId: Int?
    var uid: String? { get { return  Auth.auth().currentUser?.uid } }
    var gender: String?
    var peopleId: String?
    var peopleIndex: Int?
    var peopleName: String?
    var backgroundMusic: String? {
        didSet {
            if let backgroundMusic = backgroundMusic {
                guard let bsound =  SparkBackgroundMusic(rawValue: backgroundMusic) else { return }
                backgroundMusicId = bsound.index
                backgroundSoundPath = bsound.description + ".m4a"
            }
        }
    }
    var backgroundSoundPath: String?
    var backgroundMusicId: Int?
    var backgroundMusicVolume: Float = 0.7 {
        didSet {
            if let cPlayer = SparkAudioService.shared.configurationPlayer {
                cPlayer.volume = Float(backgroundMusicVolume)
            }
            
            if let bPlayer = SparkAudioService.shared.backgroundPlayer {
                bPlayer.volume = backgroundMusicVolume
            }
        }
    }
    var isFirstLaunched: Bool = true
    
    /// timeStamp
    var timeStamp: String {
        get {
            let date = NSDate()
            // : "May 10, 2016, 8:55 PM" - Local Date Time
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            let defaultTimeZoneStr = formatter.string(from: date as Date)
            return defaultTimeZoneStr
        }
    }
    
    
    /// Store the active playlist and store it as recent playlist also
    var activePlaylistId: String? = ""
    
    var reset : Bool = false {
        didSet {
            isFirstLaunched = true
            gender = nil
            peopleId = nil
            peopleIndex = nil
            peopleName = nil
            backgroundMusic = nil
            backgroundMusicId = nil
            SparkDataService.shared.removeUserKey(UserSharedKey.user)
        }
    }
    
    var object: [String: Any]  {
        get {
            var o = [String: Any]()
            if let locale = locale { o["locale"] = locale }
            if let localeId = localeId { o["localeId"] = localeId }
            if let gender = gender { o["gender"] = gender }
            if let peopleId = peopleId { o["peopleId"] = peopleId }
            if let peopleIndex = peopleIndex { o["peopleIndex"] = peopleIndex }
            if let backgroundMusic = backgroundMusic { o["backgroundMusic"] = backgroundMusic }
            if let backgroundMusicId = backgroundMusicId { o["backgroundMusicId"] = backgroundMusicId }
            if let peopleName = peopleName { o["peopleName"] = peopleName }
            o["backgroundMusicVolume"] = backgroundMusicVolume
            o["isFirstLaunched"] = isFirstLaunched
            return o
        }
    }
    
    override func setValuesForKeys(_ keyedValues: [String : Any]) {
        for (key, value) in keyedValues {
            if key == "locale" { locale = value as? String }
            if key == "gender" { gender = value as? String }
            if key == "backgroundMusic" { backgroundMusic = value as?  String }
            if key == "peopleId" { peopleId = value as?  String }
            if key == "peopleName" { peopleName = value as?  String }
            if key == "peopleIndex" { peopleIndex = value as? Int }
            if key == "isFirstLaunched" { isFirstLaunched = (value as? Bool)! }
            if key == "backgroundMusicVolume" { backgroundMusicVolume = value as! Float }
            //print(key, " - " ,value)
        }
    }
    

}
