//
//  ExistingPlaylistViewController.swift
//  spark
//
//  Created by Vikesh on 23/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class ExistingPlaylistViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataprovider: [FirePlaylist]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    var voice: FireVoice!
    
    override func viewDidLoad() {
        createVibrancyWithblur()
        didLoad()
    }
    
    override func didLoad() {
        // executes filter code per people id
        if let peopleId = user.peopleId {
            SparkFirebaseService.shared.fetchUserPlayerList(peopleId, key: FireBaseKey.playlists, completion: { (playlist) in
                self.dataprovider = playlist
                self.forceInit()
            })
        }
    }
    
    override func initComponents() {
        createVibrancyWithblur()
        tableView.register(ExistingPlaylistTableCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    override func setupLayouts() {
        
        
        _ = titleLabel?.anchor(view.topAnchor, left: closeBtn.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 25)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
       _ = tableView.anchor(titleLabel.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = dataprovider?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.cellForRow(at: indexPath) as! ExistingPlaylistTableCell
        
        if let locale = user.locale, let gender = user.gender {
            let id = dataprovider[indexPath.item].id
            var fvoice: PlaylistVoice = PlaylistVoice()
            fvoice.id = voice.id
            fvoice.date = user.timeStamp
            fvoice.themeType = voice.themeType
            fvoice.title = locale == SparkLocale.english.rawValue ? voice.title.en : gender == SparkGender.male.rawValue ? voice.title.fr.male : (voice.title.fr.female == "") ? voice.title.fr.male : voice.title.fr.female
            
            fvoice.track = locale == SparkLocale.english.rawValue ? voice.voices.en : gender == SparkGender.male.rawValue ? voice.voices.fr.male : voice.voices.fr.female
            SparkFirebaseService.shared.append(id, voice: fvoice, completion: { success in
                self.createSnackBarWithIcon(Localization(key: Spark.PLAYLIST_ADDED), icon: UIImage(), time: .middle, bottomMargin: 5, color: UIColor(red: 54, green: 155, blue: 250))
                self.close()
            })
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ExistingPlaylistTableCell
        cell.dataprovider = dataprovider[indexPath.item]
        return cell
    }
    
     @objc func close() {
        dismiss(animated: true, completion: {
        })
    }
    
    
    func createVibrancyWithblur(){
        blurEffect = UIBlurEffect(style: blurEffectStyle)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(blurView)
        view.sendSubview(toBack: blurView)
        view.addSubview(closeBtn)
        
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        view.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
        _ = blurView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        _ = closeBtn.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 25, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
    }
    
    fileprivate var blurEffectStyle: UIBlurEffectStyle = .light
    fileprivate var blurEffect: UIBlurEffect!
    fileprivate var blurView: UIVisualEffectView!
    var titleLabel: UILabel! = {
        let lb = UILabel()
        lb.adjustsFontSizeToFitWidth = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "UserPlaylist"//Localization(key: Spark.PLAYLISTS_TITLE)
        lb.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        lb.textAlignment = .center
        lb.textColor = UIColor.white
        return lb
    }()
    
 
    
    
    lazy var tableView: UITableView! = {
        let tb = UITableView(frame: .zero, style: UITableViewStyle.plain)
        tb.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        tb.separatorStyle = .none
        tb.estimatedRowHeight = 65
        tb.rowHeight = UITableViewAutomaticDimension
        tb.dataSource = self
        tb.delegate = self
        return tb
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
}

/// ----- CELL

class ExistingPlaylistTableCell: BaseTableViewCell {
    
    var dataprovider: FirePlaylist! {
        didSet {
            titleLabel.text = dataprovider.title
        }
    }
    
    var icon: UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "playlistsIcon").withRenderingMode(.alwaysTemplate))
        i.tintColor = UIColor(red: 5, green: 157, blue: 123)
        i.contentMode = .scaleAspectFit
        return i
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
        return lb
    }()
    
    
    var seperator: UIView! = {
        let v = UIView(frame: .zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red: 181, green: 223, blue: 237)
        return v
    }()
    
    override func setupViews() {
        addSubview(icon)
        addSubview(titleLabel)
        addSubview(seperator)
    }
    
    override func setupLayouts() {
        
          _ = icon.anchor(titleLabel.topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
        _ = titleLabel.anchor(topAnchor, left: icon.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 13, leftConstant: 10, bottomConstant: 17, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        
        _ = seperator.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 1)
        seperator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
}
