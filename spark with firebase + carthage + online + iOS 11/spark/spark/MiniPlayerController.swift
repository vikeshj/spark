//
//  UIAudioPlayer.swift
//  spark
//
//  Created by Vikesh on 01/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class MiniPlayerController: BaseViewController {
    
    var viewHeightAnchor: NSLayoutConstraint!
    
    /// mini controls of sound
    var miniPlayerView: MiniPlayerView! = {
        let mpc = MiniPlayerView()
        mpc.translatesAutoresizingMaskIntoConstraints = false
        return mpc
    }()
    
    
    override func initComponents() {
        view.clipsToBounds = true
        //view.layer.masksToBounds = true
    }
    
    override func setupViews() {
         view.addSubview(miniPlayerView)
    }
    
    override func setupLayouts() {
        
        viewHeightAnchor = view.heightAnchor.constraint(equalToConstant: 100)
        viewHeightAnchor.isActive = true
        
        _ = miniPlayerView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
}
