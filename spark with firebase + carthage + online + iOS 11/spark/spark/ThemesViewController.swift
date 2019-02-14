//
//  ThemesViewController.swift
//  spark
//
//  Created by Vikesh on 19/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class ThemesViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static var sharedInstance:ThemesViewController = ThemesViewController()
    
    //var dataprovider: [Themes]!
    fileprivate var dataprovider: [FireTheme]! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //fileprivate var searches = [FireTheme]()
    
    var headerId = "headerId"
    
    //override viewDidLoad
    override func viewDidLoad() {
        didLoad()
    }
    
     override func didLoad() {
        dataprovider = [FireTheme]()
        /*dataprovider = [Themes]()
        let themes = DataManager.dictionary(Spark.THEMES_KEY)
        for item in themes {
            let theme = Themes()
            theme.setValuesForKeys(item)
            dataprovider.append(theme)
        }*/
        self.view.alpha = 0
        //Firebase Objects
        SparkFirebaseService.shared.fetchThemes { (themes) in
            self.dataprovider = themes
            self.forceInit()
            UIView.animate(withDuration: 0.5, animations: { 
                self.view.alpha = 1
            })
        }
    }
    
    override func initComponents() {
        
        /*collectionView.register(CollectionViewSearchBarHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)*/
        collectionView.register(ThemeCell.self, forCellWithReuseIdentifier: cellId)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            //flowLayout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        
        //collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        //collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    }
    
    
    
    override func setupViews() {
        view.addSubview(collectionView)
    }
    
    override func setupLayouts() {
        
        _ = collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 90, rightConstant: 0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataprovider.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ThemeCell
        cell.dataprovider = dataprovider[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
        let details = ThemesDetailViewController()
        details.dataProvider = dataprovider[indexPath.item]
        details.modalPresentationStyle = .overCurrentContext
        ApplicationViewController.sharedInstance.pushViewController(page: details)
        //UIApplication.shared.keyWindow?.rootViewController?.navigationController?.pushViewController(details, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: Layout.sharedInstance.cellHelight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: 48)
    }*/
    
    
    deinit {
        collectionView = nil
        dataprovider = nil
    }
}


class CollectionViewSearchBarHeaderCell: BaseCollectionViewReusableView {
    
    override func setupViews() {
         addSubview(searchBox)
    }

    override func setupLayouts() {
        _ = searchBox.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        searchBox.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    override func configureViewFromLocalisation() {
        searchBox.placeholder = Localization(key: Spark.SEARCH_PLACEHOLDER)
    }
}


public extension UISearchBar {
    
    public func setText(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}
