//
//  PlayListsViewController.swift
//  spark
//
//  Created by Vikesh on 24/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

enum Category: Int {
    case userPlaylist = 0
    case defaultPlaylist
}


class PlayListsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sectionType: Category = .userPlaylist
    
    var dataprovider: [FirePlaylist]! {
        didSet {
            //reload table view
            tableView.reloadData()
            noPlaylistLabel.isHidden =  dataprovider.count == 0 ? false : true
        }
    }
    
    // MARK: - Mini[player] Controller
    var miniPlayerController: MiniPlayerController! = {
        let mp = MiniPlayerController()
        mp.view.translatesAutoresizingMaskIntoConstraints = false
        return mp
    }()
    
    
    // MARK: - Components
    
    var noPlaylistLabel: UILabel! = {
        let lb = UILabel()
        lb.adjustsFontSizeToFitWidth = true
        lb.text = Localization(key: Spark.NO_PLAYLIST_AVAILABLE)
        lb.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        lb.textAlignment = .center
        lb.lineBreakMode = .byWordWrapping
        lb.numberOfLines = 0
        lb.textColor = UIColor.lightGray.withAlphaComponent(0.8)
        return lb
    }()
    
    
    var titleLabel: UILabel! = {
        let lb = UILabel()
        lb.adjustsFontSizeToFitWidth = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = Localization(key: Spark.PLAYLISTS_TITLE)
        lb.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        lb.textAlignment = .center
        lb.textColor = UIColor.white
        return lb
    }()
    
    var segmentControl: UISegmentedControl! = {
        let sc = UISegmentedControl(items:[Localization(key: Spark.MY_PLAYLISTS), Localization(key: Spark.DEFAULT_PLAYLISTS)])
        sc.tintColor = Color.selectedColor
        sc.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: UIControlState.selected)
        sc.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: UIControlState.normal)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    
    var addButton:UIButton! = {
        let add = UIButton(type: UIButtonType.contactAdd)
        add.tintColor = Color.normalColor
        add.isHidden = true
        return add
    }()
    
    var tableView: UITableView! = {
        let tb = UITableView(frame: .zero, style: UITableViewStyle.plain)
        return tb
    }()
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector:#selector(languageChangedNotification), name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)
        miniPlayerController.view.isHidden = true
        didLoad()
    }
    
    override func didLoad() {
        fetchPlaylist(FireBaseKey.playlists, completion: {
            self.forceInit()
            self.tableView.reloadData()
        })
    }
    
    func fetchPlaylist(_ key: String, completion: @escaping ()->()) {
        // load user playlist
        SparkFirebaseService.shared.fetchUserPlayerList("none", key: key, completion: { (firePlaylist) in
            self.dataprovider = [FirePlaylist]()
            self.dataprovider = (key == FireBaseKey.defaults) ? self.filterDefaultPlaylistWithLocale(firePlaylist) : firePlaylist
            completion()
        })
    }
    
    override func initComponents() {
        
        titleLabel.text = Localization(key: Spark.PLAYLISTS_TITLE);
        
        tableView.register(PlayListTableCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 65
        tableView.rowHeight = UITableViewAutomaticDimension
        segmentControl.addTarget(self, action: #selector(onSelect), for: .valueChanged)
    }
    
    override func setupViews() {
        view.addSubview(segmentControl)
        view.addSubview(addButton)
        view.addSubview(tableView)
        view.addSubview(titleLabel)
        view.addSubview(noPlaylistLabel)
        view.addSubview(miniPlayerController.view)
    }
    
    override func setupLayouts() {
        
        _ = noPlaylistLabel.anchor(tableView.topAnchor, left: tableView.leftAnchor, bottom: tableView.bottomAnchor, right: tableView.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20)
        
        
        _ = titleLabel.anchor(view.topAnchor, left: nil, bottom: nil, right: nil)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        _ = segmentControl.anchor(titleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 10)
        segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 29).isActive = true
        
        _ = addButton.anchor(segmentControl.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 25, heightConstant: 25)
        
        // miniPlayer
        _ = miniPlayerController.view.anchor(segmentControl.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = tableView.anchor(segmentControl.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant:0, bottomConstant: 0)
    }
    
    override func configureViewForLocalisation() {
        titleLabel.text = Localization(key: Spark.PLAYLISTS_TITLE);
        segmentControl.setTitle(Localization(key: Spark.MY_PLAYLISTS), forSegmentAt: 0)
        segmentControl.setTitle(Localization(key: Spark.DEFAULT_PLAYLISTS), forSegmentAt: 1)
        noPlaylistLabel.text = Localization(key: Spark.NO_PLAYLIST_AVAILABLE)
        
        onSelect(segmentControl)
        
    }
    
     @objc func onSelect(_ sender: UISegmentedControl) {
        //let indexPath = IndexPath(item: sender.selectedSegmentIndex, section: 0)
        addButton.isHidden = sender.selectedSegmentIndex == 0 ? true : true
        if(sender.selectedSegmentIndex == 0){
            
            fetchPlaylist(FireBaseKey.playlists, completion: {
                self.sectionType = .userPlaylist
                self.tableView.reloadData()
            })
        }
        else {
            fetchPlaylist(FireBaseKey.defaults, completion: {
                self.sectionType = .defaultPlaylist
                self.tableView.reloadData()
            })
        }
    }
    
    func filterDefaultPlaylistWithLocale(_ playlist:[FirePlaylist]) -> [FirePlaylist]{
        return playlist.filter({ (plist) -> Bool in
           return plist.locale == Localisator.shared.current
        })
    }
    
    func onAddPlaylist(_ sender: UIButton){
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = dataprovider?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PlayListTableCell
        cell.dataprovider = dataprovider[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let alarm = BaseUITableViewRowAction(style: .default, title: "     ") { action, index in
            let alarmNC = AlarmNavigationController()
            alarmNC.dataprovider = self.dataprovider[indexPath.row]
            //self.createSnackBarWithIcon(Spark.COMING_SOON, icon: UIImage(), time: .middle)
            ApplicationViewController.sharedInstance.present(alarmNC, animated: true, completion: {})
        }
        alarm.backgroundColor = UIColor(red: 5, green: 28, blue: 48)//UIColor(red: 136, green: 28, blue: 254)
        alarm.image = #imageLiteral(resourceName: "alarm")
        
        
        let edit = BaseUITableViewRowAction(style: .default, title: "     ") { action, index in
            self.editPlaylistName(indexPath)
        }
        edit.backgroundColor = UIColor(red: 60, green: 144, blue: 168)
        edit.image = #imageLiteral(resourceName: "edit")
        
        let delete = BaseUITableViewRowAction(style: .destructive, title: "     ") { action, index in
            let playlistId = self.dataprovider[indexPath.row].id
            /*tableView.beginUpdates()
             tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
             tableView.endUpdates()*/
            SparkFirebaseService.shared.removePlaylist(playlistId, completion: { (bool) in
                self.createSnackBarWithIcon(Localization(key: Spark.DELETE_PLAYLIST), icon: #imageLiteral(resourceName: "warning") , time: .short, bottomMargin: 5, color: .red)
            })
        }
        delete.image = #imageLiteral(resourceName: "trash")
        delete.backgroundColor = .red
        if(segmentControl.selectedSegmentIndex == 0) {
            return [delete,edit,alarm]
        }
        return [alarm]
    }
    
    func editPlaylistName(_ indexPath: IndexPath) {
        
        //let title = dataprovider[indexPath.row].title!
        let alertController = UIAlertController(title: Localization(key: Spark.EDIT_PLAYLIST_TITLE), message: "", preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = Localization(key: Spark.PLAYLIST_PLACEHOLDER)
            textfield.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
            textfield.text = self.dataprovider[indexPath.row].title
        }
        let addAction = UIAlertAction(title: Localization(key: Spark.Add), style: .default) { (action) in
            let textfield = alertController.textFields?.first
            guard (textfield?.text?.count)! > 0 else { return }
            
            let playlist = self.dataprovider[indexPath.row]
            self.tableView.setEditing(false, animated: true)
            SparkFirebaseService.shared.updatePlaylistTitle(playlist, title: (textfield?.text)!, completion: { (success) in
                
            })
            
        }
        let cancelAction = UIAlertAction(title: Localization(key: Spark.CANCEL), style: .default, handler: { (action) in
            self.tableView.setEditing(false, animated: true)
        })
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        ApplicationViewController.sharedInstance.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - MiniPlayer
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PlayListTableCell
        cell.selectedCell(false)
        ApplicationViewController.sharedInstance.showAudioPlayer(dataprovider[indexPath.item], category: sectionType)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PlayListTableCell
        cell.unSelectedCell(false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         let cell = cell as! PlayListTableCell
         cell.isSelected == true ? cell.cellWithSelected() : cell.cellWithUnSelected()
    }
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height * 2 {
            if(endDraggin) {
                endDraggin = false
                loadMorePlaylist()
            }
        }
    }
    var endDraggin = false
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        endDraggin = true
    }
    
    func loadMorePlaylist(){
    
    }
    
    
    
    // MARK: - Deinitialze
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)
        segmentControl = nil
        tableView = nil
        titleLabel = nil
        dataprovider = nil
    }
    
    
    
    
}
