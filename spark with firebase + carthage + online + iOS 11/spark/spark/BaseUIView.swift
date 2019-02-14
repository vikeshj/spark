//
//  BaseUIView.swift
//  spark
//
//  Created by Vikesh on 06/09/2016.
//  Copyright © 2016 Vikesh JOYPAUL. All rights reserved.
//  subclassing http://stackoverflow.com/a/33721647
//  http://stackoverflow.com/a/26150828

import UIKit

class BaseUIView: UIView {
    
    var user: User { return SparkDataService.user }
    var navigate:((_ index: NavigationPageType) -> (Void))?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func didLoad(){
        
        initComponents()
        setupViews()
        setupLayouts()
    }
    
    func initComponents() {
        
         NotificationCenter.default.addObserver(self, selector:#selector(languageChangedNotification), name: Notification.Name(rawValue: kNotificationLanguageChanged), object: nil)
        
        backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    
    func setupViews() {}
    
    func setupLayouts() { }
    
    // MARK: - Localization
    @objc func languageChangedNotification(notification: Notification){
        if(notification.name == Notification.Name(rawValue: kNotificationLanguageChanged)) {
            configureViewForLocalisation()
        }
    }
    
    func configureViewForLocalisation(){ }

    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)
    }
}
