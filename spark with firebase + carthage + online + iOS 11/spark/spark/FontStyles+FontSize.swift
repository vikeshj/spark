//
//  FontStyles+FontSize.swift
//  spark
//
//  Created by Vikesh on 12/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class FontStyles: NSObject {
    
    static let shared: FontStyles = FontStyles()
    
    static let PFREGALTEXTPRO_BLACK_ITALIC = "PFRegalTextPro-BlackItalic"
    
    static func printFontSyles(){
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            //if familyName == "Helvetica Neue" {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
            //}
        }
    }
}


class FontSize {
    
    static var shared: FontSize = FontSize()
    static let deviceType = UIDevice.current.deviceType
    
    var titleSize: CGFloat {
        get {
            return FontSize.shared.titleFontSize()
        }
    }
    
    var subTitleSize: CGFloat {
        get {
            return FontSize.shared.subTitleFontSize()
        }
    }
    
    var textSize: CGFloat {
        get {
            return 25.0
        }
    }
    
    var textSize20:CGFloat {
        get { return 20 }
    }
    
    
    // MARK: - Set the title font size according to the device
    /// Title font size set the font size according to the device type
    fileprivate func titleFontSize() -> CGFloat {
        switch FontSize.deviceType {
        case .iPhone4S, .iPhone5, .iPhone5C, .iPhone5S:
            return 35.0
        default:
            return 40.0
        }
    }
    
    // MARK: - Set the subTitle font size according to the device
    /// SubTitle font size set the font size according to the device type
    fileprivate func subTitleFontSize() -> CGFloat {
        
        switch FontSize.deviceType {
        case .iPhone4S, .iPhone5, .iPhone5C, .iPhone5S:
            return 30.0
        default:
            return 30.0
        }
    }
}
