//
//  Dispatcher.swift
//  spark
//
//  Created by Vikesh on 22/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import Foundation

struct DispatchUtils {
    
    static func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
}
