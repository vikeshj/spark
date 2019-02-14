//
//  GalleryViewController.swift
//  spark
//
//  Created by Vikesh on 26/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class GalleryViewController: BaseViewController {
    
    var titleLabel: UILabel! = {
        let lb = UILabel()
        lb.adjustsFontSizeToFitWidth = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = Localization(key: Spark.COMING_SOON)
        lb.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.light)
        lb.textAlignment = .center
        lb.textColor = UIColor.white
        return lb
    }()

    

    override func setupViews() {
        view.addSubview(titleLabel)
    }
    
    override func setupLayouts() {
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 80).isActive = true
        titleLabel.sizeToFit()
    }
    
    override func configureViewForLocalisation() {
        titleLabel.text = Localization(key: Spark.COMING_SOON)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
