//
//  Voices.swift
//  spark
//
//  Created by Vikesh on 27/08/2016.
//  Copyright © 2016 Vikesh JOYPAUL. All rights reserved.
//

import Foundation

public enum GENDER: Int {
    case male = 0, female
    
    var description: String {
        switch self {
        case .male: return "male"
        case .female : return "female"
        }
    }
}


class People: NSObject {
    var name: String!
    var gender: String!
    var voicePath: String!
    var color: NSArray!
}
