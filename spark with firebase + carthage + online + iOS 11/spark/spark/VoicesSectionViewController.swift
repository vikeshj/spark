//
//  VoicesSectionViewController.swift
//  spark
//
//  Created by Vikesh on 11/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class VoicesSectionViewController: ContentPage {
    
    var voicesView: VoiceSelectionView! = {
        let vs = VoiceSelectionView(frame: .zero)
        vs.translatesAutoresizingMaskIntoConstraints = false
        return vs
    }()
    
    var subtitleLabel: UILabel! = {
        let lb = UILabel()
        lb.adjustsFontSizeToFitWidth = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = Localization(key: Spark.VOICE_SELECTION_TITLE)
        lb.font = UIFont.systemFont(ofSize: FontSize.shared.subTitleSize, weight: UIFont.Weight.thin)
        lb.textAlignment = .center
        lb.textColor = UIColor.white
        return lb
    }()
    
    var subtitleGradientLine: UIImageView!
    


    override func initComponents() {
        subtitleGradientLine = createImage(name: "lineShadow", scale: .scaleAspectFit)
        
        configureViewForLocalisation()
    }
    
    override func setupViews() {
        view.addSubview(subtitleLabel)
        view.addSubview(subtitleGradientLine)
        view.addSubview(voicesView)
    }
    
    override func setupLayouts() {
        subtitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        subtitleGradientLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subtitleGradientLine.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 5).isActive = true
        subtitleGradientLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        subtitleGradientLine.heightAnchor.constraint(equalToConstant: gradientLineheight).isActive = true
        
        voicesView.topAnchor.constraint(equalTo: subtitleGradientLine.bottomAnchor, constant: 10).isActive = true
        voicesView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        voicesView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        voicesView.heightAnchor.constraint(equalToConstant: view.bounds.height).isActive = true
   }
    
    override func configureViewForLocalisation() {
        subtitleLabel.text = Localization(key: Spark.VOICE_SELECTION_TITLE)
    }

    deinit {
        subtitleLabel = nil
        subtitleGradientLine = nil
        voicesView = nil
    }
}
