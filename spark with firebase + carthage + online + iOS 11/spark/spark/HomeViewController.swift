//
//  HomeViewController.swift
//  spark
//
//  Created by Vikesh on 11/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    var logo: UIImageView!
    
    var themesBtn: CircleImageButton!
    var playlistsBtn: CircleImageButton!
    var configurationBtn: CircleImageButton!
    var galleryBtn: CircleImageButton!
    
    override func initComponents() {
        
        view.backgroundColor = UIColor.clear
        logo = createImage(name: "logoWithGreenSun", scale: .scaleAspectFit)
        
        // buttons
        themesBtn = createButton("themesIcon", color: Color.orange, size: CGSize(width: 90, height: 90))
        galleryBtn = createButton("galleryIcon", color: Color.yellow, size: CGSize(width: 90, height: 90), tintColor: UIColor(red: 138, green: 113, blue: 7))
        playlistsBtn = createButton("playlistsIcon", color: Color.green, size: CGSize(width: 90, height: 90), tintColor: UIColor(red: 5, green: 157, blue: 123))
        configurationBtn = createButton("configurationIcon", color: Color.blue, size: CGSize(width: 90, height: 90), tintColor: UIColor(red: 9, green: 82, blue: 148))
        
        // set navigation type
        themesBtn.navigationPageType = .themes
        galleryBtn.navigationPageType = .gallery
        playlistsBtn.navigationPageType = .playlists
        configurationBtn.navigationPageType = .configuration
        
        configureViewForLocalisation()
        
    }
    
    
    override func setupViews() {
        view.addSubview(logo)
        view.addSubview(themesBtn)
        view.addSubview(playlistsBtn)
        view.addSubview(configurationBtn)
        view.addSubview(galleryBtn)
    }
    
    override func setupLayouts() {
        _ = logo.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        logo.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        //top
        themesBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: Layout.sharedInstance.topContantForBubble).isActive = true
        themesBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //left
        galleryBtn.topAnchor.constraint(equalTo: themesBtn.bottomAnchor, constant: 30).isActive = true
        galleryBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        //right
        
        playlistsBtn.topAnchor.constraint(equalTo: themesBtn.bottomAnchor, constant: 30).isActive = true
        playlistsBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        //bottom
        configurationBtn.topAnchor.constraint(equalTo: playlistsBtn.bottomAnchor, constant: 30).isActive = true
        configurationBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
    }
    
    func createButton(_ icon: String, color: UIColor, size: CGSize = CGSize(width: 100, height: 100), tintColor: UIColor = UIColor.white) -> CircleImageButton {
        let btn = CircleImageButton(imageName: icon, color: color, frame: .zero, tintColor: tintColor)
        btn.onClick = onClickEvent
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        btn.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        return btn
    }
    
    func onClickEvent(_ sender: CircleImageButton) {
        print("navigate \(sender.navigationPageType!.rawValue)")
        guard navigate != nil else { return }
        //let type: NavigationType = sender.navigationType as NavigationType
        self.navigate!(sender.navigationPageType)
    }
    
    override func configureViewForLocalisation() {
        themesBtn.title = Localization(key: Spark.THEMES)
        playlistsBtn.title = Localization(key: Spark.PLAYLISTS)
        galleryBtn.title = Localization(key: Spark.GALLERY)
        configurationBtn.title = Localization(key: Spark.CONFIGURATION)
    }
    
    deinit {
        logo = nil
        themesBtn = nil
        playlistsBtn = nil
        configurationBtn = nil
        galleryBtn = nil
    }
    
}
