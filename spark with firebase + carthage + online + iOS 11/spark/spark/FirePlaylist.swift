//
//  FirePlaylist.swift
//  spark
//
//  Created by Vikesh on 02/11/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import Foundation

struct FirePlaylist: Codable {
    
    ///backgroundMusic
    var backgroundMusic: String
    
    /// keep tracks of the playlist date added
    var date: String
    
    /// duration
    var duration: String
    
    /// the selected language
    var locale: String
    
    /// people name
    var peopleName: String
    
    /// the selected voice from the voice selection in the configuration panel
    var peopleId: String
    
    ///title of the playlist
    var title: String
    
    /// either user is a he or she after chosing it has to be locked
    var userGender: String
    
  
    ///Category // user / default
    var category: String = ""
    
    /// the playlistId
    var id: String = ""
    
    /// the array of voices
    var voices: [Voice]?
    
    enum FirePlaylistKey: String, CodingKey {
        case backgroundMusic
        case date
        case duration
        case locale
        case peopleId
        case peopleName
        case title
        case userGender
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: FirePlaylistKey.self)
        backgroundMusic = try values.decode(String.self, forKey: .backgroundMusic)
        date = try values.decode(String.self, forKey: .date)
        duration = try values.decode(String.self, forKey: .date)
        locale = try values.decode(String.self, forKey: .locale)
        peopleId = try values.decode(String.self, forKey: .peopleId)
        peopleName = try values.decode(String.self, forKey: .peopleName)
        title = try values.decode(String.self, forKey: .title)
        userGender = try values.decode(String.self, forKey: .userGender)
    }
    
}

struct Voice: Codable {
    var date: String
    var download: Bool
    var id: String
    var order: Int
    var themeType: String
    var title: String
    var track: String
    var fkey: String = ""
    var playlistId: String = ""
    
    
    enum VoiceKey: String, CodingKey {
        case date
        case download
        case id
        case order
        case themeType
        case title
        case track
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: VoiceKey.self)
        date = try values.decode(String.self, forKey: .date)
        download = try values.decode(Bool.self, forKey: .download)
        id = try values.decode(String.self, forKey: .id)
        order = try values.decode(Int.self, forKey: .order)
        themeType = try values.decode(String.self, forKey: .themeType)
        title = try values.decode(String.self, forKey: .title)
        track = try values.decode(String.self, forKey: .track)
    }
}



// simple objects
struct Playlist {
    var peopleId: String?
    var peopleName: String?
    var locale: String?
    var userGender: String?
    var title: String?
    var duration: String?
    var backgroundMusic: String?
    var category: String?
    var date: String?
    var voice: PlaylistVoice?
}


struct PlaylistVoice {
    var order: Int?
    var id: String?
    var themeType: String?
    var download: Bool = false
    var title: String?
    var track: String?
    var playlistId: String?
    var date: String?
}
