//
//  MiniPlayerTabelCell
//  spark
//
//  Created by Vikesh on 02/11/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView


class MiniPlayerTabelCell: BaseTableViewCell {
    
    var dataprovider: Voice! {
        didSet {
             titleLabel.text = dataprovider.title
             dataprovider.order = order
            
        }
    }
    
    var order: Int! {
        didSet {
            orderTitle.text = "\(order!)"
        }
    }
    
   
    
    override func initComponents() {
        
        clipsToBounds = false
        bgView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
         NotificationCenter.default.addObserver(self, selector: #selector(jukeboxStateChanged), name: NSNotification.Name(rawValue: kJukeBoxStateNotification), object: nil)
    }
    
    override func setupViews() {
        //contentView.addSubview(equalizer)
        contentView.addSubview(orderTitle)
        contentView.addSubview(titleLabel)
        contentView.addSubview(seperator)
    }
    
    override func setupLayouts() {
        
        _ = orderTitle.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20)
        orderTitle.widthAnchor.constraint(equalToConstant: 30).isActive = true
        orderTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
       /* _ = equalizer.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 5)
        equalizer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true*/
        
        _ = titleLabel.anchor(contentView.topAnchor, left: orderTitle.rightAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10)
        
        _ = seperator.anchor(nil, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 1)
        seperator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    
    override func configureViewFromLocalisation() {
        
    }
    
    
    override func selectedCell(_ animated: Bool = false) {
        /*seperator.isHidden = true
        if(animated){
            UIView.animate(withDuration: 0.5, animations: {
                self.cellWithSelected()
            })
            return
        }*/
        cellWithSelected()
    }
    
    override func unSelectedCell(_ animated: Bool = false) {
       /*seperator.isHidden = false
        if(animated){
            UIView.animate(withDuration: 0.5, animations: {
                self.cellWithUnSelected()
            })
            return
        }*/
        cellWithUnSelected()
    }
    
    override func cellWithSelected() {
        /*self.orderTitle.textColor = .white
        self.titleLabel.textColor = .white
        self.orderTitle.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightSemibold)
        self.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightSemibold)
        self.bgView.backgroundColor = UIColor(red: 5/255, green: 157/255, blue: 123/255, alpha: 0.7)*/
        //jukeboxState()
        
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.25
        contentView.layer.masksToBounds = false
        contentView.clipsToBounds = false
        contentView.layer.zPosition = 999
        contentView.backgroundColor = Color.selectedColor
        seperator.isHidden = true
    }
    
    override func cellWithUnSelected() {
        /*self.orderTitle.textColor = UIColor(red: 5, green: 157, blue: 123)
        self.titleLabel.textColor = UIColor(red: 5, green: 157, blue: 123)
        self.orderTitle.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightRegular)
        self.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)
        self.bgView.backgroundColor = UIColor.white.withAlphaComponent(0.3)*/
        //orderTitle.isHidden = false
        //equalizer.stopAnimating()
        contentView.layer.shadowRadius = 0.0
        contentView.layer.shadowOpacity = 0.0
        contentView.layer.zPosition = 1
        contentView.backgroundColor = UIColor.clear
        seperator.isHidden = false
    }
    
    @objc func jukeboxStateChanged(notification: NSNotification){
        //jukeboxState()
    }
    
    func jukeboxState() {
        /*if(isSelected) {
            if let jukebox = SparkAudioService.shared.jukebox {
                switch(jukebox.state){
                case .playing:
                    orderTitle.isHidden = true
                    equalizer.startAnimating()
                    break
                case .ready, .paused:
                    orderTitle.isHidden = false
                    equalizer.stopAnimating()
                    break
                default: break
                }
            }
        }*/
    }

    

    
    var orderTitle: UILabel! = {
        let lb = UILabel()
        lb.adjustsFontSizeToFitWidth = true
        lb.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.regular)
        lb.text = "0"
        lb.textAlignment = .left
        lb.textColor = UIColor(red: 5, green: 157, blue: 123)
        lb.numberOfLines = 1
        return lb
    }()
    
    var titleLabel: UILabel! = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        lb.text = "Curse you red baron"
        lb.textAlignment = .left
        lb.lineBreakMode = .byWordWrapping
        lb.textColor = UIColor(red: 5, green: 157, blue: 123)
        lb.numberOfLines = 0
        lb.backgroundColor = .clear
        return lb
    }()
    
    //LineScalePulseOutRapid
    /*var equalizer:NVActivityIndicatorView! = {
        let eq = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 35, height: 35), type: NVActivityIndicatorType.lineScalePulseOutRapid, color: UIColor(red: 5, green: 157, blue: 123), padding: 5)
        eq.isHidden = true
        return eq
    }()*/
 
    
    var seperator: UIView! = {
        let v = UIView(frame: .zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red: 181, green: 223, blue: 237)
        return v
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kJukeBoxStateNotification), object: nil)
    }
    
}
