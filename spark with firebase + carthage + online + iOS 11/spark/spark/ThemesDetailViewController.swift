//
//  ThemesDetailViewController.swift
//  spark
//
//  Created by Vikesh on 07/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit
//import Firebase

class ThemesDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    fileprivate var fireVoices: [FireVoice] = [FireVoice]()
    fileprivate var fireSearch: [FireVoice] = [FireVoice]()
    var dataProvider: FireTheme!
    var searchBarActive:Bool = false
    
//    var searchBox: UISearchBar! = {
//        let search = UISearchBar()
//        search.placeholder = Localization(key: Spark.SEARCH_PLACEHOLDER)
//        search.enablesReturnKeyAutomatically = true
//        search.searchBarStyle = UISearchBarStyle.default
//        search.keyboardType = UIKeyboardType.alphabet
//        search.enablesReturnKeyAutomatically = true
//        //search.translatesAutoresizingMaskIntoConstraints = false
//        //search.alpha = 0
//        return search
//    }()
    
    lazy var searchController: UISearchController! = {
        let sc = UISearchController(searchResultsController: nil)
        sc.dimsBackgroundDuringPresentation = false
        sc.searchBar.placeholder = Localization(key: Spark.SEARCH_PLACEHOLDER)
        sc.hidesNavigationBarDuringPresentation = false
        sc.searchBar.setValue(Localization(key: Spark.CANCEL), forKey: "cancelButtonText")
        sc.searchBar.searchBarStyle = .default
        sc.searchBar.enablesReturnKeyAutomatically = true
        sc.searchBar.searchBarStyle = UISearchBarStyle.default
        sc.searchBar.keyboardType = UIKeyboardType.alphabet
        sc.searchBar.enablesReturnKeyAutomatically = true
        sc.searchBar.delegate = self
        return sc
    }()
    
    var titleLabel: UILabel! = {
        let lb = UILabel()
        lb.adjustsFontSizeToFitWidth = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "We❤️spark "//Localization(key: Spark.PLAYLISTS_TITLE)
        lb.font = UIFont.systemFont(ofSize: FontSize.shared.titleSize, weight: UIFont.Weight.light)
        lb.textAlignment = .center
        lb.textColor = UIColor.white
        lb.sizeToFit()
        lb.alpha = 0
        return lb
    }()
    
    
    var tableView: UITableView! = {
        let tb = UITableView(frame: .zero, style: UITableViewStyle.plain)
        tb.backgroundColor = .clear
        tb.alpha = 0
        return tb
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationItem.title = dataProvider.name.en
        //navigationItem.titleView?.tintColor = UIColor.white
        //navigationItem.backBarButtonItem?.title = "xxxxxx"
        navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItems = BackButton.createWithText(Localization(key: Spark.THEMES), color: .white, target: self, action: #selector(back))
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //fectch list
    override func viewDidLoad() {
        definesPresentationContext = true
        background = createImage(name: "mainBackground")
        view.addSubview(background)
        _ = background.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        fireVoices = [FireVoice]()
        titleLabel.text = Localization(key: Spark.PLAYLISTS_TITLE)
        didLoad()
    }
    
    override func didLoad() {
        SparkFirebaseService.shared.fetchTracks(dataProvider.themeType) { (tracks) in
            self.fireVoices = tracks
            self.forceInit()
            UIView.animate(withDuration: 0.5, animations: {
                //self.searchBox.alpha = 1
                self.titleLabel.alpha = 1
                self.tableView.alpha = 1
            })
            self.tableView.reloadData()
        }
    }
    
    
    override func initComponents() {
        
        tableView.register(ThemeDetailViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 65
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableHeaderView?.backgroundColor = .clear
        //searchController.delegate = self
        definesPresentationContext = true
        if let locale = user.locale {
            titleLabel.text  = locale == SparkLocale.english.rawValue ? dataProvider.name.en : dataProvider.name.fr
        }
        

    }

    override func setupViews() {
        //view.addSubview(searchBox)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    override func setupLayouts() {
       // _ = searchBox.anchor(titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        //searchBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        _ = titleLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 60, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        _ = tableView.anchor(titleLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant:0, bottomConstant: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchBarActive && searchController.searchBar.text != "" {
            return self.fireSearch.count
        }
        return fireVoices.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ThemeDetailViewCell
        var data: FireVoice!
        if(searchBarActive){
            data = fireSearch[indexPath.row]
        }
        else {
            data = fireVoices[indexPath.row]
        }
        if let locale = user.locale {
            data.themeTitle = locale == SparkLocale.english.rawValue ? dataProvider.name.en : dataProvider.name.fr
            
        }
        cell.dataprovider = data
        return cell
    }
    
    // search filter
    
    
    func containsWord(text: String, words: [String]) -> Bool {
        return words
            .reduce(false) { $0 || text.contains($1.lowercased()) }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            self.searchBarActive = true
            filterContentForSearchText(searchText: searchText)
            tableView.reloadData()
        }
        else {
            self.searchBarActive = false
            tableView.reloadData()
        }
    }
    
    // search filter
    func filterContentForSearchText(searchText:String) {
        var text = ""
        //let terms = searchText.components(separatedBy: " ")
        
        self.fireSearch = self.fireVoices.filter { (voice:FireVoice) -> Bool in
            if let locale = user.locale, let gender = user.gender {
                if locale == SparkLocale.french.rawValue {
                    if let maleTitle = voice.title.fr.male, let femaleTitle = voice.title.fr.female {
                        text = gender == SparkGender.male.rawValue ? maleTitle : femaleTitle == "" ? maleTitle : femaleTitle
                    }
                } else if locale == SparkLocale.english.rawValue {
                    text = voice.title.en!
                }
            }
            let diacritic = text.folding(options: .diacriticInsensitive, locale: .current)
            return diacritic.lowercased().contains(searchText.lowercased())
            //return shortFilter(input: text.lowercased(), subStrings: terms)
        }
    }

    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBarActive = false
        searchBar.setShowsCancelButton(false, animated: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancelSearching()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarActive = true
        self.view.endEditing(true)
    }
    
    
    
    func cancelSearching(){
        self.searchBarActive = false
        self.searchController.searchBar.resignFirstResponder()
        self.searchController.searchBar.text = ""
    }
    
    
    
    // set status indicatior to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func configureViewForLocalisation() {
        searchController.searchBar.placeholder = Localization(key: Spark.SEARCH_PLACEHOLDER)
        searchController.searchBar.setValue(Localization(key: Spark.CANCEL), forKey: "cancelButtonText")
    }
    
     @objc func back (){
        if let navigation = self.navigationController {
            SparkAudioService.shared.stopAllSound()
            //self.searchController.dismiss(animated: true, completion: nil)
            navigation.popViewController(animated: true)
        }
    }
}
