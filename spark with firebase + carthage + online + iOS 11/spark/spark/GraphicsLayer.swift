//
//  GraphicsLayer.swift
//  spark
//
//  Created by Vikesh on 15/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class GraphicsLayer: CALayer {
    
    var shapeLayers: [CAShapeLayer]!
    
    override init() {
        super.init()
        shapeLayers = [CAShapeLayer]()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(){}
    
    func create(_ size : CGSize = CGSize(width: 25, height: 25)) -> CALayer {
        return self
    }
    
    func addPulsation (_ shape: CAShapeLayer) {
        let scale:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scale.duration = 0.4
        scale.repeatCount = 5
        scale.autoreverses = true
        scale.fromValue = 1.05;
        scale.toValue = 0.95;
        shape.add(scale, forKey: "scale")
        shape.anchorPoint = CGPoint(x: 1, y: 0.5)
    }
    
    func zoomBounce(_ shape: CAShapeLayer) {
       
        let fa = CAKeyframeAnimation(keyPath: "transform")
        fa.values = [
            NSValue.init(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(1.4, 1.4, 1)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(0.8, 0.8, 1)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1))]
        
        fa.keyTimes = [0,0.5,0.9,1]
        fa.fillMode = kCAFillModeForwards
        fa.isRemovedOnCompletion = false
        fa.duration = 0.18
        shape.add(fa, forKey: "ZoomBounce")
    }

    
}
