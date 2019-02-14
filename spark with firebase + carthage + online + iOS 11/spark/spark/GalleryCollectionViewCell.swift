//
//  GallerycollectionViewCell.swift
//  spark
//
//  Created by Vikesh JOYPAUL on 21/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: BaseCollectionViewCell {

    var gallery: GalleryViewController! = {
        let g = GalleryViewController()
        return g
    }()
    
    
    override func setupViews() {
        addSubview(gallery.view)
    }
    
    override func setupLayouts() {
        _ = gallery.view.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    
    deinit {
        gallery = nil
    }

}
