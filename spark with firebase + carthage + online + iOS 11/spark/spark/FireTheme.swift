//
//  FireTheme.swift
//  spark
//
//  Created by Vikesh on 21/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import Foundation

struct FireTheme: Codable {
    var themeType: String
    var picture: Picture
    var name: LocaleName
    
    /*enum FireThemeKeys: String, CodingKey {
        case picture = "picture"
        case name = "name"
        case themeType = "themeType"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: FireThemeKeys.self)
        themeType = try values.decode(String.self, forKey: .themeType)
        picture = try values.decode(Picture.self, forKey: .picture)
        name = try values.decode(LocaleName.self, forKey: .name)
    }*/
}

struct LocaleName: Codable {
    var en: String
    var fr: String
}

struct Picture: Codable {
    var en: Device
    var fr: Device
}

struct Device: Codable {
    var iphone: Assets
    var ipad: Assets
}

struct Assets: Codable {
    var x1: String
    var x2: String
    var x3: String
}



