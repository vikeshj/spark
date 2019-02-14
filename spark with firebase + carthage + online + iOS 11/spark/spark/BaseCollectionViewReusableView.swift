//
//  BaseCollectionViewReusableView.swift
//  spark
//
//  Created by Vikesh on 25/11/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//
import UIKit

class BaseCollectionViewReusableView: UICollectionReusableView {
    
    var searchBox: UISearchBar! = {
        let search = UISearchBar()
        search.placeholder = Localization(key: Spark.SEARCH_PLACEHOLDER)
        search.enablesReturnKeyAutomatically = true
        search.searchBarStyle = UISearchBarStyle.default
        search.keyboardType = UIKeyboardType.alphabet
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveLanguageChangedNotification), name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)
        
        initComponents()
        setupViews()
        setupLayouts()
        addTargetEvent()
        
        clipsToBounds = true
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initComponents(){
        let searchbarAppearence = UISearchBar.appearance()
        searchbarAppearence.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        searchbarAppearence.backgroundImage = UIImage()
    }
    func setupViews(){}
    func setupLayouts(){}
    func addTargetEvent(){}
    
     @objc func receiveLanguageChangedNotification(notification: NSNotification) {
        if notification.name == NSNotification.Name(rawValue: kNotificationLanguageChanged) {
            configureViewFromLocalisation()
        }
    }
    
    func configureViewFromLocalisation() {}
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)
    }

    
}
