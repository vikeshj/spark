//
//  RadioCircleButton.swift
//  spark
//
//  Created by Vikesh on 16/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class RadioCircleButton: GraphicsLayer {
    
    var size: CGSize!
    var innerShape: CAShapeLayer! = {
        let shape = CAShapeLayer()
        return shape
    }()
    
    var outlineShape: CAShapeLayer!
    
    override func create(_ size: CGSize = CGSize(width: 26, height: 26)) -> CALayer {
        
        let context = UIGraphicsGetCurrentContext()
        self.size = size
        
        //outline
        outlineShape = CAShapeLayer()
        outlineShape.name = "outline"
        outlineShape.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.height)).cgPath
        outlineShape.strokeColor = UIColor.white.cgColor
        outlineShape.lineWidth = 3
        outlineShape.fillColor = UIColor.clear.cgColor
    
        innerShape.position = CGPoint(x: size.width / 2, y: size.height / 2)
        innerShape.fillColor = UIColor.white.cgColor
        noInnerCircle()
        context?.restoreGState()
        
        self.addSublayer(outlineShape)
        self.addSublayer(innerShape)
        
        shapeLayers.append(outlineShape)
        shapeLayers.append(innerShape)
        
        return self
    }
    
    func withInnerCircle(){
        //let half = size.width / 2;
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        guard innerShape != nil else {
            return
        }
        //innerShape.path = UIBezierPath(ovalIn: CGRect(x: -(half / 2), y: -(half / 2), width: half, height: half)).cgPath
        innerShape.path = UIBezierPath(ovalIn: CGRect(x: -(rect.midX / 2), y: -(rect.midY / 2), width: rect.width / 2, height: rect.width / 2)).cgPath
        zoomBounce(innerShape)
        zoomBounce(outlineShape)
    }
    
    func noInnerCircle(){
        let half = size.width / 2;
        guard innerShape != nil else {
            return
        }
        innerShape.path = UIBezierPath(ovalIn: CGRect(x: -(half / 2), y: -(half / 2), width: 0, height: 0)).cgPath
    }
    
    deinit {
        size = nil
        innerShape = nil
    }
    
}
