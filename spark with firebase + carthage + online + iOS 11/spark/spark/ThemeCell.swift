//
//  ThemeCell.swift
//  spark
//
//  Created by Vikesh on 23/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit
//import Firebase
class ThemeCell: BaseCollectionViewCell {
    
    var dataprovider:FireTheme? {
        didSet {
            configureViewFromLocalisation()
        }
    }
    
    override func setupViews() {
        addSubview(imageView)
        backgroundColor = UIColor.orange
        imageView.image = #imageLiteral(resourceName: "placeholder")
        imageView.contentMode = .scaleAspectFill
    }
    
    override func configureViewFromLocalisation() {
        if let  locale = user.locale,  let themetype = dataprovider?.themeType {
            let x1 = locale == SparkLocale.english.rawValue ?  dataprovider?.picture.en.iphone.x1 :  dataprovider?.picture.fr.iphone.x1
            
            let url = "themes/" + themetype
            DispatchQueue.main.async {
                self.imageView.loadFirebaseImageUsingCacheWith(x1!, subDirectory: url, completion: { (image) in
                    if let _ = image {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.imageView.alpha = 1
                        })
                    }
                })
            }
        }
    }
    
    override func setupLayouts() {
        _ = imageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
}
