//
//  AnimatedGraphicsView.swift
//  spark
//
//  Created by Vikesh on 15/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class AnimatedGraphicsView: UIButton {
    
    var graphicType: GraphicType! {
        didSet {
            if(self.sprite != nil) {
                self.sprite.removeFromSuperlayer()
            }
            self.sprite = change(graphicType)
        }
    }
    
    var fill: CGColor! {
        didSet {
            apply(fill)
        }
    }
    
    var sprite: GraphicsLayer! {
        didSet {
            layer.addSublayer(sprite)
        }
    }
    
    fileprivate func change(_ type: GraphicType) -> GraphicsLayer {
        switch type {
        case .play:
            return PlayButton().create() as! GraphicsLayer
        case .radio:
            return RadioCircleButton().create() as! GraphicsLayer
        default:
            return GraphicsLayer()
        }
    }
    
    fileprivate func apply(_ color: CGColor){
        for shape in sprite.shapeLayers {
            if(shape.name == "outline") {
               shape.strokeColor = color
            } else {
                shape.fillColor = color
            }
        }
    }
    
    /// animations
    func animateIn() {
        guard graphicType != nil else { return }
        if(graphicType == GraphicType.radio) {
            let radio = sprite as! RadioCircleButton
            radio.withInnerCircle()
        }
    }
    func animateOut() {
        guard graphicType != nil else { return }
        if(graphicType == GraphicType.radio) {
            let radio = sprite as! RadioCircleButton
            radio.noInnerCircle()
        }
    }
}
