//
//  BackgroundMusicSectionCell.swift
//  spark
//
//  Created by Vikesh on 14/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class BackgroundMusicSectionCell: BaseCollectionViewCell {
    
    var dataprovider: BackgroundMusic! {
        didSet {
            titleLabel.text = Localization(key: dataprovider.name)
            icon.image = UIImage(named: dataprovider.image)
            let r:CGFloat = dataprovider.color.object(at: 0) as! CGFloat
            let g:CGFloat = dataprovider.color.object(at: 1) as! CGFloat
            let b:CGFloat = dataprovider.color.object(at: 2) as! CGFloat
            let color = UIColor(red: r, green: g, blue: b)
            //gradientLayer.colors = [UIColor.white.withAlphaComponent(0.3).cgColor, color.withAlphaComponent(0.8).cgColor]
            bgView.backgroundColor = color
        }
    }
    
    let bgView:BaseUIView! = {
        let v = BaseUIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let titleLabel: UILabel! = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = Color.normalColor
        lb.font = UIFont.systemFont(ofSize: FontSize.shared.textSize, weight: UIFont.Weight.regular)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.adjustsFontSizeToFitWidth = true
        lb.sizeToFit()
        return lb
    }()
    
    var icon: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let gradientLayer: CAGradientLayer! = {
        let g = CAGradientLayer()
        return g
    }()
    
    var svgRadioButton: SVGRadioButton! = {
        let svg = SVGRadioButton()
        svg.isSelected = false
        svg.translatesAutoresizingMaskIntoConstraints = false
        return svg
    }()
    
    var volumeSlider: UISlider! = {
        let s = UISlider()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.tintColor = Color.selectedColor
        s.maximumTrackTintColor = UIColor.white
        s.isHidden = true
        return s
    }()
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    override var isSelected: Bool {
        didSet {
            isSelected == true ? select() : deselect()
        }
    }


    override func initComponents() {
        gradientLayer.frame = bounds
        
        volumeSlider.addTarget(self, action: #selector(onValueChanged(_ :)), for: .valueChanged)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped))
        volumeSlider.addGestureRecognizer(tapGestureRecognizer)
        volumeSlider.value = SparkDataService.user.backgroundMusicVolume
    }
    
     @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer){
        let pointTapped: CGPoint = gestureRecognizer.location(in: self)
        let positionOfSlider: CGPoint = volumeSlider.frame.origin
        let widthOfSlider: CGFloat = volumeSlider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(volumeSlider.maximumValue) / widthOfSlider)
        volumeSlider.setValue(Float(newValue), animated: true)
        onValueChanged(volumeSlider)
    }
    
    override func setupViews() {
        //layer.addSublayer(gradientLayer)
        addSubview(bgView)
        addSubview(titleLabel)
        addSubview(icon)
        addSubview(svgRadioButton)
        addSubview(volumeSlider)
        //titleLabel.sizeToFit()
    }
    
    override func setupLayouts() {
        
        _ = titleLabel.anchor(topAnchor, left: icon.rightAnchor, bottom: nil, right: svgRadioButton.leftAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        _ = icon.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0)
        icon.widthAnchor.constraint(equalToConstant: 80).isActive  = true
        icon.heightAnchor.constraint(equalToConstant: 80).isActive  = true
        
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        bgView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        bgView.heightAnchor.constraint(equalTo: icon.heightAnchor, constant: -35).isActive = true
        bgView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        svgRadioButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        svgRadioButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        svgRadioButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        svgRadioButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        volumeSlider.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        volumeSlider.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 10).isActive = true
        volumeSlider.rightAnchor.constraint(equalTo: svgRadioButton.leftAnchor, constant: -10).isActive = true
        volumeSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    override func configureViewFromLocalisation() {
        titleLabel.text = Localization(key: dataprovider.name)
    }
    
     @objc func onValueChanged(_ sender: UISlider){
        if(SparkAudioService.shared.configurationPlayer != nil) {
            SparkAudioService.shared.configurationPlayer.play()
            self.user.backgroundMusicVolume = sender.value
            
        } else {
            DispatchQueue.global(qos: .background).async {
                SparkAudioService.shared.playConfigurationSound(self.dataprovider.soundPath)
            }
        }
        
    }
    
    override func select() {
      
        titleLabel.textColor = Color.selectedColor
        //isUserInteractionEnabled = false
        svgRadioButton.isSelected = true
        titleLabel.isHidden = true
        volumeSlider.isHidden = false
        volumeSlider.value = SparkDataService.user.backgroundMusicVolume
        
        guard dataprovider != nil else { return }
        user.backgroundMusic = dataprovider.name
        
        
        DispatchQueue.global(qos: .background).async {
            SparkAudioService.shared.playConfigurationSound(self.dataprovider.soundPath)
        }
    }
    
    override func deselect() {
        titleLabel.textColor = Color.normalColor
        svgRadioButton.isSelected = false
        SparkAudioService.shared.pauseConfigurationSound()
        //isUserInteractionEnabled = true
        titleLabel.isHidden = false
        volumeSlider.isHidden = true
    }

}
