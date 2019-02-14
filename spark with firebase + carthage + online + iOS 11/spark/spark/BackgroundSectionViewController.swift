//
//  BackgroundSectionViewController.swift
//  spark
//
//  Created by Vikesh JOYPAUL on 23/11/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import  UIKit

class BackgroundSectionViewcontroller: ContentPage {
    
    var backgroundMusicView: BackgroundMusicSelectionView! = {
        let bm = BackgroundMusicSelectionView()
        bm.translatesAutoresizingMaskIntoConstraints = false
        return bm
    }()
    
    var musicLabel: UILabel! = {
        let lb = UILabel()
        lb.adjustsFontSizeToFitWidth = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = Localization(key: Spark.BACKGROUND_MUSIC_TITLE)
        lb.font = UIFont.systemFont(ofSize: FontSize.shared.subTitleSize, weight: UIFont.Weight.thin)
        lb.textAlignment = .center
        lb.textColor = UIColor.white
        return lb
    }()
    
    var musicGradientLine: UIImageView!
    
    override func initComponents() {
        musicGradientLine = createImage(name: "lineShadow", scale: .scaleAspectFit)
        configureViewForLocalisation()
    }
    
    override func setupViews() {
        
        view.addSubview(musicLabel)
        view.addSubview(musicGradientLine)
        view.addSubview(backgroundMusicView)
    }
    
    override func setupLayouts() {
        
        musicLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        musicLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        musicGradientLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        musicGradientLine.topAnchor.constraint(equalTo: musicLabel.bottomAnchor, constant: 5).isActive = true
        musicGradientLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        musicGradientLine.heightAnchor.constraint(equalToConstant: gradientLineheight).isActive = true
        
        backgroundMusicView.topAnchor.constraint(equalTo: musicGradientLine.bottomAnchor, constant: 0).isActive = true
        backgroundMusicView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundMusicView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        backgroundMusicView.heightAnchor.constraint(equalToConstant: view.bounds.height).isActive = true
    }
    
    override func configureViewForLocalisation() {
        
        musicLabel.text = Localization(key: Spark.BACKGROUND_MUSIC_TITLE)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kSwipeRemoverNotification), object:nil, userInfo:["enabled": false])
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kSwipeRemoverNotification), object:nil , userInfo:["enabled": true])
    }
}
