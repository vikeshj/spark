//
//  SparkNavigationViewController.swift
//  spark
//
//  Created by Vikesh on 11/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit
//import Firebase

class SparkNavigationViewController: UINavigationController {
    
    var user: User { return SparkDataService.user }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        if SparkDataService.shared.isKeyExists(UserSharedKey.user) {
            let o = SparkDataService.shared.getKeyValue(UserSharedKey.user) as! [String: Any]
            user.setValuesForKeys(o)
            
        } else {
            if let language = Locale.current.languageCode {
                user.locale = language
            }
        }
        
        print("User Objects : \(Localisator.shared.current) - \(user.object)")
        /*let timestamp = NSDate().timeIntervalSince1970
        let converted = NSDate(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "hh:mm:ss a dd-MM-yyyy"
        let time = dateFormatter.string(from: converted as Date)
        print(time)*/
        
        
        /*let context = SparkDataService.shared.context
        
        let ua: SparkAlarm = SparkAlarm(context: context)
        ua.name = "Jack from the sparrow island"
        ua.playlistId = "01"
        ua.date = NSDate()
        ua.snooze = false
        ua.voice = SparkDataService.user.peopleId
        try! context.save()*/
        
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor.white
        navigationBarAppearace.clipsToBounds = true
        navigationBarAppearace.isTranslucent = true
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearace.shadowImage = UIImage()
        
        //UISearchBox
        let searchbarAppearence = UISearchBar.appearance()
        searchbarAppearence.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        searchbarAppearence.backgroundImage = UIImage()
        
        //SparkSchedulerService.shared.settings()
        
        setupViews()
        setupLayouts()
        
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        
        if let mediaPlayer = SparkAudioService.shared.mediaPlayer, let event = event {
            mediaPlayer.remoteControlReceived(with: event)
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        fetch { (bool) in
            
           // _ = SparkDataService.shared.signOut
            // if user not login in firebase account
            if (Auth.auth().currentUser?.uid == nil) {
                let loginViewController = LoginViewController()
                self.present(loginViewController, animated: false, completion: nil)
                loginViewController.completion = self.configure
                
            } else if self.user.isFirstLaunched == true {
                self.configure()
            }
           
        }
    }
  
    
    func fetch(_ completion:@escaping (_ bool:Bool)->()){
        DispatchQueue.main.async {
            SparkDataService.shared.sparkDictionary = SparkDataService.resource(Config.SPARK_PLIST)
            completion(true)
        }
    }
    
    func initComponents(){
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionFromRight
        transition.subtype = kCATransitionFromLeft
    }
    func setupViews(){}
    func setupLayouts(){}
    func configure(_ animate:Bool = false){
        self.present(ConfigurationViewController(), animated: animate, completion: {
           
        })
    }
    
    func checkIsUserLoggedIn(){}
    func logout(){}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // set status indicatior to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
