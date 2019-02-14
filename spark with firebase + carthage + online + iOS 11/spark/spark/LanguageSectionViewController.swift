//
//  LanguageViewController.swift
//  spark
//
//  Created by Vikesh on 11/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class LanguageSectionViewController: ContentPage, RadioButtonDelegate {
    
    var gradientLine: UIImageView!
    var configurationLabelBottomConstant: NSLayoutYAxisAnchor! {
        didSet {
            
        }
    }
    
    var languageSelectionView: LanguageSelectionView! = {
        let v = LanguageSelectionView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    var genderTitle: UILabel = {
        let l = UILabel()
        l.text = Localization(key: Spark.GENDER_TITLE)
        l.font = UIFont.systemFont(ofSize: FontSize.shared.subTitleSize, weight: UIFont.Weight.thin)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.white
        return l
    }()
    
    var genderLine: UIImageView!
    var maleGenderRadioButton: RadioButton!
    var femaleGenderRadioButton: RadioButton!
    var currentSelectedGenderRadioButton: RadioButton!
    
    var onLogout: (() -> Void)?
    var clearCacheButton: UIButton! = {
        let btn = UIButton(type: UIButtonType.system)
        btn.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        btn.setTitle(Localization(key: Spark.CLEAR_CACHE), for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    var signOutButton: UIButton! = {
        let btn = UIButton(type: UIButtonType.system)
        btn.backgroundColor = UIColor(red: 200, green: 247, blue: 239).withAlphaComponent(0.8)
        btn.setTitle(Localization(key: Spark.LOGOUT_TITLE), for: .normal)
        btn.setTitleColor(UIColor(red: 20, green:157 , blue:131), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    override func initComponents() {
        
        //view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        
        gradientLine = createImage(name: "lineShadow", scale: .scaleAspectFit)
        genderLine = createImage(name: "lineShadow", scale: .scaleAspectFit)
        maleGenderRadioButton = createRadioButton(title: Spark.GENDER_MALE_TITLE, group: .gender, isSelected: false)
        femaleGenderRadioButton = createRadioButton(title: Spark.GENDER_FEMALE_TITLE, group: .gender, isSelected: false)
        
        maleGenderRadioButton.delegate = self
        femaleGenderRadioButton.delegate = self
        maleGenderRadioButton.name = "male"
        femaleGenderRadioButton.name = "female"
        
        maleGenderRadioButton.titleLabel?.font = UIFont(name: FontStyles.PFREGALTEXTPRO_BLACK_ITALIC, size: FontSize.shared.titleSize)
        femaleGenderRadioButton.titleLabel?.font = UIFont(name: FontStyles.PFREGALTEXTPRO_BLACK_ITALIC, size: FontSize.shared.titleSize)
        
        currentSelectedGenderRadioButton = RadioButton()
        
        clearCacheButton.addTarget(self, action: #selector(onClearCache), for: .touchUpInside)
        
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        signOutButton.isHidden = user.isFirstLaunched == true ? true : false
        
        
        if(user.gender != nil) {
            currentSelectedGenderRadioButton = user.gender == SparkGender(rawValue: "male")?.description ? maleGenderRadioButton : femaleGenderRadioButton
            currentSelectedGenderRadioButton.toggle()
        }
    }
    
    //sign out
     @objc func signOut(){
        if let out = onLogout {
            out()
        }
    }
    
    //clear cache
    @objc func onClearCache(){
        let alert = UIAlertController(title: "Spark", message: Localization(key: Spark.ClEAR_CACHE_YES), preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
             SparkAudioService.shared.clearDiskCache(directory: "themes")
             SparkAudioService.shared.clearDiskCache(directory: "samples")
        }
        let cancel = UIAlertAction(title: Localization(key: Spark.CANCEL), style: .destructive, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func setupViews() {
        view.addSubview(gradientLine)
        view.addSubview(languageSelectionView)
        view.addSubview(genderTitle)
        view.addSubview(genderLine)
        view.addSubview(maleGenderRadioButton)
        view.addSubview(femaleGenderRadioButton)
        view.addSubview(clearCacheButton)
        view.addSubview(signOutButton)
       
    }
    
    override func setupLayouts() {
        
        gradientLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gradientLine.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        gradientLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        gradientLine.heightAnchor.constraint(equalToConstant: gradientLineheight).isActive = true
        
        languageSelectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        languageSelectionView.topAnchor.constraint(equalTo: gradientLine.bottomAnchor, constant: 10).isActive = true
        languageSelectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        languageSelectionView.heightAnchor.constraint(equalToConstant: 95).isActive = true //155
        
        genderTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        genderTitle.topAnchor.constraint(equalTo: languageSelectionView.bottomAnchor, constant: 10).isActive = true
        genderTitle.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        genderTitle.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        genderLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        genderLine.topAnchor.constraint(equalTo: genderTitle.bottomAnchor, constant: -10).isActive = true
        genderLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        genderLine.heightAnchor.constraint(equalToConstant: gradientLineheight).isActive = true
        
        maleGenderRadioButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        maleGenderRadioButton.topAnchor.constraint(equalTo: genderLine.bottomAnchor, constant: 10).isActive = true
        maleGenderRadioButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        maleGenderRadioButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        femaleGenderRadioButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        femaleGenderRadioButton.topAnchor.constraint(equalTo: maleGenderRadioButton.bottomAnchor, constant: 5).isActive = true
        femaleGenderRadioButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        femaleGenderRadioButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        _ = clearCacheButton.anchor(nil, left: view.leftAnchor, bottom: signOutButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 25, bottomConstant: 20, rightConstant: 25, widthConstant: 0, heightConstant: 40)
        _ = signOutButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 25, leftConstant: 25, bottomConstant: 10, rightConstant: 25, widthConstant: 0, heightConstant: 40)

    }
    
    override func configureViewForLocalisation() {
        genderTitle.text = Localization(key: Spark.GENDER_TITLE)
        maleGenderRadioButton.title = Localization(key: Spark.GENDER_MALE_TITLE)
        femaleGenderRadioButton.title = Localization(key: Spark.GENDER_FEMALE_TITLE)
        clearCacheButton.setTitle(Localization(key: Spark.CLEAR_CACHE), for: .normal)
        signOutButton.setTitle(Localization(key: Spark.LOGOUT_TITLE), for: .normal)
    }
    
    func onSelect(_ radio: RadioButton, iselected selected: Bool) {
        
        if(currentSelectedGenderRadioButton != radio) {
            currentSelectedGenderRadioButton.isSelected = false
            currentSelectedGenderRadioButton.circleShape.isHidden = true
            currentSelectedGenderRadioButton.isUserInteractionEnabled = true
        }
        currentSelectedGenderRadioButton = radio
        currentSelectedGenderRadioButton.isUserInteractionEnabled = false
        
        user.gender = currentSelectedGenderRadioButton.name
        
        //coredata
        /*if let user = DataManager.sharedInstance.user {
            if let gender = currentSelectedGenderRadioButton.name {
                user.gender = gender
                _ = DataManager.sharedInstance.save
            }
        } else {
            if let gender = currentSelectedGenderRadioButton.name {
                let user: User = User(context: DataManager.sharedInstance.context)
                user.gender = gender
                    _ = DataManager.sharedInstance.save
            }
            
        }*/
    }
    
    
}
