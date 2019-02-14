//
//  SVGRadio.swift
//  coredataDemo
//
//  Created by Vikesh JOYPAUL on 19/10/2016.
//  Copyright © 2016 Vikesh JOYPAUL. All rights reserved.
//

import UIKit

private let kInnerRadiusScaleFactor = CGFloat(0.09)

@IBDesignable class SVGRadioButton: UIButton {
    
    
    @IBInspectable override var isSelected: Bool {
        didSet {
            dot.isHidden = isSelected == true ? false : true
            if(isSelected){
                self.animate()
            }
        }
    }
    
    @IBInspectable var color: UIColor = UIColor.white
    @IBInspectable var isToucheEnabled:Bool = false
    
    fileprivate var outline = CAShapeLayer()
    fileprivate var dot = CAShapeLayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit() {
        if(isToucheEnabled == true) {
            self.addTarget(self, action: #selector(SVGRadioButton.touchUpInsideHandler), for: .touchUpInside)
        }else {
            isUserInteractionEnabled = false
        }
    }

    
    override func draw(_ rect: CGRect) {
        
        func d2R(_ degrees: CGFloat) -> CGFloat {
            return degrees * 0.0174532925 // 1 degree ~ 0.0174532925 radians
        }
        
        let arcWidth = (rect.width * kInnerRadiusScaleFactor)
        let radius = (rect.midY - arcWidth/2)
        
        outline.path = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: d2R(0), endAngle: d2R(359.9), clockwise: true).cgPath
        outline.strokeColor = color.cgColor
        outline.fillColor = UIColor.clear.cgColor
        outline.lineWidth = arcWidth
        self.layer.addSublayer(outline)
        
        let num: CGFloat = 10.0
        let dotRect = CGRect(x: num/2, y: num/2, width: (rect.width - num), height: (rect.height - num)) //CGRect(x: (arcWidth + rect.midX) / 2, y: (arcWidth + midY) / 2, width: radius, height: radius)
        dot.path = UIBezierPath(ovalIn: dotRect).cgPath
        dot.strokeColor = UIColor.clear.cgColor
        dot.fillColor = color.cgColor
        dot.lineWidth = arcWidth
        dot.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.addSublayer(dot)
        
    }
    
    @objc func touchUpInsideHandler(_ sender: UIButton){
        isSelected = !isSelected
    }
    
    
    fileprivate func animate() {
        let t1 = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.transform = t1
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.225, initialSpringVelocity: 0.7, options: .beginFromCurrentState, animations: { () -> Void in
            let t2 = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.transform = t2
            }, completion: { (b) -> Void in
                //
        })
    }
 

}
