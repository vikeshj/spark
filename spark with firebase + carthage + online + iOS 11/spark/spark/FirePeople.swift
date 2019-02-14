//
//  FirePeople.swift
//  spark
//
//  Created by Vikesh on 21/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import Foundation

struct FirePeople: Codable {
    var id: String
    var name: String
    var gender: String
    var sampleVoice: Generic
    var audioPath: Generic
    var language: Language
    var isSelected: Bool = false
    var active: Bool
    
    enum FirePeopleKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case gender = "gender"
        case sampleVoice = "sampleVoice"
        case audioPath = "audioPath"
        case language = "language"
        case active = "active"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: FirePeopleKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        active = try values.decode(Bool.self, forKey: .active)
        gender = try values.decode(String.self, forKey: .gender)
        sampleVoice = try values.decode(Generic.self, forKey: .sampleVoice)
        audioPath = try values.decode(Generic.self, forKey: .audioPath)
        language = try values.decode(Language.self, forKey: .language)
    }
}

struct Language: Codable {
    var en: Bool?
    var fr: Bool?
}

struct Generic: Codable {
    var en: String?
    var fr: String?
}
