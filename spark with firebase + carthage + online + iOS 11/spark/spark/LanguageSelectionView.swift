//
//  LanguageSelectionView.swift
//  spark
//
//  Created by Vikesh on 12/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class LanguageSelectionView: BaseUIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var dataprovider: [Languages]!
    
    var cellId: String = "cellId"
    var collectionView: UICollectionView! = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    override func didLoad() {
        dataprovider = [Languages]()
        let languages = SparkDataService.dictionary(Spark.LANGUAGUES_KEYS)
        
        for item in languages {
            let language = Languages()
            language.setValuesForKeys(item)
            dataprovider.append(language)
        }
        
        super.didLoad()
    }
    
    override func initComponents() {
        collectionView.register(LanguageSelectionCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        // auto select language
        if let localeId = user.localeId {
            let indexpath = IndexPath(item: localeId, section: 0)
            collectionView.selectItem(at: indexpath, animated: true, scrollPosition: .centeredHorizontally)
        }
        
    }
    
    override func setupViews() {
        addSubview(collectionView)
    }
    
    override func setupLayouts() {
        _ = collectionView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard (dataprovider != nil) else { return 0 }
        return dataprovider.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let languageCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LanguageSelectionCell
        languageCell.dataprovider = dataprovider[indexPath.item]
        return languageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 45)
    }
    
    deinit {
        collectionView = nil
        dataprovider = nil
    }
    
}
