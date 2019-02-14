//
//  ThemeDetailViewCell.swift
//  spark
//
//  Created by Vikesh on 08/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import Foundation
import UIKit

class ThemeDetailViewCell: BaseTableViewCell, UITextFieldDelegate {
    
    private enum Mode: Int {
        case create = 1
        case existing = 2
        case none = 0
    }
    private var actionMode: Mode? = .none
    
    var dataprovider: FireVoice! {
        didSet {
            configureViewFromLocalisation()
        }
    }
    
    let root =  SparkDataService.shared.appDelegate.window?.rootViewController

    
    var svgPlayButton: SVGPlayButton! = {
        let svg = SVGPlayButton()
        svg.playColor = UIColor(red: 104, green: 165, blue: 167)
        svg.pauseColor = UIColor(red: 104, green: 165, blue: 167)
        svg.progressTrackColor = UIColor(red: 104, green: 165, blue: 167)
        svg.translatesAutoresizingMaskIntoConstraints = false
        return svg
    }()
    
    var titleLabel: UILabel! = {
        let lb = UILabel()
        //lb.adjustsFontSizeToFitWidth = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Curse you red Baron"//Localization(key: Spark.PLAYLISTS_TITLE)
        lb.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        lb.textAlignment = .left
        lb.lineBreakMode = .byWordWrapping
        lb.textColor = UIColor(red: 5, green: 157, blue: 123)
        lb.numberOfLines = 0
        lb.backgroundColor = .clear
        //lb.sizeToFit()
        return lb
    }()
    
    var svgPlusButton: SVGPlusButton! = {
        let btn = SVGPlusButton(type: UIButtonType.contactAdd)
        btn.isUserInteractionEnabled = true
        btn.tintColor = UIColor(red: 53, green: 137, blue: 124)
        return btn
    }()
    
    var seperator: UIView! = {
        let v = UIView(frame: .zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red: 181, green: 223, blue: 237)
        return v
    }()
    
    
    override var isSelected: Bool {
        didSet {
     
            /*bgView.backgroundColor = isSelected == true ? UIColor(red: 0, green: 185, blue: 154) : UIColor.clear
            titleLabel.textColor = isSelected == true ? UIColor.white : UIColor(red: 5, green: 157, blue: 123)
            svgPlayButton.playColor = isSelected == true ? UIColor.white : UIColor(red: 104, green: 165, blue: 167)
            svgPlayButton.pauseColor = isSelected == true ? UIColor.white : UIColor(red: 104, green: 165, blue: 167)
            svgPlayButton.progressTrackColor = isSelected == true ? UIColor.white : UIColor(red: 104, green: 165, blue: 167)*/
        }
    }
    
    override func initComponents() {
        svgPlusButton.addTarget(self, action: #selector(showAddToPlayActionSheet), for: .touchUpInside)
        svgPlayButton.willPlay = willPlay
        svgPlayButton.willPause = willPause
    }
    
    override func setupViews() {
        addSubview(bgView)
        addSubview(svgPlayButton)
        addSubview(titleLabel)
        addSubview(svgPlusButton)
        addSubview(seperator)
    }
    
    override func setupLayouts() {
        
        _ = bgView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        svgPlayButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        svgPlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        svgPlayButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        svgPlayButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: svgPlayButton.rightAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: svgPlusButton.leftAnchor, constant: -5).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        _ = svgPlusButton.anchor(nil, left: titleLabel.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        svgPlusButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        svgPlusButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        svgPlusButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        _ = seperator.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 1)
        seperator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    override func configureViewFromLocalisation() {
        
        if let locale = user.locale, let gender = user.gender {
            if locale == SparkLocale.french.rawValue {
                if let maleTitle = dataprovider.title.fr.male, let femaletitle = dataprovider.title.fr.female {
                    titleLabel.text = gender == SparkGender.male.rawValue ? maleTitle : femaletitle == "" ? maleTitle : femaletitle
                }
            } else if locale == SparkLocale.english.rawValue {
                titleLabel.text = dataprovider.title.en
            }
        }
    }
    
    // MARK : - Exisiting
    @objc func showAddToPlayActionSheet() {
        
        let actionSheet = UIAlertController(title: dataprovider.themeTitle, message: "« \(titleLabel.text!) »", preferredStyle: .actionSheet)
        
        let newPlaylist = UIAlertAction(title: Localization(key: Spark.CREATE_NEW_PLAYLIST), style: .default) { (action) in
            self.createNewPlaylist("« \(self.titleLabel.text!) »")
        }
        
        let existingPlaylist = UIAlertAction(title: Localization(key: Spark.ADD_TO_EXISTING_PLAYLIST), style: .default) { (action) in
            
            self.actionMode = Mode.existing
            
            //make spark request here!
                SparkFirebaseService.shared.fectchPlaylistSingleEvent(completion: { (playlist) in
                    
                    if(playlist.count == 0) {
                        //no playlist available
                        let local = Localization(key: Spark.NO_PLAYLIST_WITH_VOICE)
                        let swiftyString = local.replacingOccurrences(of: "$0", with: "\(self.user.peopleName!)")
                        
                        self.createSnackBarWithIcon(swiftyString, icon: #imageLiteral(resourceName: "warning").withRenderingMode(.alwaysTemplate), time: .middle, bottomMargin: 5, color: UIColor.red)
                        return
                    }
                    
                   
                    let modal = ExistingPlaylistViewController()
                    modal.modalPresentationStyle = .overCurrentContext
                    modal.voice = self.dataprovider
                    modal.dataprovider = playlist
                    ApplicationViewController.sharedInstance.presentViewControllerInModalMode(modal)
                    self.actionMode = .none
                    
                })
            }
        
        
        let cancel = UIAlertAction(title: Localization(key: Spark.CANCEL), style: .cancel) { (action) in }
        
        actionSheet.addAction(newPlaylist)
        actionSheet.addAction(existingPlaylist)
        actionSheet.addAction(cancel)
        
        
        let messageAttributed = NSMutableAttributedString(
            string: actionSheet.message!,
            attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)])
        actionSheet.setValue(messageAttributed, forKey: "attributedMessage")
        
        root?.present(actionSheet, animated: true) {
            
        }
    }
    
    
    // MARK : - New Playlist
    func createNewPlaylist(_ message: String){
        
        let alertController = UIAlertController(title: Localization(key: Spark.CREATE_NEW_PLAYLIST), message: message, preferredStyle: .alert)
        
        let messageAttributed = NSMutableAttributedString(
            string: alertController.message!,
            attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)])
        alertController.setValue(messageAttributed, forKey: "attributedMessage")
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = Localization(key: Spark.PLAYLIST_PLACEHOLDER)
            textfield.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        }
        
        let addAction = UIAlertAction(title: Localization(key: Spark.Add1), style: .default) { (action) in
            let textfield = alertController.textFields?.first
            
            guard (textfield?.text?.count)! > 0 else { return }
            
            if let peopleId = self.user.peopleId, let peopleName = self.user.peopleName , let locale = self.user.locale, let title = textfield?.text, let gender = self.user.gender, let track = self.dataprovider, let backgroundMusic = self.user.backgroundMusic {
                
                //firebase code here
                var firePlaylist = Playlist()
                firePlaylist.peopleId =  peopleId
                firePlaylist.peopleName = peopleName
                firePlaylist.locale = locale
                firePlaylist.title = title
                firePlaylist.backgroundMusic = backgroundMusic
                firePlaylist.userGender = gender
                firePlaylist.date = self.user.timeStamp
                
                var voice = PlaylistVoice()
                voice.id = track.id
                voice.date = firePlaylist.date
                voice.themeType = track.themeType
                voice.title = locale == SparkLocale.english.rawValue ? track.title.en : gender == SparkGender.male.rawValue ? track.title.fr.male : track.title.fr.female == "" ? track.title.fr.male : track.title.fr.female
                
                voice.track = locale == SparkLocale.english.rawValue ? track.voices.en : gender == SparkGender.male.rawValue ? track.voices.fr.male : track.voices.fr.female
                firePlaylist.voice = voice
                
                SparkFirebaseService.shared.create(firePlaylist, title: title, completion: {
                    self.actionMode = .none
                    self.createSnackBarWithIcon(Localization(key: Spark.PLAYLIST_CREATED), icon: UIImage(), time: .middle, bottomMargin: 5, color: UIColor(red: 54, green: 155, blue: 250))
                })
            }
            
        }
        
        
        let cancelAction = UIAlertAction(title: Localization(key: Spark.CANCEL), style: .default, handler: { (action) in
            self.actionMode = .none
        })
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        root?.present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func willPlay(){
        ///
        var track: String = ""
        if let locale = user.locale, let peopleId = user.peopleId, let gender = user.gender {
            
            if locale == SparkLocale.french.rawValue {
                if let male = dataprovider.voices.fr.male, let female = dataprovider.voices.fr.female {
                    track = gender == SparkGender.male.rawValue ? male : female == "" ? male : female
                }
            } else if locale == SparkLocale.english.rawValue {
                track = dataprovider.voices.en!
            }
            let folder = "themes/\(dataprovider.themeType)/\(locale)/\(peopleId)/"
            let sound = "themes/\(dataprovider.themeType)/\(locale)/\(peopleId)/\(track)"
            let file = SparkAudioService.shared.m4aExists(file: sound)
            if(file.success){
                print("local file", file.destination.path)
                SparkAudioService.shared.playMonoSound(file.destination.path, completion: { (bool) in
                    if(self.svgPlayButton.playing) { self.svgPlayButton.playing = false }
                })
            } else {
                // load files if not exists
                let ref = SparkDataService.shared.fireabaseStorageNode(sound)
                
                ref.downloadURL(completion: { (url, error) in
                    if error != nil {
                        self.svgPlayButton.playing = false
                        //if no connection
                        print("file not found or no internet connection")
                        self.createSnackBarWithIcon(Localization(key: Spark.NO_INTERNET_CONNECTION), icon: #imageLiteral(resourceName: "warning"), time: .middle)
                        return
                    }
                    if url != nil {
                        DispatchQueue.global(qos: .background).async {
                            SparkAudioService.downloadM4aFiles(url!, subDirectory: folder, completion: { (path) in
                                SparkAudioService.shared.playMonoSound(path, completion: { (bool) in
                                    if(self.svgPlayButton.playing) { self.svgPlayButton.playing = false }
                                })
                            })
                        }
                        
                    }
                })
            
            }
        }
    }
    
    func willPause() { }
    
    
    override func prepareForReuse() {
        if (svgPlayButton != nil && !dataprovider.isSelected && svgPlayButton.playing) {
            svgPlayButton.playing = false
        }
    }
    
}
