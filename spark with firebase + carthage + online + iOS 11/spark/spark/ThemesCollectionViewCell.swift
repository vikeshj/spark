//
//  ThemesCollectionViewCell.swift
//  spark
//
//  Created by Vikesh JOYPAUL on 21/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class ThemesCollectionViewCell: BaseCollectionViewCell {
    
    override var navigate: ((NavigationPageType) -> (Void))? {
        didSet {
            themesViewController.navigate = navigate
        }
    }

    var themesViewController: ThemesViewController  = ThemesViewController.sharedInstance
    
    override func initComponents() {
    }
    
    override func setupViews() {
        addSubview(themesViewController.view)
    }
    
    override func setupLayouts() {
        _ = themesViewController.view.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}
