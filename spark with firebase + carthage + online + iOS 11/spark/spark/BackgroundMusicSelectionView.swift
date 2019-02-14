//
//  BackgroundMusicSelectionView.swift
//  spark
//
//  Created by Vikesh JOYPAUL on 14/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class BackgroundMusicSelectionView: BaseUIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var dataprovider: [BackgroundMusic]!
    
    var cellId: String = "cellId"
    var collectionView: UICollectionView! = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.clear
        return cv
    }()

    override func didLoad() {
        dataprovider = [BackgroundMusic]()
        let musics = SparkDataService.dictionary(Spark.BACKGROUND_MUSIC_KEY)
        for item in musics {
            let music = BackgroundMusic()
            music.setValuesForKeys(item)
            dataprovider.append(music)
        }
        super.didLoad()
    }
    
    override func initComponents() {
        collectionView.register(BackgroundMusicSectionCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // auto select language
        if let index = user.backgroundMusicId {
            let indexpath = IndexPath(item: index, section: 0)
            collectionView.selectItem(at: indexpath, animated: true, scrollPosition: .centeredHorizontally)
        }

        
    }
    
    override func setupViews() {
        addSubview(collectionView)
    }
    
    override func setupLayouts() {
        _ = collectionView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard (dataprovider != nil) else { return 0 }
        return dataprovider.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let backgroundMusicCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BackgroundMusicSectionCell
        backgroundMusicCell.dataprovider = dataprovider[indexPath.item]
        return backgroundMusicCell
    }
    
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let backgroundMusicCell = collectionView.cellForItem(at: indexPath) as! BackgroundMusicSectionCell
        backgroundMusicCell.select()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let backgroundMusicCell = collectionView.cellForItem(at: indexPath) as! BackgroundMusicSectionCell
        backgroundMusicCell.deselect()
    }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 80)
    }
    
    deinit {
        collectionView = nil
        dataprovider = nil
    }
}
