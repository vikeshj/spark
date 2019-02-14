//
//  DataManager.swift
//  spark
//  https://learnappdevelopment.com/uncategorized/how-to-use-core-data-in-ios-10-swift-3/
//  https://developer.apple.com/reference/coredata/nsmanagedobjectcontext
//  best->  http://jamesonquave.com/blog/core-data-in-swift-tutorial-part-3/
//  http://www.learncoredata.com/create-retrieve-update-delete-data-with-core-data/
//
//  Created by Vikesh on 11/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import Foundation
import UIKit
import CoreData



/// firebase database key
class FireBaseKey {
    
    static let themes: String = "themes"
    static let people: String = "people"
    static let voices: String = "voices"
    static let playlists: String = "playlists"
    static let defaults: String = "defaults"
    
    // filter voices into theme grouping
}

/// local device keys
class UserSharedKey {
    
    static let user: String = "user"
    static let voiceId: String = "voiceId"
    static let backgroundSound: String = "backgroundSound"
    static let gender: String = "gender"
    static let isFirstLaunched: String = "isFirstLaunched"
}

/// spark locale
public enum SparkLocale: String, CustomStringConvertible {
    case english = "en"
    case french = "fr"
    
    public var description: String {
        switch self {
            case .english: return "en"
            case .french: return "fr"
        }
    }
    
    var index: Int {
        switch  self {
            case .english: return 0
            case .french: return 1
        }
    }
}

public enum SparkGender: String {
    case male = "male"
    case female = "female"
    
    var description: String {
        switch self {
            case .male: return "male"
            case .female: return "female"
        }
    }

}

/// spark background music
public enum SparkBackgroundMusic: String, CustomStringConvertible {
    case air = "air"
    case earth = "earth"
    case fire = "fire"
    case water = "water"
    
    public var description: String {
        switch  self {
            case .air: return "air"
            case .earth: return "earth"
            case .fire: return "fire"
            case .water: return "water"
        }
    }
    
    var index: Int {
        switch  self {
            case .air: return 0
            case .earth: return 1
            case .fire: return 2
            case .water: return 3
        }
    }
}

class SparkDataService {
    
    ///share instance bridge singleton
    static let shared = SparkDataService()
    
    //stores current user info
    static let user: User = User()
    
    
    /// store the spark plist information
    internal var sparkDictionary: Dictionary<String, AnyObject>!
    
    
    /// retieve resource file withing Spark
    static func resource(_ fileName: String) -> [String: AnyObject] {
        let resoucePath = Bundle.main.path(forResource: fileName, ofType: "plist")!
        let dictionary =  NSDictionary(contentsOfFile: resoucePath) as! [String: AnyObject]
        return dictionary
    }
    
    /// retieve spark dictionary infos
    class func dictionary(_ forKey: String) -> [[String:AnyObject]] {
        guard let dictionary = shared.sparkDictionary[forKey] else { return [] }
        return dictionary as! [[String : AnyObject]]
    }
    
   
    /// https://learnappdevelopment.com/uncategorized/how-to-use-core-data-in-ios-10-swift-3/
    // MARK: - Core Data Context
    var context: NSManagedObjectContext {
        get {
            return  appDelegate.persistentContainer.viewContext
        }
    }
    
    var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    
    var save: Any {
        get { return appDelegate.saveContext() }
    }
    
    /// FIREBASE DATABASE
    var database: DatabaseReference {
        get { return Database.database().reference() }
    }
    
    var isUserLoggedIn: Bool {
        get { return Auth.auth().currentUser?.uid != nil }
    }
    
    func firebaseChildnode(_ key: String) -> DatabaseReference {
        return Database.database().reference(withPath: key)
    }
    
    func fireabaseStorageNode(_ key: String) -> StorageReference {
        return Storage.storage().reference(withPath: "spark").child(key)
    }
    
    var signOut: Bool {
        get {
            do {
                try Auth.auth().signOut()
                SparkDataService.user.reset = true
                return true
            } catch let error {
                print(error)
                return false
            }
        }
    }
    
    
    //UserDefault 
    func addUserKey(_ value: Any, forKey name: String) {
        UserDefaults.standard.set(value, forKey: name)
        UserDefaults.standard.synchronize()
    }
    
    func isKeyExists(_ key: String) -> Bool {
        return UserDefaults.standard.value(forKey: key) != nil
    }
    
    func getKeyValue(_ key: String) -> Any {
        if(isKeyExists(key)){
            return UserDefaults.standard.value(forKey: key)!
        }
        return -1
    }
    
    func removeUserKey(_ name: String){
        if isKeyExists(name) {
            UserDefaults.standard.removeObject(forKey: name)
            UserDefaults.standard.synchronize()
        }
    }
}
