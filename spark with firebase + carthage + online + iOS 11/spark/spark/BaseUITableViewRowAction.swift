//
//  BaseUITableViewRowAction.swift
//  spark
//
//  Created by Vikesh on 09/11/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class BaseUITableViewRowAction: UITableViewRowAction {
    
    var user: User { return SparkDataService.user }
    var image: UIImage?
    
    func _setButton(_ button: UIButton) {
        if let image = image {
            button.tintColor = UIColor.white
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            button.imageView?.contentMode = .scaleAspectFit
        }
    }}
