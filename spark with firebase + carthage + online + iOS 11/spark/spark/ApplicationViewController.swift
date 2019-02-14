//
//  ApplicationViewController.swift
//  spark
//
//  Created by Vikesh on 24/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit
//import Firebase
import UserNotifications

class ApplicationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UNUserNotificationCenterDelegate {
    
    static var sharedInstance: ApplicationViewController = ApplicationViewController()
    var user: User { return SparkDataService.user }
    
    var navigation: ApplicationViewController! {
        get {
            return ApplicationViewController.sharedInstance
        }
    }

    var menuViewController: MenuBarViewController! = {
        let m = MenuBarViewController()
        return m
    }()
    
    
    var playerTopConstant: NSLayoutConstraint? = nil
    lazy var player: MiniPlayerContentViewControler! = {
        let p = MiniPlayerContentViewControler()
        p.closeButtonActionHandler = self.closePlayer
        return p
    }()
    
    var background: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "mainBackground")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    let homeCellId: String = "homeCellId"
    let themesCellId: String = "themesCellId"
    let playlistsCellId: String = "playlistsCellId"
    let galleryCellId: String = "galleryCellId"
    let configurationCellId: String = "configurationCellId"
    
    
    //var menuBottomAnchor: NSLayoutConstraint?
    var previousXOffset: CGFloat = 0
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //DataManager.sharedInstance.sparkDictionary = DataManager.resource(Config.SPARK_PLIST)
        view.backgroundColor = UIColor.clear
        
        initComponents()
        setupViews()
        setupLayouts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    }
    
    
    /// init component instance
    func initComponents(){
        
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: homeCellId)
        collectionView.register(ThemesCollectionViewCell.self, forCellWithReuseIdentifier: themesCellId)
        collectionView.register(PlayListsCollectionViewCell.self, forCellWithReuseIdentifier: playlistsCellId)
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: galleryCellId)
        collectionView.register(ConfigutationCollectionViewCell.self, forCellWithReuseIdentifier: configurationCellId)
        
        /*if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            //flowLayout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height)
            
        }*/
        
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        menuViewController.menu.navigate = navigate
        menuViewController.menu.indexPath = IndexPath(item: 0, section: 0)
        
        observeKeyboardNotifications()
        
        //UserNotification Delegate
        UNUserNotificationCenter.current().delegate = self
    }
    
    /// Add view to parent view
    func setupViews() {
        view.addSubview(background)
        view.addSubview(collectionView)
        view.addSubview(menuViewController.view)
        view.addSubview(player.view)
    }
    
    /// Layout setups
    func setupLayouts() {
        
        //background
        _ = background.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        // menu
        _ = menuViewController.view.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 80)
        
        playerTopConstant = player.view.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 1000, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)[0]

    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
     @objc func keyboardShow () {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
     @objc func keyboardHide() {
        
    }
    
    func onLogout(){
        navigationController?.present(LoginViewController(), animated: true, completion: {
                _ = SparkDataService.shared.signOut
            })
    }
    
    func navigate(index: NavigationPageType) {
        let page = index.rawValue;
        let indexPath = IndexPath(item: page, section: 0)
        if(index != .configuration) {
            collectionView.alpha = 0
            
            UIView.animate(withDuration: 0.7, animations: {
                 self.collectionView.alpha = 1
                }, completion: nil)
            
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            collectionView.isScrollEnabled = (page == 0 || page == 2) ? false : true
        }
        
        if(index == .configuration || index == .home) {
            
            if(index == .configuration){
                self.presentViewControllerInModalMode(ConfigurationViewController())
            }
            
        }
        
        if(index == .home) {
            menuViewController.hideMiniPlayer()
        }else {
            menuViewController.miniPlayer.isHidden = false
        }
        
        menuViewController.menu.indexPath = indexPath
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = floor(scrollView.contentOffset.x / view.frame.width)
        
        
        if(page == 0) {
            menuViewController.menuBottomConstant.constant = 50
            menuViewController.hideMiniPlayer()
        }
        else {
            menuViewController.menuBottomConstant.constant = 0
            menuViewController.miniPlayer.isHidden = false
        }
        

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.menuViewController.view.layoutIfNeeded()
            }, completion: nil)
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page: Int = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: page, section: 0)
        menuViewController.menu.indexPath = indexPath
        collectionView.isScrollEnabled = (indexPath.item == 0 || indexPath.item == 2 ) ? false : true
        
        //if(page == 0) { menuViewController.menuBottomConstant.constant = 60 }
        //else { menuViewController.menuBottomConstant.constant = 0 }
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.menuViewController.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId(index: indexPath.item), for: indexPath) as! BaseCollectionViewCell
        cell.navigationPageType = NavigationPageType(rawValue: indexPath.item)
        cell.navigate = navigate
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.bounds.height)
    }
    
    func cellId(index: Int) -> String {
        
        switch index {
            case 1: return themesCellId
            case 2: return playlistsCellId
            case 3: return galleryCellId
            case 4: return configurationCellId
            default:return homeCellId
        }
    }
    
    func pushViewController(page viewControllerToPresent: BaseViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(viewControllerToPresent, animated: animated)
    }
    
    func presentViewControllerInModalMode(_ viewControllerToPresent: BaseViewController, animated: Bool = true, completion: (() -> Void)? = nil){
        self.navigationController?.present(viewControllerToPresent, animated: animated, completion: {
            guard (completion != nil) else { return  }
            completion!()
        })
    }
    
    
    // MARK: - MiniPlayer show / hide
    func showAudioPlayer(_ playlist:FirePlaylist, category: Category){
        
        if let activeId = user.activePlaylistId {
            let id = playlist.id
            if activeId != id {
                player.category = category
                player.dataprovider = playlist
            }
        }
        user.activePlaylistId = playlist.id
        playerTopConstant?.constant = 0
        
        UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (bool) in })
    }
    
    func openAudioPlayer(){
        if let mediaPlayer = SparkAudioService.shared.mediaPlayer {
            if(mediaPlayer.state == .paused || mediaPlayer.state == .playing || mediaPlayer.state == .stopped) {
                self.playerTopConstant?.constant = 0
                UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (bool) in })
            }
        }
    }
    
    func closePlayer(){
        playerTopConstant?.constant = player.view.frame.height
        UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (bool) in })
    }
    
    /// Usernotifcation
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // to show notification with the app
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "remindLater" {
            
        }
        
    }
    
    
    // set status indicatior to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    deinit {
        //needs to remove keyboard obersver here
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}


