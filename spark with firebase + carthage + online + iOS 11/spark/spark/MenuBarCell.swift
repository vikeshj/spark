//
//  MenuBarCell.swift
//  spark
//
//  Created by Vikesh on 16/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

protocol SparkTabBarDelegate {
    func didSelectViewController(_ tabBarView: BaseViewController, atIndex index: Int)
}

class MenuBarCell: BaseCollectionViewCell {
    
    var icon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = Color.gray
        return iv
    }()
    
    var play: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "playSingle").withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = Color.gray
        return iv
    }()

    
    var image: String! {
        didSet {
            icon.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
            
        }
    }
    
    
    override var isHighlighted: Bool {
        didSet {
            icon.tintColor = isHighlighted ? Color.selectedColor : Color.gray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if(navigationPageType != nil && navigationPageType == NavigationPageType.configuration){ return }
            icon.tintColor = isSelected ? Color.selectedColor : Color.gray
            isUserInteractionEnabled = !isSelected
          }
    }
    
    override func setupViews() {
        addSubview(icon)
    }
    
    override func setupLayouts() {
        //icon.anchorWithAxis(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
