//
//  BaseViewController.swift
//  spark
//
//  Created by Vikesh on 11/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var user: User { return SparkDataService.user }
    var background: UIImageView!
    var navigate:((_ index: NavigationPageType) -> (Void))?
    var snackbar: TTGSnackbar!
    
    var cellId: String = "cellId"
    lazy var collectionView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector:#selector(languageChangedNotification), name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)
        background = createImage(name: "mainBackground")
        //view.backgroundColor = UIColor.clear
        
        didLoad()
        initComponents()
        setupViews()
        setupLayouts()
        addKeyboardObservers()
    }
    
    func didLoad(){}
    
    func forceInit(){
        initComponents()
        setupViews()
        setupLayouts()
        addKeyboardObservers()
    }
    
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
        if(notification.name == Notification.Name(rawValue: kNotificationLanguageChanged)) {
            configureViewForLocalisation()
        }
    }
    
    func configureViewForLocalisation(){}
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardShow(notification: Notification) {}
    @objc func keyboardHide(notification: Notification) {}
    
    // MARK: - Create Image
    func createImage(name: String, scale: UIViewContentMode = .scaleAspectFill) -> UIImageView {
        let iv = UIImageView()
        iv.image = UIImage(named: name)
        iv.contentMode = scale
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }
    
    // MARK: - Create Button
    func createRadioButton(title: String, group: ButtonGroup, isSelected: Bool = false) -> RadioButton {
        let radio = RadioButton(title: nil)
        radio.group = group
        radio.title = title
        radio.isSelected = isSelected
        radio.translatesAutoresizingMaskIntoConstraints = false
        return radio
    }
    
    // MARK: - Alert View
    func createAlertViewController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func createSnackBarWithIcon(_ message: String, icon: UIImage, time: TTGSnackbarDuration, bottomMargin: CGFloat = 5, color: UIColor = .red ){
        
        guard snackbar == nil else { return }
        snackbar = TTGSnackbar(message: message, duration: time)
        snackbar.icon = icon
        snackbar.bottomMargin = bottomMargin
        snackbar.animationType = .slideFromBottomBackToBottom
        snackbar.iconContentMode = .scaleAspectFit
        snackbar.backgroundColor = color.withAlphaComponent(0.85)
        snackbar.show()
        snackbar.dismissBlock = { snack in  self.snackbar = nil }
    }
    
    // MARK: - Blur View effects
    var blurEffectView: UIVisualEffectView! = nil
    
    var blur: UIBlurEffect! = {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        return effect
    }()
    
    func animateIn(){}
    func animateOut(_ completion:@escaping (_ bool: Bool)->()){}

    
    
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
}
