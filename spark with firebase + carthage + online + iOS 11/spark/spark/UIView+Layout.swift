//
//  Extensions.swift
//  spark
//
//  Created by Vikesh on 09/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ---- UIView ----
extension UIView {
    
    func addContraintWithVisual(_ format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func anchorToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
    }
    
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
}

class Layout {
    
    static var sharedInstance: Layout = Layout()
    static let deviceType = UIDevice.current.deviceType
    
    var topContantForBubble: CGFloat {
        get {
            return Layout.sharedInstance.bubbleTopContant()
        }
    }
    
    
    var voiceComponentHeight: CGFloat {
        get {
            return Layout.sharedInstance.voiceSelectionHeight()
        }
    }
    
    var cellHelight: CGFloat {
        get {
            return Layout.sharedInstance.collectionViewCellHeight()
        }
    }
    
    // for home menu top height
    fileprivate func bubbleTopContant() -> CGFloat {
        switch Layout.deviceType {
        case .iPhone5, .iPhone5C, .iPhone5S, .iPhoneSE, .simulator:
            return 180
        default:
            return 230
        }
        
    }
    
    // for configuration page
    fileprivate func voiceSelectionHeight() -> CGFloat {
        switch Layout.deviceType {
            case .iPhone5, .iPhone5C, .iPhone5S, .iPhoneSE, .simulator:
                return 190
            default: return 260
        }

    }
    
    // for themes cell height
    fileprivate func collectionViewCellHeight() -> CGFloat {
        switch Layout.deviceType {
            case .iPhone5, .iPhone5C, .iPhone5S, .iPhoneSE, .simulator:
                return 126
            case .iPhone6Plus, .iPhone7Plus:
                return 163
            default: return 148
        }
        
    }
}

///http://stackoverflow.com/a/40697735
extension UIView {
    func roundCorners(_ corner: UIRectCorner,_ radii: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.layer.bounds
        maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii)).cgPath
        
        self.layer.mask = maskLayer
        self.layer.masksToBounds = true
    }
}
