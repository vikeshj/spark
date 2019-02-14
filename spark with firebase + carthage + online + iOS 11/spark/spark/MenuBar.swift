//
//  MenuBar.swift
//  spark
//
//  Created by Vikesh JOYPAUL on 14/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit


class MenuBar: BaseUIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var cellId: String = "cellId"
    var images: Array<String>!
    var navigation:Array <NavigationPageType>!
    var indexPath: IndexPath! {
        didSet {
            collectionview.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        }
    }
    
    lazy var collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.isScrollEnabled = false
        cv.backgroundColor = UIColor(red: 34, green: 34, blue: 34)
        return cv
    }()
    
    override func initComponents() {
        backgroundColor = UIColor(red: 34, green: 34, blue: 34)
        
        images = ["homeIcon","themesIcon","playlistsIcon","galleryIcon", "configurationIcon"]
        navigation = [.home, .themes, .playlists, .gallery, .configuration]
        
        collectionview.register(MenuBarCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func setupViews() {
        addSubview(collectionview)
    }
    
    override func setupLayouts() {
        _ = collectionview.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let menubarCell = collectionview.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuBarCell
        menubarCell.image = images[indexPath.item]
        menubarCell.navigationPageType = navigation[indexPath.item]
        return menubarCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 5, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(navigate != nil ) {
            if let navigationType = NavigationPageType(rawValue: indexPath.item) {
                navigate!(navigationType)
            }
        }
    }
}
