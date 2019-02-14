//
//  CircleWithImageButton.swift
//  spark
//
//  Created by Vikesh on 13/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit
import QuartzCore

class CircleImageButton: UIButton {
    
    var color: UIColor = UIColor.black
    var cornerSize: CGFloat = 50
    var borderSize: CGFloat = 3
    var borderAlpha: CGFloat = 0.5
    var image: UIImage!
    var imgView: UIImageView!
    var shapeLayer: CAShapeLayer!
    var alphaShapeLayer: CAShapeLayer!
    
    /// handle navigation type
    var navigationPageType: NavigationPageType!
    
    ///handle click event
    var onClick: ((_ sender: CircleImageButton) -> Void)?
    
    ///title
    var title: String = "" {
        didSet {
            label.text = title
        }
    }
    
    var label: UILabel! = {
        let lb = UILabel()
        lb.textColor = .white
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: FontStyles.PFREGALTEXTPRO_BLACK_ITALIC, size: FontSize.shared.textSize)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(imageName: String, color: UIColor, frame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100), tintColor: UIColor = UIColor.white) {
        self.init(frame: .zero)
        self.imgView = UIImageView(frame: .zero)
        self.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        self.imgView.tintColor = tintColor
        self.color = color
    }
    
    func setup(_ w: CGFloat){
        addSubview(self.imgView)
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        self.imgView.image = self.image
        self.imgView.contentMode = .scaleAspectFit
        self.imgView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        self.imgView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.imgView.widthAnchor.constraint(equalToConstant: w).isActive = true
        self.imgView.heightAnchor.constraint(equalToConstant: w).isActive = true
        
        guard onClick != nil else { return }
        addTarget(self, action: #selector(buttonClickEvent), for: .touchUpInside)
    }
    
    func setupLayouts(){
        label.topAnchor.constraint(equalTo: bottomAnchor, constant: 10).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.sizeToFit()
    }
    
     @objc func buttonClickEvent(_ sender: CircleImageButton) {
        onClick!(self)
    }
    
    override func draw(_ rect: CGRect) {
        shapeLayer = CAShapeLayer()
        let w = frame.width
        let h = frame.height
        
        //alpha layer
        alphaShapeLayer = CAShapeLayer()
        alphaShapeLayer.path = UIBezierPath(ovalIn: CGRect(x: -7.5, y: -7.5, width: w + 15, height: h + 15)).cgPath
        alphaShapeLayer.fillColor = UIColor.white.withAlphaComponent(0.3).cgColor
        layer.addSublayer(alphaShapeLayer)
        
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: w, height: h) , cornerRadius: cornerSize).cgPath
        shapeLayer.fillColor = color.cgColor
        shapeLayer.strokeColor = UIColor.white.withAlphaComponent(borderAlpha).cgColor
        shapeLayer.lineWidth = borderSize
        layer.addSublayer(shapeLayer)
        
        
        
        setup((w / 2) + 10)
        setupLayouts()
    }
    
}
