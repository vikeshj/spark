//
//  ConfigurationViewController.swift
//  spark
//  link: http://sweettutos.com/2015/04/13/how-to-make-a-horizontal-paging-uiscrollview-with-auto-layout-in-storyboards-swift/
//  Created by Vikesh on 11/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

var kSwipeRemoverNotification: String = "kSwipeRemover"

class ContentPage: BaseViewController {
    var pageIndex: Int!
    var gradientLineheight: CGFloat = 21.0
    
    override func initComponents() {
        view.backgroundColor = UIColor.clear
    }
}

class ConfigurationViewController: BaseViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //static var shared: ConfigurationViewController = ConfigurationViewController()
    
    var pageViewController: UIPageViewController!
    var pages: Array<ContentPage>!
    var pageControlApparence: UIPageControl!
    var currentPage: Int = 0
    
    var configurationLabel: UILabel! = {
        let l = UILabel()
        l.adjustsFontSizeToFitWidth = true
        l.text = Localization(key: Spark.CONFIGURATION_TITLE)
        l.font = UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.thin)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = Color.normalColor
        return l
    }()
    
    var languageVC: LanguageSectionViewController!
    var voicesVC: VoicesSectionViewController!
    var backgroundVC: BackgroundSectionViewcontroller!
    
    let nextButton: UIButton! = {
        let b = UIButton()
        b.tag = 1
        b.setTitleColor(.white, for: .normal)
        b.setTitle(Localization(key: Spark.NEXT_BUTTON_TITLE), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    
    var pageControl:UIPageControl! = {
        let pc = UIPageControl()
        return pc
    }()
    
    let closeBtn: UIButton! = {
        let b = UIButton()
        b.tag = 1
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "closeButton")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.setImage(UIImage(named: "closeButton")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        b.tintColor = Color.normalColor
        return b
    }()
    
    
    override func initComponents() {
        super.initComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(swipeEnabler), name: NSNotification.Name(rawValue: kSwipeRemoverNotification), object: nil)
        
        pages = [ContentPage]()
        languageVC = LanguageSectionViewController()
        languageVC.pageIndex = 0
        languageVC.onLogout = logout
        
        voicesVC = VoicesSectionViewController()
        voicesVC.pageIndex = 1
        
        backgroundVC = BackgroundSectionViewcontroller()
        backgroundVC.pageIndex = 2
        
        pages.append(languageVC)
        pages.append(voicesVC)
        pages.append(backgroundVC)
        
        
        pageControlApparence = UIPageControl.appearance()
        pageControlApparence.pageIndicatorTintColor = Color.normalColor
        pageControlApparence.currentPageIndicatorTintColor = Color.selectedColor
        pageControlApparence.backgroundColor = UIColor.clear
        
        
        
        //pageViewController
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.view.backgroundColor = UIColor.clear
        pageViewController.setViewControllers([viewControllerAt(0)], direction: .forward, animated: true, completion: nil)
        
        nextButton.addTarget(self, action: #selector(nextPage) , for: .touchUpInside)
        closeBtn.addTarget(self, action: #selector(close) , for: .touchUpInside)
        
        closeBtn.isHidden = user.isFirstLaunched
    }
    
    @objc func swipeEnabler(notification: NSNotification){
        let userInfo = notification.userInfo as! [String: Any]
        let enable = userInfo["enabled"] as? Bool
        for view in self.pageViewController!.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = enable!
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        view.addSubview(background)
        view.addSubview(configurationLabel)
        view.addSubview(pageViewController.view)
        view.addSubview(closeBtn)
        view.addSubview(nextButton)
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        _ = background.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        
        configurationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        configurationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        configurationLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        configurationLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        languageVC.configurationLabelBottomConstant = configurationLabel.bottomAnchor
        
        _ = pageViewController.view.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        closeBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        closeBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
       
        
        _ = nextButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 120, heightConstant: 0)
        
        
        
        /*pageControl.anchorWithAxisAndConstant(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        pageControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true*/
    }
    
    override func configureViewForLocalisation() {
        configurationLabel.text = Localization(key: Spark.CONFIGURATION_TITLE)
        if(currentPage == 0 || currentPage == 1) { nextButton.setTitle(Localization(key: Spark.NEXT_BUTTON_TITLE), for: .normal) }
        else if (currentPage == 2) { nextButton.setTitle(Localization(key: Spark.SAVE_BUTTON_TITLE), for: .normal)  }
    }
    
    func logout() {
        self.dismiss(animated: false) {
        
        SparkDataService.shared.removeUserKey(UserSharedKey.user)
         ApplicationViewController.sharedInstance.onLogout()
        }
    }
    
     @objc func close() {
        if (user.peopleId == nil) {
            nextButton.setTitle(Localization(key: Spark.NEXT_BUTTON_TITLE), for: .normal)
            createSnackBarWithIcon(Localization(key: Spark.SELECT_VOICE), icon: #imageLiteral(resourceName: "warning"), time: .middle)
            pageViewController.setViewControllers([viewControllerAt(1)], direction: .forward, animated: true, completion: nil)
            return
        }
        self.dismiss(animated: true, completion: {
            SparkDataService.shared.addUserKey(self.user.object, forKey: UserSharedKey.user)
            if let player = SparkAudioService.shared.configurationPlayer {
                player.fadeOut()
            }

        })
    }
    
     @objc func nextPage(){
       
        if(self.currentPage == 0) {
            self.currentPage = 1
            pageViewController.setViewControllers([viewControllerAt(1)], direction: .forward, animated: true, completion: nil)
        }
        else if (self.currentPage == 1) {
            pageViewController.setViewControllers([viewControllerAt(2)], direction: .forward, animated: true, completion: nil)
            nextButton.setTitle(Localization(key: Spark.SAVE_BUTTON_TITLE), for: .normal)
            self.currentPage = 2
        }
        else if(self.currentPage == 2){
            // do some validation here
            if (user.gender == nil){
                nextButton.setTitle(Localization(key: Spark.NEXT_BUTTON_TITLE), for: .normal)
                createSnackBarWithIcon(Localization(key: Spark.SELECT_GENDER), icon: #imageLiteral(resourceName: "warning"), time: .middle)
                pageViewController.setViewControllers([viewControllerAt(0)], direction: .reverse, animated: true, completion: nil)
                return
            }
            if (user.peopleId == nil) {
                nextButton.setTitle(Localization(key: Spark.NEXT_BUTTON_TITLE), for: .normal)
                createSnackBarWithIcon(Localization(key: Spark.SELECT_VOICE), icon: #imageLiteral(resourceName: "warning"), time: .middle)
                pageViewController.setViewControllers([viewControllerAt(1)], direction: .reverse, animated: true, completion: nil)
                return
            }
            if (user.backgroundMusic == nil) {
                nextButton.setTitle(Localization(key: Spark.SAVE_BUTTON_TITLE), for: .normal)
                createSnackBarWithIcon(Localization(key: Spark.SELECT_BACKGROUND_AMBIENT), icon: #imageLiteral(resourceName: "warning"), time: .middle)
                pageViewController.setViewControllers([viewControllerAt(2)], direction: .forward, animated: true, completion: nil)
                return
            }
            
            if let player = SparkAudioService.shared.configurationPlayer {
                player.fadeOut()
            }
            
            user.isFirstLaunched = false
            print(user.object)
            self.dismiss(animated: true, completion: {
                SparkDataService.shared.addUserKey(self.user.object, forKey: UserSharedKey.user)
            })
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentPage
        var index = vc.pageIndex as Int
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        index -= 1
        return viewControllerAt(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentPage
        var index = vc.pageIndex as Int
        if(index == NSNotFound){
            return nil
        }
        index += 1
        
        if(index == pages.count) {
            return nil
        }
        return viewControllerAt(index)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        //guard completed else { return }
        if let vc = pageViewController.viewControllers?.first! as? ContentPage {
            self.currentPage = vc.pageIndex
            
            if(vc.pageIndex == 0 || vc.pageIndex == 1) {
                nextButton.setTitle(Localization(key: Spark.NEXT_BUTTON_TITLE), for: .normal)
            }
            else if (vc.pageIndex == 2) {
                nextButton.setTitle(Localization(key: Spark.SAVE_BUTTON_TITLE), for: .normal)
            }
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    
    func viewControllerAt(_ index: Int) -> ContentPage {
        if (pages.count == 0) || (index >= pages.count) {
            return ContentPage()
        }
        let vc = pages[index]
        vc.pageIndex = index
        return vc
    }
    
    
    deinit {
        configurationLabel = nil
        background = nil
        pageViewController = nil
        languageVC = nil
        voicesVC = nil
        pages = []
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kSwipeRemoverNotification), object: nil)
    }

}
