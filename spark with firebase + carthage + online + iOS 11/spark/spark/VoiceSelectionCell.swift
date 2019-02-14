//
//  VoiceSelectionCell.swift
//  spark
//  https://www.raywenderlich.com/136161/uicollectionview-tutorial-reusable-views-selection-reordering
//  Created by Vikesh on 14/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceSelectionCell: BaseCollectionViewCell {
    
    var dataprovider: FirePeople! {
        didSet {
            label.text = dataprovider.name
            backgroundColor = dataprovider.isSelected  == true ?  Color.selectedColor : genderColor
         }
    }
    
    var genderColor: UIColor {
        get {
            return dataprovider.gender == "male" ? Color.maleColor : Color.femaleColor
        }
    }
    
    var index: Int?
    
    
    var svgPlayButton: SVGPlayButton! = {
        let svg = SVGPlayButton()
        svg.playColor = .white
        svg.pauseColor = .white
        svg.translatesAutoresizingMaskIntoConstraints = false
        return svg
    }()
    
    var label: UILabel! = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: FontSize.shared.textSize, weight: UIFont.Weight.regular)
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        return lb
    }()
    
    var svgRadioButton: SVGRadioButton! = {
        let svg = SVGRadioButton()
        svg.isSelected = false
        svg.translatesAutoresizingMaskIntoConstraints = false
        return svg
    }()
    
    override var isSelected: Bool {
        didSet {
            guard dataprovider != nil else { return }
            isSelected == true ? select() : deselect()
            dataprovider.isSelected = isSelected
            setNeedsDisplay()
            layoutIfNeeded()
        }
    }
    
    override func initComponents() {
        svgPlayButton.willPlay = willPlay
        svgPlayButton.willPause = willPause
    }
    
    
    override func setupViews() {
        addSubview(svgPlayButton)
        addSubview(label)
        addSubview(svgRadioButton)
        
    }
    
    override func setupLayouts() {
        
        svgPlayButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        svgPlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        svgPlayButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        svgPlayButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        label.leftAnchor.constraint(equalTo: svgPlayButton.rightAnchor, constant: 20).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.sizeToFit()
        
        svgRadioButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        svgRadioButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        svgRadioButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        svgRadioButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func willPlay() {
       
        var soundName = ""
        
        if let locale = user.locale {
            if let eV = dataprovider.sampleVoice.en, let fV = dataprovider.sampleVoice.fr {
                soundName = locale == SparkLocale.english.description ? eV : fV
            }
        }
        
        guard soundName != "" else { return }
       
        
        let folder = "samples/\(dataprovider.id)/"
        let soundPath = "\(folder)/\(soundName)"
        let storage = SparkDataService.shared.fireabaseStorageNode(soundPath)
        
        //https://firebase.google.com/docs/storage/ios/download-files#manage_downloads
        //http://stackoverflow.com/questions/1605846/avaudioplayer-with-external-url-to-m4p
        //http://stackoverflow.com/questions/28219848/download-file-in-swift
        //http://stackoverflow.com/a/27643660
        //https://iosdevcenters.blogspot.com/2016/04/save-and-get-image-from-document.html -- save me

        storage.downloadURL(completion: { (url, error) in
            if error != nil {
                self.svgPlayButton.playing = false
                return
            }
            if let url = url {
                DispatchUtils.delay(1, closure: { [weak self] in
                    SparkAudioService.downloadM4aFiles(url, subDirectory: folder, completion: { (path) in
                        SparkAudioService.shared.playMonoSound(path, completion: { (bool) in
                            if let this = self {
                                if(this.svgPlayButton.playing) { this.svgPlayButton.playing = false }
                            }
                        })
                    })
                })
            }
        })
    }
    
    func willPause() {
        SparkAudioService.shared.audioPlayer.fadeOut(1.0)
        if(svgPlayButton.playing){
           svgPlayButton.playing = false
        }
    }
    
    override func select() {
        svgRadioButton.isSelected = true
        backgroundColor = Color.selectedColor
        ///store the user chosen voice id
        guard dataprovider != nil else {
            return
        }
        
        //if let id = dataprovider.id {
            user.peopleId = dataprovider.id
            user.peopleName =  dataprovider.name
            user.peopleIndex = index
        //}
        
    }
    
    override func deselect() {
        svgRadioButton.isSelected = false
        backgroundColor = self.genderColor
    }
    
    deinit {
        label = nil
        dataprovider = nil
    }
}
