//
//  MenuBarViewcontroller.swift
//  spark
//
//  Created by Vikesh JOYPAUL on 10/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import Foundation
import UIKit


class MenuBarViewController: BaseViewController, MiniPlayerViewDelegate {
    
    var menuBottomConstant: NSLayoutConstraint!
    var miniPlayerBottomConstant: NSLayoutConstraint!
    var delegate: MiniPlayerViewDelegate!
    let deviceType = UIDevice.current.deviceType
    
    var menu: MenuBar! = {
        let m = MenuBar()
        return m
    }()
    
    var miniPlayer: MiniPlayerView! = {
        let m = MiniPlayerView()
        return m
    }()
    
    
    func titleForMiniPlayer(_ title: String) {
        miniPlayer.label.text = title
    }
    
    func audioDidChanged(_ state: AudioPlayerState) {
        switch state {
            case .playing: miniPlayer.isPlaying = true
                break
            case .paused, .stopped:
                miniPlayer.isPlaying = false
                break
            default: break
        }
    }
    
    
    
    override func initComponents() {
        delegate = self
        hideMiniPlayer()
    }
    
    override func setupViews() {
        view.addSubview(menu)
        view.addSubview(miniPlayer)
    }
    
    override func setupLayouts() {
        menuBottomConstant = menu.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -50, rightConstant: 0, widthConstant: 0, heightConstant: 50)[1]
        
        miniPlayerBottomConstant = miniPlayer.anchor(nil, left: view.leftAnchor, bottom: menu.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)[1]
    }
    
    func hideMiniPlayer() {
        switch deviceType {
            case .iPhone5, .iPhone5C, .iPhone5S, .iPhoneSE, .simulator:
                miniPlayer.isHidden = true
                break
            default:
                break
        }
    }
    
}
