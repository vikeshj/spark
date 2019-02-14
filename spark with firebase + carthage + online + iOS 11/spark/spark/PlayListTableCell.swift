//
//  PlayListTableCell.swift
//  spark
//
//  Created by Vikesh on 09/11/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView

class PlayListTableCell: BaseTableViewCell {
    
    var dataprovider: FirePlaylist! {
        didSet {
            let title = dataprovider.title
            let peopleName = dataprovider.peopleName
            titleLabel.text = title
            detailLabel.text  = "\(Localization(key: Spark.WITH_THE_VOICE_OF)) \(peopleName)"
            
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
        lb.text = Localization(key: Spark.IN_PROGRESS)
        lb.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        lb.textAlignment = .left
        lb.lineBreakMode = .byWordWrapping
        lb.textColor = UIColor(red: 5, green: 157, blue: 123)
        lb.numberOfLines = 0
        lb.backgroundColor = .clear
        return lb
    }()
    
    var detailLabel: UILabel! = {
        let lb = UILabel()
        //lb.adjustsFontSizeToFitWidth = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = Localization(key: Spark.IN_PROGRESS)
        lb.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        lb.textAlignment = .left
        lb.lineBreakMode = .byWordWrapping
        lb.textColor = UIColor.gray
        lb.numberOfLines = 1
        lb.backgroundColor = .clear
        return lb
    }()
    
   /*var equalizer:NVActivityIndicatorView! = {
        let eq = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: NVActivityIndicatorType.audioEqualizer, color: UIColor(red: 5, green: 157, blue: 123), padding: 10)
        eq.isHidden = true
        return eq
    }()*/
    
    var seperator: UIView! = {
        let v = UIView(frame: .zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red: 181, green: 223, blue: 237)
        return v
    }()
    
    
    override func initComponents() {
        accessoryType = .disclosureIndicator
        backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        NotificationCenter.default.addObserver(self, selector: #selector(jukeboxStateChanged), name: NSNotification.Name(rawValue: kJukeBoxStateNotification), object: nil)
    }
    
    override func setupViews() {
        //addSubview(equalizer)
        addSubview(icon)
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(seperator)
    }
    
    override func setupLayouts() {
        
        
        //_ = equalizer.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 5)
        //equalizer.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        _ = icon.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        _ = titleLabel.anchor(topAnchor, left: icon.rightAnchor, bottom: detailLabel.topAnchor, right: rightAnchor, topConstant: 13, leftConstant: 10, bottomConstant: 1, rightConstant: 30, widthConstant: 0, heightConstant: 0)
        
        _ = detailLabel.anchor(titleLabel.bottomAnchor, left: icon.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 13, leftConstant: 10, bottomConstant: 13, rightConstant: 30, widthConstant: 0, heightConstant: 20)
        
        _ = seperator.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 1)
        seperator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
     }
    
    @objc func jukeboxStateChanged(notification: NSNotification){
       jukeboxState()
    }
    
    override func selectedCell(_ animated: Bool) {
        //cellWithSelected()
    }
    
    override func unSelectedCell(_ animated: Bool) {
        cellWithUnSelected()
    }
    
    override func cellWithSelected() {
        jukeboxState()
    }
    
    override func cellWithUnSelected() {
        icon.isHidden = false
        //equalizer.stopAnimating()
    }
    
    func jukeboxState() {
        /*if(isSelected) {
            if let jukebox = SparkAudioService.shared.jukebox {
                switch(jukebox.state){
                case .playing:
                    icon.isHidden = true
                    equalizer.startAnimating()
                    break
                case .ready, .paused:
                    icon.isHidden = false
                    equalizer.stopAnimating()
                    break
                default: break
                }
            }
        }*/
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kJukeBoxStateNotification), object: nil)
    }
}
