//
//  SVGPlusButton.swift
//  spark
//
//  Created by Vikesh on 23/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

@IBDesignable class SVGPlusButton: UIButton {
    
    
    @IBInspectable var color: UIColor = UIColor.white
    @IBInspectable var selectColor: UIColor = UIColor(red: 75, green: 217, blue: 99)
    @IBInspectable var isToucheEnabled:Bool = false
    
    
    fileprivate var plusIcon: CAShapeLayer = CAShapeLayer()
    fileprivate var circle: CAShapeLayer = CAShapeLayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    
    func sharedInit(){
        if(isToucheEnabled == true) {
            self.addTarget(self, action: #selector(SVGRadioButton.touchUpInsideHandler), for: .touchUpInside)
        } else {
            isUserInteractionEnabled = false
        }

    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    
}
