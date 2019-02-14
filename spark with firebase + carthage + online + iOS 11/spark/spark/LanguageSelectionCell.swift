//
//  LanguageSelectionCell.swift
//  spark
//
//  Created by Vikesh on 12/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class LanguageSelectionCell: BaseCollectionViewCell {
    
    var dataprovider: Languages! {
        didSet {
            label.text = Localization(key: dataprovider.name)
        }
    }
    
    var label: UILabel! = {
        let l = UILabel()
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.thin)
        l.textAlignment = .center
        l.font = UIFont(name: FontStyles.PFREGALTEXTPRO_BLACK_ITALIC , size: FontSize.shared.titleSize)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = Color.normalColor
        return l
    }()
    
    var circle: CircleWithTick! = {
        let c = CircleWithTick()
        c.translatesAutoresizingMaskIntoConstraints = false
        return c
    }()
    
    override func initComponents() {
        circle.isHidden = true
    }
    
    override func setupViews() {
        addSubview(label)
        addSubview(circle)
    }
    
    override func setupLayouts() {
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        label.sizeToFit()
        
        circle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        circle.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 35).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    
    override func configureViewFromLocalisation() {
        label.text = Localization(key: dataprovider.name)
    }
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                select()
            }else {
                deselect()
            }
        }
    }
    
    
    override func select() {
        label.textColor = Color.selectedColor
        circle.isHidden = false
        circle.zoomBounceAnimation()
        isUserInteractionEnabled = false
        Localisator.shared.saveInUserDefaults = true
        guard dataprovider != nil else {
            return
        }
        user.locale = dataprovider.locale
        user.peopleId = nil
        user.peopleIndex = nil
        user.peopleName = nil
        
        /// Core Data register locale
        /*if let user = DataManager.sharedInstance.user {
            user.locale = dataprovider.locale
            user.localeId = Int16(dataprovider.id.int64Value)
            _ = DataManager.sharedInstance.save
        } else {
            let user: User = User(context: DataManager.sharedInstance.context)
            user.locale = dataprovider.locale
            user.localeId = Int16(dataprovider.id.int64Value)
            _ = DataManager.sharedInstance.save
        }*/
        
    }
    
    override func deselect() {
        label.textColor = Color.normalColor
        circle.isHidden = true
        isUserInteractionEnabled = true
    }
}
