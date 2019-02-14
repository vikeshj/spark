//
//  HomeCollectionViewCell.swift
//  spark
//
//  Created by Vikesh JOYPAUL on 21/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: BaseCollectionViewCell {
    
    
    override var navigate: ((NavigationPageType) -> (Void))? {
        didSet {
            homeController.navigate = navigate
        }
    }
    
    var homeController: HomeViewController = {
        let home = HomeViewController()
        return home
    }()
    
    
    override func setupViews() {
        addSubview(homeController.view)
    }
    
    override func setupLayouts() {
        _ = homeController.view.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        _ = anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
}
