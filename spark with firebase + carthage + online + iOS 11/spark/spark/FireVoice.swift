//
//  Voice.swift
//  spark
//
//  Created by Vikesh on 21/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import Foundation

struct FireVoice: Codable {
    var download: Bool
    var id: String
    var themeType: String
    var title:Title
    var voices: Track
    
    var peopleId: String = ""
    var themeTitle: String = ""
    var isSelected: Bool = false
    
    enum FireVoiceKeys: String, CodingKey {
        case download = "download"
        case id = "id"
        case themeType = "themeType"
        case title = "title"
        case voices = "voices"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: FireVoiceKeys.self)
        download = try values.decode(Bool.self, forKey: .download)
        id = try values.decode(String.self, forKey: .id)
        themeType = try values.decode(String.self, forKey: .themeType)
        title = try values.decode(Title.self, forKey: .title)
        voices = try values.decode(Track.self, forKey: .voices)
    }

}

struct Title: Codable {
    var en: String?
    var fr: GenderObject
}

struct Track: Codable {
    var en: String?
    var fr: GenderObject
}

struct GenderObject: Codable {
    var male: String?
    var female: String?
}


