//
//  PlayListsCollectionViewCell.swift
//  spark
//
//  Created by Vikesh JOYPAUL on 21/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class PlayListsCollectionViewCell: BaseCollectionViewCell {

    var dataprovider: [AnyObject]!
    
    var playlist: PlayListsViewController! = {
        let pl = PlayListsViewController()
        return pl
    }()
    
    
    override func setupViews() {
        addSubview(playlist.view)
    }
    
    override func setupLayouts() {
        _ = playlist.view.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 90)
    }
    
    deinit {
        playlist = nil
    }
    
}
