//
//  MiniPlayerControls.swift
//  spark
//
//  Created by Vikesh on 01/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

protocol MiniPlayerViewDelegate {
    func audioDidChanged(_ state:AudioPlayerState)
    func titleForMiniPlayer(_ title: String)
}

class MiniPlayerView: BaseUIView {
    
    override func initComponents() {
        super.initComponents()
        createVibrancyWithblur()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPlayer))
        self.addGestureRecognizer(tap)
        playStopButton.addTarget(self, action: #selector(triggerPlay), for: .touchUpInside)
    }
    
    override func setupViews() {
        addSubview(bgImageView)
        addSubview(blurView)
        sendSubview(toBack: bgImageView)
        //addSubview(nowPlaying)
        addSubview(label)
        addSubview(playStopButton)
        //addSubview(backButton)
        //addSubview(nextButton)
        //addSubview(playerButton)
        //addSubview(shuffleButton)
        //addSubview(loopButton)
    }
    
    override func setupLayouts() {
       
        _ = blurView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        _ = bgImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
       // _ = nowPlaying.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        _ = label.anchor(nil, left: leftAnchor, bottom: nil, right: playStopButton.leftAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 250, heightConstant: 30)
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        /*_ = backButton.anchor(nil, left: label.rightAnchor, bottom: nil, right: playStopButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 28)
         backButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true*/
        
        _ = playStopButton.anchor(nil, left: label.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 10, widthConstant: 30, heightConstant: 30)
        playStopButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        /*playStopButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        playStopButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        playStopButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        playStopButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true*/
        
        /*backButton.centerXAnchor.constraint(equalTo: playStopButton.centerXAnchor, constant: -60).isActive = true
        backButton.centerYAnchor.constraint(equalTo: playStopButton.centerYAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 28).isActive = true*/
        
        /*nextButton.centerXAnchor.constraint(equalTo: playStopButton.centerXAnchor, constant: 60).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: playStopButton.centerYAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 28).isActive = true*/
        
        /*playerButton.centerXAnchor.constraint(equalTo: playStopButton.centerXAnchor, constant: 150).isActive = true
        playerButton.centerYAnchor.constraint(equalTo: playStopButton.centerYAnchor).isActive = true
        playerButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        playerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true*/
        
        /*shuffleButton.centerXAnchor.constraint(equalTo: playStopButton.centerXAnchor, constant: -130).isActive = true
        shuffleButton.centerYAnchor.constraint(equalTo: playStopButton.centerYAnchor).isActive = true
        shuffleButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        shuffleButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        loopButton.centerXAnchor.constraint(equalTo: playStopButton.centerXAnchor, constant: 130).isActive = true
        loopButton.centerYAnchor.constraint(equalTo: playStopButton.centerYAnchor).isActive = true
        loopButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        loopButton.heightAnchor.constraint(equalToConstant: 18).isActive = true*/
        
    }
    
    @objc func openPlayer(){
        ApplicationViewController.sharedInstance.openAudioPlayer()
    }
    
    var isPlaying: Bool = false {
        didSet {
            let image = isPlaying == true ? #imageLiteral(resourceName: "stopSingle") : #imageLiteral(resourceName: "playSingle")
            playStopButton.setImage(image, for: .normal)
        }
    }
    
     @objc func triggerPlay(){
        if let media = SparkAudioService.shared.mediaPlayer {
            print(media.state)
            if media.state == .playing {
                isPlaying = true
                media.pause()
            } else if(media.state == .paused) {
                isPlaying = false
                media.resume()
            } else if (media.state == .stopped) {
               media.play(items: SparkAudioService.shared.audioItems, startAtIndex: 0)
            }
        }
    }
    
    override func configureViewForLocalisation() {
        //print("configureViewForLocalisation mini")
        //nowPlaying.text = Localization(key: Spark.PLAYLISTS_NOW_PLAYING)
        label.text = Localization(key: Spark.NO_PLAYLIST_PLAYING)
    }
    
    fileprivate var blurEffect: UIBlurEffect!
    fileprivate var blurView: UIVisualEffectView!
    fileprivate var bgImageView: UIImageView!
    
    func createVibrancyWithblur(){
        bgImageView = UIImageView()
        bgImageView.image = #imageLiteral(resourceName: "mainBackground")
        bgImageView.contentMode = .scaleToFill
        blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
     }

    
    // MARK: - Components
    let nowPlaying:UILabel! = {
        let lb = UILabel()
        lb.adjustsFontSizeToFitWidth = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = Localization(key: Spark.PLAYLISTS_NOW_PLAYING)
        lb.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.regular)
        lb.textAlignment = .left
        lb.textColor = UIColor.white
        lb.isHidden = true
        return lb
    }()
    
    let label: MarqueeLabel! = {
        let lb = MarqueeLabel(frame: .zero)
        lb.text = Localization(key: Spark.NO_PLAYLIST_PLAYING)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.type = .continuous
        //lb.animationCurve = .easeInOut
        lb.speed = .duration(24.0)
        lb.leadingBuffer = 10
        lb.trailingBuffer = 10
        lb.fadeLength = 30.0
        lb.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
        lb.textColor = .white
        return lb
    }()
    
    // MARK: - controls
    var playStopButton: UIButton! = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "playSingle").withRenderingMode(.alwaysTemplate), for: .normal)
        b.tintColor = Color.selectedColor
        return b
    }()
    
    var nextButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "forward"), for: .normal)
        b.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        return b
    }()
    
    var playerButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "player").withRenderingMode(.alwaysTemplate), for: .normal)
        b.tintColor = .white
        //b.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        return b
    }()
    
    let backButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        b.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        return b
    }()
    
    let shuffleButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "shuffle").withRenderingMode(.alwaysTemplate), for: .normal)
        b.tintColor = Color.normalColor
        return b
    }()
    
    let loopButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "loop").withRenderingMode(.alwaysTemplate), for: .normal)
        b.tintColor = Color.normalColor
        return b
    }()
}
