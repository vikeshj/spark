//
//  BaseTableViewCell.swift
//  spark
//
//  Created by Vikesh on 24/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    var user: User { return SparkDataService.user }
    var snackbar: TTGSnackbar!
    let bgView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //clipsToBounds = true
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        selectionStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveLanguageChangedNotification), name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)
        backgroundView = bgView
        
        fetchPlaylist()
        initComponents()
        setupViews()
        setupLayouts()
        addTargetEvent()
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func fetchPlaylist() {}
    func initComponents(){  }
    func setupViews(){}
    func setupLayouts(){}
    func addTargetEvent(){}
    func configureViewFromLocalisation() {}
    func createSnackBarWithIcon(_ message: String, icon: UIImage, time: TTGSnackbarDuration, bottomMargin: CGFloat = 5, color: UIColor = .red, alpha: CGFloat = 0.85 ){
        
        guard snackbar == nil else { return }
        snackbar = TTGSnackbar(message: message, duration: time)
        snackbar.icon = icon
        snackbar.tintColor = .white
        snackbar.bottomMargin = bottomMargin
        snackbar.animationType = .slideFromBottomBackToBottom
        snackbar.iconContentMode = .scaleAspectFit
        snackbar.backgroundColor = color.withAlphaComponent(alpha)
        snackbar.show()
        snackbar.dismissBlock = { snack in  self.snackbar = nil }
    }
    
     @objc func receiveLanguageChangedNotification(notification: NSNotification) {
        if notification.name == NSNotification.Name(rawValue: kNotificationLanguageChanged) {
            configureViewFromLocalisation()
        }
    }
    
    func selectedCell(_ animated: Bool = false ) {}
    func unSelectedCell(_ animated: Bool = false) {}
    func cellWithSelected(){}
    func cellWithUnSelected(){}
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)
    }

}

