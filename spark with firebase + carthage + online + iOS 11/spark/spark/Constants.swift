//
//  Constants.swift
//  spark
//
//  Created by Vikesh on 09/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Configuration Base of Spark application
struct Config {
    
    /// Webservice root url
    static let BASE_URL = URL(string: "")
    
    /// Spark rescource file
    static let  SPARK_PLIST = "Spark"
}

// MARK: - Colors
struct Color {
    /// Spark normal text color
    static let normalColor = UIColor.white
    
    /// Spark selected text color
    static let selectedColor = UIColor(red: 171, green: 233, blue: 68)
    
    static let gray =  UIColor(red: 122, green: 122, blue: 122)
    
    /// menu - orange (themes)
    static let orange = UIColor(red: 250, green: 117, blue: 36)
    
    /// menu - green (playlists)
    static let green = UIColor(red: 191, green: 247, blue: 234)
    
    /// menu - blue (configuration)
    static let blue = UIColor(red: 105, green: 179, blue: 246)
    
    /// menu - yellow (gallery)
    static let yellow = UIColor(red: 255, green: 205, blue: 0)
    
    /// male color
    static let maleColor = UIColor(red: 44, green: 206, blue: 223)
    
    /// female color
    static let femaleColor = UIColor(red: 232, green: 66, blue: 145)
    
}
