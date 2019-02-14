//
//  ConfigurationViewController.swift
//  spark
//
//  Created by Vikesh on 11/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//


import UIKit

let kNotificationLanguageChanged  = "kNotificationLanguageChanged";

func Localization(key text:String) -> String{
    return Localisator.shared.localized(key: text)
}

func SetLanguage(_ locale:String) {
    _ = Localisator.shared.localized(language: locale)
}

class Localisator {
   
    // MARK: - Private properties
    
    fileprivate let userDefaults  = UserDefaults.standard
    fileprivate var availableLanguagesArray = ["DeviceLanguage", "en", "fr", "es"]
    fileprivate var dicoLocalisation:NSDictionary!
    
    
    fileprivate let kSaveLanguageDefaultKey = "kSaveLanguageDefaultKey"
    
    // MARK: - Public properties
    
    var current = "DeviceLanguage"
    
    // MARK: - Public computed properties
    
    var saveInUserDefaults:Bool {
        get {
            return (userDefaults.object(forKey: kSaveLanguageDefaultKey) != nil)
        }
        set {
            if newValue {
                userDefaults.set(current, forKey: kSaveLanguageDefaultKey)
            } else {
                userDefaults.removeObject(forKey: kSaveLanguageDefaultKey)
            }
            userDefaults.synchronize()
        }
    }
    
    
    // MARK: - Singleton method
    static var shared: Localisator = Localisator()
    
    
    // MARK: - Init method
    init() {          
        if let languageSaved = userDefaults.object(forKey: kSaveLanguageDefaultKey) as? String {
            if languageSaved != "DeviceLanguage" {
               _ = self.loadDictionaryForLanguage(languageSaved)
            }
        }
    }
    
    // MARK: - Public custom getter
    
    func getArrayAvailableLanguages() -> [String] {
        return availableLanguagesArray
    }
    
 
    // MARK: - Private instance methods
    // \param newLanguage: en, fr, es
    fileprivate func loadDictionaryForLanguage(_ newLanguage:String) -> Bool {
        
        let arrayExt = newLanguage.components(separatedBy: "_")
        
        for ext in arrayExt {
            if let path = Bundle(for: object_getClass(self)!).url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: ext)?.path  {
                if FileManager.default.fileExists(atPath: path) {
                    current = newLanguage
                    dicoLocalisation = NSDictionary(contentsOfFile: path)
                    return true
                }
            }
        }
        return false
    }
    
    // MARK: - Internal methods
    /// localize with language key
    fileprivate func localized(key:String) -> String {
        
        if let dico = dicoLocalisation {
            if let localizedString = dico[key] as? String {
                return localizedString
            }  else {
                return key
            }
        } else {
            return NSLocalizedString(key, comment: "")
        }
    }
    
    /// localize with language en, fr or es
    fileprivate func localized(language:String) -> Bool {
        
        if (language == current) || !availableLanguagesArray.contains(language) {
            return false
        }
        
        if language == "DeviceLanguage" {
            current = language
            dicoLocalisation = nil
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)
            return true
        } else if loadDictionaryForLanguage(language) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)
            if saveInUserDefaults {
                userDefaults.set(current, forKey: kSaveLanguageDefaultKey)
                userDefaults.synchronize()
            }
            return true
        }
        return false
    }
}

