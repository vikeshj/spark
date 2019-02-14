//
//  VoiceSelectionView.swift
//  spark
//
//  Created by Vikesh on 14/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class VoiceSelectionView: BaseUIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var dataprovider: [FirePeople]! {
        didSet {}
    }
    
    var cellId: String = "cellId"
    var collectionView: UICollectionView! = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    
    override func didLoad() {
        process(completion: {
            super.didLoad()
            
            SparkAudioService.shared.delayWithSeconds(2.0, completion: {
                //auto select cell
                if let peopleId = self.user.peopleId {
                    guard self.dataprovider != nil else { return }
                    let k = self.filterUser(peopleId)
                    if k.found {
                        let indexpath = IndexPath(item: k.index, section: 0)
                        self.collectionView.selectItem(at: indexpath, animated: true, scrollPosition: .top)
                        self.user.peopleIndex = k.index
                    }
                }
            })
        })
    }
    
    func process(completion: @escaping () -> ()){
        self.dataprovider = [FirePeople]()
        SparkFirebaseService.shared.fetchPeople { (peoples) in
            self.dataprovider = self.filterPeople(peoples)
            self.collectionView.reloadData()
            completion()
        }
    }
    
    override func initComponents() {
        super.initComponents()
        collectionView.register(VoiceSelectionCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func filterUser(_ peopleId: String) -> (index: Int, found: Bool) {
        /// guard dataprovider != nil else { return (index: -1, found: false) }
        /// http://stackoverflow.com/a/38975830
        /// http://swift3tutorials.com/swift-3-for-loops/
        
        for i in 0..<dataprovider.count{
            //if let id =  dataprovider[i].id {
            
            let id = dataprovider[i].id
            if id == peopleId {
                return (index: i, found: true)
            }
            //}
        }
        return (index: -1, found: false)
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
        let voiceCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VoiceSelectionCell
        voiceCell.dataprovider = dataprovider[indexPath.item]
        voiceCell.index = indexPath.row
        return voiceCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 40)
    }
    
    override func configureViewForLocalisation() {
        process(completion: {})
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func filterPeople(_ value: [FirePeople] ) -> [FirePeople] {
        return value.filter({
            guard let locale = user.locale else { return false }
            return locale == SparkLocale.english.description ? $0.language.en == true : $0.language.fr == true
        })
    }
    
    deinit {
        collectionView = nil
        dataprovider = nil
    }
}

