//
//  ConfigutationCollectionViewCell.swift
//  spark
//
//  Created by Vikesh JOYPAUL on 21/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class ConfigutationCollectionViewCell: BaseCollectionViewCell {

    override var navigate: ((NavigationPageType) -> (Void))? {
        didSet {
            configurationViewController.navigate = navigate
        }
    }
    
    var configurationViewController: ConfigurationViewController = {
        let configuration = ConfigurationViewController()
        return configuration
    }()
    
    
    override func setupViews() {
        addSubview(configurationViewController.view)
    }
    
    override func setupLayouts() {
        _ = configurationViewController.view.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }

}
