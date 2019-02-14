//
//  MenuTabarViewController.swift
//  spark
//
//  Created by Vikesh on 23/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class MenuTabarViewController: UITabBarController {
    
    var navigate:((_ index: NavigationPageType) -> (Void))?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector:#selector(languageChangedNotification), name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)

        didLoad()
        initComponents()
        setupViews()
        setupLayouts()
        addKeyboardObservers()
    }
    
    func didLoad(){}

    
    // MARK: - Instance creation
    func initComponents() {
        
    }
    
    // MARK: - Add instance to parent view
    func setupViews() {
        //view.addSubview(background)
    }
    
    // MARK: - Position component using autoLayout
    func setupLayouts() {
        /*_ = background.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)*/
    }
    
    
    // MARK: - Localization
    @objc func languageChangedNotification(notification: Notification){
        if(notification.name == NSNotification.Name(rawValue: kNotificationLanguageChanged)) {
            configureViewForLocalisation()
        }
    }
    
    func configureViewForLocalisation(){}
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardShow(notification: NSNotification) {}
    @objc func keyboardHide(notification: NSNotification) {}

    // set status indicatior to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Deinitialze
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
