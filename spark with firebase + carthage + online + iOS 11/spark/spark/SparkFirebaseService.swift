//
//  SparkFirebaseServiceRequest.swift
//  spark
//
//  Created by Vikesh on 21/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit
import CodableFirebase

class SparkFirebaseService: NSObject {
    
    static let shared: SparkFirebaseService = SparkFirebaseService()
    var cache = [String: Bool]()
    var snackbar:TTGSnackbar!
    
    func connectionService(){
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            
            if let connected = snapshot.value as? Bool, connected {
                self.createSnackBarWithIcon(Localization(key: Spark.ONLINE_MODE), icon: UIImage(), time: .middle, bottomMargin: 5, color: UIColor(red: 54, green: 155, blue: 250))
            } else {
                self.createSnackBarWithIcon(Localization(key: Spark.OFFLINE_MODE), icon: #imageLiteral(resourceName: "warning"), time: .middle)
            }
        })
    }
    
    func createSnackBarWithIcon(_ message: String, icon: UIImage, time: TTGSnackbarDuration, bottomMargin: CGFloat = 5, color: UIColor = .red ){
        
        guard snackbar == nil else { return }
        snackbar = TTGSnackbar(message: message, duration: time)
        snackbar.icon = icon
        snackbar.bottomMargin = bottomMargin
        snackbar.animationType = .slideFromBottomBackToBottom
        snackbar.iconContentMode = .scaleAspectFit
        snackbar.backgroundColor = color.withAlphaComponent(0.85)
        snackbar.show()
        snackbar.dismissBlock = { snack in  self.snackbar = nil }
    }
    
    
    //get peoples
    func fetchPeople(_ completion: @escaping ([FirePeople]) -> ()){
        //
        SwiftSpinner.show(Localization(key: Spark.IN_PROGRESS), animated: true)
        var dataprovider = [FirePeople]()
        let peopleReference = SparkDataService.shared.firebaseChildnode(FireBaseKey.people)
        
        peopleReference.observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            do {
                if let peoples = value as? [[String: AnyHashable]] {
                    for people in peoples {
                        let firePeople = try FirebaseDecoder().decode(FirePeople.self, from: people)
                        dataprovider.append(firePeople)
                    }
                }
                
            } catch let error {
                print(error)
            }
            
            SwiftSpinner.hide()
            DispatchQueue.main.async(execute: {
                completion(dataprovider)
            })
            
        })
    }
    
    /// get themes list
    func fetchThemes(_ completion: @escaping ([FireTheme]) -> ()) {
        var dataprovider = [FireTheme]()
        let themeReference = SparkDataService.shared.firebaseChildnode(FireBaseKey.themes)
        themeReference.observe(.value, with: { snapshot in
            guard let raw = snapshot.value else { return }
            do {
                if let themes = raw as? [[String: AnyHashable]] {
                    for theme in themes {
                        let firetheme = try FirebaseDecoder().decode(FireTheme.self, from: theme)
                        dataprovider.append(firetheme)
                    }
                }
            } catch let error {
                print("unable to parse the JSON \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async(execute: {
                completion(dataprovider)
            })
        })
    }
    
    func fetchTracks(_ themeType:String, completion: @escaping ([FireVoice]) -> ()){
        SwiftSpinner.show(Localization(key: Spark.IN_PROGRESS), animated: true)
        var dataprovider = [FireVoice]()
        let voicesReference = SparkDataService.shared.firebaseChildnode(FireBaseKey.voices).child(themeType)
        voicesReference.queryOrdered(byChild: "themeType")
            .queryEqual(toValue: themeType)
            .observe(.value, with: { (snapshot) in
                guard let raw = snapshot.value else { return }
                
                do {
                    if let voices = raw as? [[String: AnyHashable]] {
                        for voice in voices {
                            let firevoice = try FirebaseDecoder().decode(FireVoice.self, from: voice)
                            dataprovider.append(firevoice)
                        }
                    }
                    
                } catch let error {
                    print(error.localizedDescription, "=> \(themeType)")
                }
        
                DispatchQueue.main.async(execute: {
                    SwiftSpinner.hide()
                    completion(dataprovider)
                })
            })
    }
    
    func fetchSingleTrack(_ voiceId:String,  completion: @escaping ([FireVoice]) -> ()){
        let playlistRef = SparkDataService.shared.firebaseChildnode(FireBaseKey.voices).child("burn-out")
        playlistRef.queryOrdered(byChild: "id").queryEqual(toValue: voiceId)
            .observe(.value, with:{ (snapshot) in
                print(snapshot.value!)
            })
        
    }
    
    /**
     * PLAYLIST
     ***/
    
    func fectchPlaylistSingleEvent(completion: @escaping ([FirePlaylist]) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        SwiftSpinner.show(Localization(key: Spark.IN_PROGRESS), animated: true)
        let playlsRef = SparkDataService.shared.firebaseChildnode(FireBaseKey.playlists).child(uid)
        let query = playlsRef.queryOrdered(byChild: "peopleId").queryEqual(toValue: SparkDataService.user.peopleId)
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var dataprovider = [FirePlaylist]()
            if(!snapshot.exists()) {
                DispatchQueue.main.async(execute: {
                    SwiftSpinner.hide()
                    completion(dataprovider)
                })
                
                return
            }
            
            if let firePlaylist = snapshot.value as? [String: AnyObject] {
                for (key, value) in  firePlaylist {
                    do {
                        var playlist = try FirebaseDecoder().decode(FirePlaylist.self, from: value)
                        playlist.id = key
                        dataprovider.append(playlist)
                    } catch let error { print(error) }
                }
                
                DispatchQueue.main.async(execute: {
                    SparkAudioService.shared.delayWithSeconds(0.1, completion: {
                        completion(dataprovider)
                    })
                })
            }
            SwiftSpinner.hide()
        })
    }
    
    func fetchUserPlayerList(_ filter:String, key: String, completion: @escaping ([FirePlaylist]) -> ()){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        SwiftSpinner.show(Localization(key: Spark.IN_PROGRESS), animated: true)
        
        /// trigger between defauts / user playlists
        let playlistRef = key == FireBaseKey.playlists ? SparkDataService.shared.firebaseChildnode(key).child(uid) : SparkDataService.shared.firebaseChildnode(key)
        
        var query:DatabaseQuery!
        query = playlistRef
        query.queryOrdered(byChild: "title").observe(.value, with: { (snapshot) in
            var dataprovider = [FirePlaylist]()
            if(!snapshot.exists()) {
                DispatchQueue.main.async(execute: {
                    SwiftSpinner.hide()
                    completion(dataprovider)
                })
                return
            }
            
            if let playlists = snapshot.value as? [String: AnyObject] {
                for (key, value) in playlists {
                    do {
                        var fplaylist = try FirebaseDecoder().decode(FirePlaylist.self, from: value)
                        fplaylist.id = key
                        if let v1 = value as? [String: AnyObject] {
                            for o in v1 {
                                if o.key == "voices" {
                                    if let v2 = o.value as? [String: AnyObject] {
                                        //guard v2.count <= 0 else { return }
                                        fplaylist.voices = [Voice]()
                                        for m in v2 {
                                            var voices = try FirebaseDecoder().decode(Voice.self, from: m.value)
                                            voices.fkey = m.key
                                            fplaylist.voices?.append(voices)
                                        }
                                    }
                                }
                            }
                        }
                        dataprovider.append(fplaylist)
                    } catch let error { print(error.localizedDescription) }
                }
            }
            
            DispatchQueue.main.async(execute: {
                SwiftSpinner.hide()
                SparkAudioService.shared.delayWithSeconds(0.1, completion: {
                    completion(dataprovider)
                })
            })
            
        })
    }
    
    /// https://firebase.google.com/docs/database/ios/read-and-write
    func create(_ playlist: Playlist, title: String ,completion: () -> ()){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let reference = SparkDataService.shared.firebaseChildnode(FireBaseKey.playlists).child(uid).childByAutoId()
        let autoId = reference.childByAutoId()
        
        
        if let voice = playlist.voice {
            
            let updateVoice = [
                "order": 0, "id": voice.id!,
                "themeType": voice.themeType!, "download" : voice.download,
                "date": voice.date!,
                "title": voice.title!, "track": voice.track!] as [String : Any]
            let voices = ["\(autoId.key)" : updateVoice]
            let post = ["peopleId": playlist.peopleId!, "locale": playlist.locale!,
                        "userGender": playlist.userGender!, "title": playlist.title!,
                        "peopleName": playlist.peopleName!, "backgroundMusic": playlist.backgroundMusic!, "date": playlist.date!,
                        "duration":"", "voices": voices] as [String : Any]
            reference.setValue(post)
            completion()
        }
    }
    
    func append(_ playlistId:String, voice: PlaylistVoice,  completion: @escaping (_ success: Bool) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        SwiftSpinner.show(Localization(key: Spark.IN_PROGRESS), animated: true)
        let addPlaylistRef = SparkDataService.shared.firebaseChildnode(FireBaseKey.playlists)
            .child(uid).child(playlistId).child(FireBaseKey.voices).childByAutoId()
        
        let voice = ["order": 0,
                     "id": voice.id!,
                     "themeType": voice.themeType!,
                     "download" : voice.download,
                     "date": voice.date!,
                     "title": voice.title!,
                     "track": voice.track!] as [String : Any]
        
        addPlaylistRef.updateChildValues(voice, withCompletionBlock: { (error, ref) in
            if(error != nil) {
                print(error!.localizedDescription)
                SwiftSpinner.hide()
            }
            DispatchQueue.main.async(execute: {
                SwiftSpinner.hide()
                completion(true)
            })
        })
    }
    
    func removePlaylist(_ playlistId: String, completion: @escaping (_ success: Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let removeRef = SparkDataService.shared.firebaseChildnode(FireBaseKey.playlists).child(uid).child(playlistId)
        removeRef.removeValue { (error, ref) in
            if(error != nil){
                print("error removing playlist")
                return
            }
            completion(true)
        }
    }
    
    func removeVoiceTrack(_ playlistId: String, trackId: String, completion: @escaping (_ success: Bool) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let trackRef = SparkDataService.shared.firebaseChildnode(FireBaseKey.playlists)
            .child(uid).child(playlistId)
            .child("voices").child(trackId)
        trackRef.removeValue { (error, ref) in
            if(error != nil) {
                print("error removing track")
                return
            }
            
            completion(true)
        }
    }
    
    func updatePlaylistTitle(_ playlist: FirePlaylist, title: String, completion: @escaping (_ success: Bool) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let updateRef = SparkDataService.shared.firebaseChildnode(FireBaseKey.playlists).child(uid).child(playlist.id)
        updateRef.updateChildValues(["title": title], withCompletionBlock: { (error, ref) in
            if(error != nil) {
                return
            }
            completion(true)
        })
        
    }
    
}

extension Collection {
    var jsonData: Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        } catch {
            return nil
        }
    }
}

