//
//  MiniPlayerModalViewControler.swift
//  spark
//  drag n drop https://www.freshconsulting.com/create-drag-and-drop-uitableview-swift/
//  Created by Vikesh on 01/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

protocol AmbientDelegate: class {
    func didReceivePlayerState(state: String)
}


class MiniPlayerContentViewControler: BaseViewController, UITableViewDelegate, UITableViewDataSource, AudioPlayerDelegate {
    
    static var shared: MiniPlayerContentViewControler = MiniPlayerContentViewControler()
    
    
    var mediaPlayer: AudioPlayer {
        get {
            guard let mp = SparkAudioService.shared.mediaPlayer else { return AudioPlayer() }
            return mp
        }
    }
    
    var dataprovider: FirePlaylist! {
        didSet {
            guard dataprovider != nil else { return }
            playlistTitleLabel.text = dataprovider.title
            editIcon.isHidden = category == .defaultPlaylist ? true : false
            SwiftSpinner.show(Localization(key: Spark.LOADING_PLAYLIST), animated: true)
            self.resetUI()
           
            DispatchQueue.main.async {
                SparkAudioService.shared.letsJumpAround(self.dataprovider)
                self.mediaPlayer.stop()
                if let sound = self.user.backgroundSoundPath {
                    SparkAudioService.shared.prepareBackgroundSound(sound)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    var category: Category = .userPlaylist
    var selected: IndexPath!
    var closeButtonActionHandler : (() -> Void)?
    
    
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
    
    override func initComponents() {
        
        SparkAudioService.shared.miniPlayer = self
       
        
        createVibrancyWithblur()
        tableView.register(MiniPlayerTabelCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 65
        tableView.rowHeight = UITableViewAutomaticDimension
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        //longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
        //tableView.addGestureRecognizer(longPress)
        
        modifiedButton.isHidden = true
        
        shuffleButton.addTarget(self, action: #selector(shuffleTracks(_:)), for: .touchUpInside)
        playStopButton.addTarget(self, action: #selector(playJukebox), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(playNext), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(playBack), for: .touchUpInside)
        loopButton.addTarget(self, action: #selector(repeatTracks), for: .touchUpInside)
        //progressSlider.addTarget(self, action: #selector(progressSliderValueChanged), for: .valueChanged)
        
        editIcon.isUserInteractionEnabled = true
        editIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onEditingMode)))
        
        alarmIcon.isUserInteractionEnabled = true
        alarmIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAlarmControls)))
    }
    
    override func setupViews() {
        view.addSubview(bgImageView)
        view.addSubview(blurView)
        view.sendSubview(toBack: bgImageView)
        view.addSubview(titleLabel)
        view.addSubview(modifiedButton)
        view.addSubview(playlistTitleLabel)
        view.addSubview(playerView)
        view.addSubview(tableView)
        view.addSubview(infoView)
        view.addSubview(closeBtn)
        
        infoView.addSubview(editIcon)
        infoView.addSubview(alarmIcon)
        
        //controls
        playerView.addSubview(playStopButton)
        playerView.addSubview(backButton)
        playerView.addSubview(nextButton)
        playerView.addSubview(shuffleButton)
        playerView.addSubview(loopButton)
        playerView.addSubview(progressSlider)
        playerView.addSubview(minLabel)
        playerView.addSubview(maxLabel)
    }
    
    override func setupLayouts() {
        
        
        _ = blurView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        _ = bgImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        
        _ = titleLabel?.anchor(view.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 25)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        _ = modifiedButton?.anchor(titleLabel.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        _ = playlistTitleLabel?.anchor(closeBtn.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        
        _ = playerView.anchor(playlistTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        playerView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        _ = infoView.anchor(playerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        infoView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        _ = tableView.anchor(infoView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        //infoview components
        editIcon.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 5).isActive = true
        editIcon.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -5).isActive = true
        editIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        editIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        _ = alarmIcon.anchor(infoView.topAnchor, left: nil, bottom: nil, right: editIcon.leftAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 30, heightConstant: 30)[1]
        
        
        
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        closeBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        closeBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        //controls
        playStopButton.centerXAnchor.constraint(equalTo: playerView.centerXAnchor).isActive = true
        playStopButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        playStopButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        playStopButton.topAnchor.constraint(equalTo: playerView.topAnchor, constant: 20).isActive = true
        
        
        backButton.centerXAnchor.constraint(equalTo: playStopButton.centerXAnchor, constant: -60).isActive = true
        backButton.centerYAnchor.constraint(equalTo: playStopButton.centerYAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true //20
        backButton.heightAnchor.constraint(equalToConstant: 28).isActive = true //14
        
        nextButton.centerXAnchor.constraint(equalTo: playStopButton.centerXAnchor, constant: 60).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: playStopButton.centerYAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        shuffleButton.centerXAnchor.constraint(equalTo: playStopButton.centerXAnchor, constant: -130).isActive = true
        shuffleButton.centerYAnchor.constraint(equalTo: playStopButton.centerYAnchor).isActive = true
        shuffleButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        shuffleButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        loopButton.centerXAnchor.constraint(equalTo: playStopButton.centerXAnchor, constant: 130).isActive = true
        loopButton.centerYAnchor.constraint(equalTo: playStopButton.centerYAnchor).isActive = true
        loopButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        loopButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        progressSlider.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -10).isActive = true
        progressSlider.centerXAnchor.constraint(equalTo: playerView.centerXAnchor).isActive = true
        progressSlider.widthAnchor.constraint(equalToConstant: (view.bounds.width - 120)).isActive = true
        progressSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        minLabel.bottomAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 0).isActive = true
        minLabel.rightAnchor.constraint(equalTo: progressSlider.leftAnchor, constant: -6).isActive = true
        minLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        minLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        maxLabel.bottomAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 0).isActive = true
        maxLabel.leftAnchor.constraint(equalTo: progressSlider.rightAnchor, constant: 10).isActive = true
        maxLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        maxLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    // MARK: - Table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard dataprovider != nil else { return 0 }
        if let count = dataprovider.voices?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MiniPlayerTabelCell
        cell.order = indexPath.row + 1
        var voice = dataprovider.voices?[indexPath.item]
        voice?.playlistId = dataprovider.id
        cell.dataprovider = voice
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mediaPlayer.play(items: SparkAudioService.shared.audioItems, startAtIndex: indexPath.row)
        let cell = tableView.cellForRow(at: indexPath) as? MiniPlayerTabelCell
        selected = indexPath
        cell?.selectedCell(true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? MiniPlayerTabelCell
        cell?.unSelectedCell(true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //self.dataprovider.voices?.swap(sourceIndexPath.row, destinationIndexPath.row)
       
        let voice = dataprovider.voices?[sourceIndexPath.row]
        dataprovider.voices?.remove(at: sourceIndexPath.row)
        dataprovider.voices?.insert(voice!, at: destinationIndexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if(category == .defaultPlaylist) { return [] }
        
        let deleteAction = BaseUITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: Localization(key: Spark.DELETE), handler: { (action, indexpath) in
            
            if let trackId = self.dataprovider.voices?[indexPath.row].fkey
            {
                let playlistId = self.dataprovider.id
                SparkFirebaseService.shared.removeVoiceTrack(playlistId, trackId: trackId, completion: { (bool) in
                    self.dataprovider.voices?.remove(at: indexPath.row)
                })
            }
        })
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! MiniPlayerTabelCell
        if(cell.isSelected){
            cell.selectedCell()
        }else {
            cell.unSelectedCell()
        }
    }
    
    
    @objc func close(){
        if tableView.isEditing == true { tableView.setEditing(false, animated: false) }
        if let isClosing = closeButtonActionHandler {
            isClosing()
        }
    }
    
    // MARK: - Alarm
    @objc func openAlarmControls(){
        ApplicationViewController.sharedInstance.present(AlarmNavigationController(), animated: true, completion: {})
    }
    
    // MARK: - Jukebox
    var hasAlreadyPlayed = false
    var isfirst = true
    var isRepeated: Bool = true
    var isShuffling: Bool = false
    var random = [Int]()
    
    @objc func playBack(){ mediaPlayer.previous() }
    @objc func playNext() { mediaPlayer.next() }
    @objc func repeatTracks () -> Bool {
        isRepeated = !isRepeated
        loopButton.tintColor = isRepeated == true ? Color.selectedColor : Color.normalColor
        mediaPlayer.mode = isRepeated == true ? .repeatAll : .normal
        
        isShuffling = false
        shuffleButton.tintColor = Color.normalColor
        
        
        return isRepeated
    }
    
     @objc func shuffleTracks(_ sender: UIButton){
        isShuffling = !isShuffling
        shuffleButton.tintColor = isShuffling == true ? Color.selectedColor : Color.normalColor
        mediaPlayer.mode = isShuffling == true ? .shuffle : .normal
        
        isRepeated = false
        loopButton.tintColor = Color.normalColor
    }
    
     @objc func playJukebox() {
        switch mediaPlayer.state {
            case .playing :
                mediaPlayer.pause()
                break
            case .paused :
                mediaPlayer.resume()
                break
            case .stopped:
                mediaPlayer.play(items: SparkAudioService.shared.audioItems, startAtIndex: 0)
                break;
            default:
                mediaPlayer.stop()
                break
            }
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateProgressionTo time: TimeInterval, percentageRead: Float) {
        if let progress = audioPlayer.currentItemProgression , let duration = audioPlayer.currentItemDuration {
            let value = Float(progress / duration)
            progressSlider.value = value
            populateLabelWithTime(minLabel, time: progress)
            populateLabelWithTime(maxLabel, time: duration)
        }
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, to state: AudioPlayerState) {
        switch state {
            case .playing:
                playStopButton.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysTemplate), for: .normal)
                playStopButton.tintColor = Color.selectedColor
                break
            case .paused:
                playStopButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysTemplate), for: .normal)
                break
            case .stopped, .waitingForConnection:
                playStopButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            break
            default: break
        }
    }
    
    
    
    func populateLabelWithTime(_ label : UILabel, time: Double) {
        let minutes = Int(time / 60)
        let seconds = Int(time) - minutes * 60
        
        label.text = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
    
     @objc func onEditingMode(){
        if(category == .defaultPlaylist) { return }
        let mode = !tableView.isEditing
        tableView.setEditing(mode, animated: true)
        
        if(mode && mediaPlayer.state == .playing) {
            mediaPlayer.pause()
        }
        
        guard selected != nil else { return }
        let cell =  tableView.cellForRow(at: selected) as! MiniPlayerTabelCell
        cell.cellWithUnSelected()
    }
    
    
    // MARK :- Reset UI
    func resetUI() {
        minLabel.text = "00:00"
        maxLabel.text = "00:00"
        progressSlider.value = 0
        hasAlreadyPlayed = false
        isfirst = true
        isRepeated = true
        isShuffling = false
        playStopButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        shuffleButton.setImage(#imageLiteral(resourceName: "shuffle").withRenderingMode(.alwaysTemplate), for: .normal)
        shuffleButton.tintColor = Color.normalColor
        loopButton.setImage(#imageLiteral(resourceName: "loop").withRenderingMode(.alwaysTemplate), for: .normal)
        loopButton.tintColor = Color.selectedColor
    }
    
    // MARK : - Components
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
    
    
    
    var longPress: UILongPressGestureRecognizer! = nil
    
    
    var modifiedButton: UIButton! = {
        let btn = UIButton()
        btn.setTitle("Modified", for: .normal)
        return btn
    }()
    
    let playlistTitleLabel: MarqueeLabel! = {
        let lb = MarqueeLabel(frame: .zero)
        lb.translatesAutoresizingMaskIntoConstraints = true
        lb.type = .continuous
        //lb.animationCurve = .easeInOut
        lb.speed = .duration(24.0)
        lb.leadingBuffer = 10
        lb.trailingBuffer = 10
        lb.fadeLength = 30.0
        lb.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.thin)
        lb.textColor = .white
        return lb
    }()
    
    /*let playlistTitleLabel: UILabel! = {
        let lb = UILabel()
        //lb.adjustsFontSizeToFitWidth = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightThin)
        lb.textAlignment = .left
        lb.textColor = UIColor.white
        //lb.lineBreakMode = .byWordWrapping
        lb.numberOfLines = 1
        return lb
    }()*/

    
    let closeBtn: UIButton! = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "closeButton")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.setImage(UIImage(named: "closeButton")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        b.tintColor = Color.normalColor
        return b
    }()
    
    let playerView: BaseUIView! = {
        let v = BaseUIView()
        return v
    }()
    
    let infoView: BaseUIView! = {
        let v = BaseUIView(frame: .zero)
        v.backgroundColor = UIColor.white
        return v
    }()
    
    var alarmIcon: UIImageView! = {
        let i = UIImageView(image: #imageLiteral(resourceName: "alarm").withRenderingMode(.alwaysTemplate))
        i.contentMode = .scaleAspectFit
        i.tintColor = UIColor(red: 5, green: 157, blue: 123)
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    var editIcon: UIImageView! = {
        let i = UIImageView(image: #imageLiteral(resourceName: "edit").withRenderingMode(.alwaysTemplate))
        i.contentMode = .scaleAspectFit
        i.tintColor = UIColor(red: 5, green: 157, blue: 123)
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    var tableView: UITableView! = {
        let tb = UITableView(frame: .zero, style: UITableViewStyle.plain)
        tb.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return tb
    }()
    
    // MARK: - controls
    var playStopButton: UIButton! = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysTemplate), for: .normal)
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
        b.tintColor = Color.selectedColor
        return b
    }()
    
    var progressSlider: UISlider! = {
        let s = UISlider()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.setThumbImage(#imageLiteral(resourceName: "thumb").withRenderingMode(.alwaysTemplate), for: .normal)
        s.tintColor = Color.selectedColor
        s.maximumTrackTintColor = UIColor.white
        return s
    }()
    
    
    var minLabel: UILabel! = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        lb.textAlignment = .left
        lb.text = "00:00"
        lb.textColor = UIColor.white
        lb.numberOfLines = 1
        return lb
    }()
    
    
    var maxLabel: UILabel! = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        lb.textAlignment = .left
        lb.text = "00:00"
        lb.textColor = UIColor.white
        lb.numberOfLines = 1
        return lb
    }()
    
    
    
    
    deinit {
        playStopButton = nil
    }
    
    
}


public extension Array {
    /*mutating func swap(_ ind1: Int, _ ind2: Int){
        var temp: Element
        temp = self[ind1]
        self[ind1] = self[ind2]
        self[ind2] = temp
    }*/
}


/*public extension Collection where Index == Int {
    
    /**
     Picks a random element of the collection.
     
     - returns: A random element of the collection.
     */
    func randomElement() -> Iterator.Element? {
        return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(endIndex)))]
    }
    
}*/

private extension Array {
    var randomElement: Element {
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}


struct Snapshot {
    static var cell : UIView? = nil
}
struct Path {
    static var sourceIndex : IndexPath? = nil
}
