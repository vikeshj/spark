//
//  UIColor+RGB.swift
//  spark
//
//  Created by Vikesh JOYPAUL on 09/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit


// MARK: - ---- UIColor ----
extension UIColor {
    
    /// Create a generic color class
    convenience init(red: CGFloat, green: CGFloat, blue:CGFloat) {
        self.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
}
