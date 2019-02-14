//
//  CircularButtonWithTick.swift
//  spark
//
//  Created by Vikesh on 12/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

open class CircleWithTick: UIView {
    
    //// Color Declarations
    let circleFill = UIColor(red: 0.000, green: 0.447, blue: 0.490, alpha: 1.000)
    let tickFill = UIColor(red: 171, green: 233, blue: 68)
    var circlePath, tickPath : UIBezierPath!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func draw(_ rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.2)
        shadow.shadowOffset = CGSize(width: 3, height: 4)
        shadow.shadowBlurRadius = 5
        
        circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 30, height: 30))
        context!.saveGState()
        context!.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        circleFill.setFill()
        circlePath.fill()
        context!.restoreGState()
        
        //// tick Drawing
        tickPath = UIBezierPath()
        tickPath.move(to: CGPoint(x: 7.5, y: 18))
        tickPath.addLine(to: CGPoint(x: 11.62, y: 21.38))
        tickPath.addLine(to: CGPoint(x: 22.5, y: 9.75))
        tickPath.lineCapStyle = .round;
        
        tickFill.setStroke()
        tickPath.lineWidth = 2
        tickPath.stroke()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func shakeAnimation() {
        let a = CAKeyframeAnimation(keyPath: "position.y")
        a.values = [0, 10, -10, 10, 0]
        a.keyTimes = [0, 0.01666667, 0.5, 0.8333333, 1]
        a.duration = 0.4
        a.isAdditive = true
        layer.add(a, forKey: "shake")
    }
    
    func zoomBounceAnimation() {
        let fa = CAKeyframeAnimation(keyPath: "transform")
        fa.values = [
            NSValue.init(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(1.4, 1.4, 1)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(0.8, 0.8, 1)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1))]
        
        fa.keyTimes = [0,0.5,0.9,1]
        fa.fillMode = kCAFillModeForwards
        fa.isRemovedOnCompletion = false
        fa.duration = 0.3
        layer.add(fa, forKey: "ZoomBounce")
    }
}

/**
 * Enum to create radiobutton like ;=)
 */
public enum  ButtonGroup: Int {
    case language = 0, gender
    
    var description: String {
        switch self {
        case .language: return "a"
        case .gender: return "b"
        }
    }
}

public protocol RadioButtonDelegate {
    func onSelect(_ radio: RadioButton, iselected: Bool)
}

open class RadioButton: UIButton {

    let circleShape: CircleWithTick = {
        let ca = CircleWithTick()
        ca.backgroundColor = UIColor.clear
        ca.translatesAutoresizingMaskIntoConstraints = false
        return ca
    }()
    
    var name:String!
    
    fileprivate struct Const{
        static let duration = 1.0
    }
    
    open var delegate: AnyObject?
    open var title: String? {
        didSet {
            setTitle(Localization(key: title!), for: .normal)
            setTitle(Localization(key: title!), for: .selected)
            setNeedsLayout()
        }
    }
    
    
    open var group: ButtonGroup!
    public convenience init(title: String?){
        self.init()
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        addSubview(circleShape)
        circleShape.isHidden = !isSelected
        setTitleColor(Color.normalColor, for: .normal)
        setTitleColor(Color.selectedColor, for: .selected)
        addTarget(self, action: #selector(toggle), for: .touchUpInside)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.textAlignment = .center
        titleLabel?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel?.sizeToFit()
        
        circleShape.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        circleShape.widthAnchor.constraint(equalToConstant: 35).isActive = true
        circleShape.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        guard let right = titleLabel?.rightAnchor else { return }
        circleShape.leftAnchor.constraint(equalTo: right, constant: 10).isActive = true
        
        
    }
    
     @objc func toggle(){
        isSelected = !isSelected
        circleShape.isHidden = !isSelected
        
        if(isSelected) {
            circleShape.zoomBounceAnimation()
        }
        
        guard case let delegate as RadioButtonDelegate = self.delegate else{
            return
        }
        
        //let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * Const.duration))
        //dispatch_after(delay, dispatch_get_main_queue()){
        delegate.onSelect(self, iselected: isSelected)
        //}
        
        
    }

}

