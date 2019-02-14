//
//  BaseCollectionViewCell.swift
//  spark
//
//  Created by Vikesh on 12/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    var user: User { return SparkDataService.user }
    var navigate:((_ index: NavigationPageType) -> (Void))?
    var navigationPageType:NavigationPageType!
    var snackbar: TTGSnackbar!
    
    var imageView: SparkUIImageView! = {
        let iv = SparkUIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveLanguageChangedNotification), name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)
        fetchPlaylist()
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
    func fetchPlaylist() {}
    func initComponents(){}
    func setupViews(){}
    func setupLayouts(){}
    func addTargetEvent(){}
    
     @objc func receiveLanguageChangedNotification(notification: NSNotification) {
        if notification.name == NSNotification.Name(rawValue: kNotificationLanguageChanged) {
            configureViewFromLocalisation()
        }
    }
    
    
    func configureViewFromLocalisation() {}
    
    /// select a collection row cell
    func select() {}
    func deselect() {}
    
    func createSnackBarWithIcon(_ message: String, icon: UIImage, time: TTGSnackbarDuration, bottomMargin: CGFloat = 5, color: UIColor =  UIColor.red ){
        
        guard snackbar == nil else { return }
        snackbar = TTGSnackbar(message: message, duration: time)
        snackbar.icon = icon
        snackbar.bottomMargin = bottomMargin
        snackbar.animationType = .slideFromBottomBackToBottom
        snackbar.iconContentMode = .scaleAspectFit
        snackbar.backgroundColor = color.withAlphaComponent(0.7)
        snackbar.show()
        snackbar.dismissBlock = { snack in  self.snackbar = nil }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)
    }
}
