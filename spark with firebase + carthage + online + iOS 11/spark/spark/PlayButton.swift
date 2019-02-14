//
//  PlayButton.swift
//  spark
//
//  Created by Vikesh on 15/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class PlayButton: GraphicsLayer {
    
    var progressShape: CAShapeLayer!
    
    override func setup() {
        createProgress()
        backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor
    }
    
    override func create(_ size:CGSize = CGSize(width: 26, height: 26)) -> CALayer {
        
        let context = UIGraphicsGetCurrentContext()
        
        //outline
        let outlineShape = CAShapeLayer()
        outlineShape.name = "outline"
        outlineShape.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.height)).cgPath
        outlineShape.strokeColor = UIColor.white.cgColor
        outlineShape.lineWidth = 3
        outlineShape.fillColor = UIColor.clear.cgColor
        
        let innerShape = CAShapeLayer()
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 10, y: 6))
        bezier.addLine(to: CGPoint(x: 10, y: 20))
        bezier.addLine(to: CGPoint(x: 20, y: 13))
        bezier.addLine(to: CGPoint(x: 10, y: 6))
        bezier.close()
        bezier.lineCapStyle = .round
        innerShape.path = bezier.cgPath
        innerShape.fillColor = UIColor.white.cgColor
        
        context?.restoreGState()
        
        addSublayer(outlineShape)
        addSublayer(innerShape)
        
        shapeLayers.append(outlineShape)
        shapeLayers.append(innerShape)
        
        return self
    }
    
    func createProgress(){
        progressShape = CAShapeLayer()
        progressShape.name = "progress"
        progressShape.setAffineTransform(CGAffineTransform(rotationAngle: -90 * CGFloat.pi / 180))
        progressShape.strokeColor = UIColor.white.withAlphaComponent(0.6).cgColor
        progressShape.lineWidth = 4
        progressShape.fillColor = .none
        progressShape.position = CGPoint(x: 13, y: 13)
        
        addSublayer(progressShape)
        shapeLayers.append(progressShape)
        progress(200)
    }
    
    func progress(_ value: CGFloat) {
        let rect = CGRect(x: 0, y: 0, width: 21, height: 21)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x:0, y: 0), radius: rect.width/2, startAngle: 0 * CGFloat.pi / 180, endAngle: -value * CGFloat.pi/180, clockwise: true)
        progressShape.path = path.cgPath
        context?.restoreGState()
    }
}
