//
//  AlarmListsViewController.swift
//  spark
//
//  Created by Vikesh on 07/02/2017.
//  Copyright © 2017 Vikesh. All rights reserved.
//

import UIKit
import CoreData

class AlarmListsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var onClose: ((_ bool: Bool)->())? = nil
    var tap: UITapGestureRecognizer! = nil
    
    fileprivate var dataprovider: [SparkAlarm]! {
        didSet {
            
        }
    }
    
    let closeBtn: UIButton! = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "closeButton")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.setImage(UIImage(named: "closeButton")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        b.tintColor = UIColor.white
        return b
    }()
    
    var tableView: UITableView! = {
        let tb = UITableView(frame: .zero, style: UITableViewStyle.plain)
        tb.backgroundColor = UIColor(red: 230, green: 230, blue: 230)
        tb.layer.cornerRadius = 15.0
        return tb
    }()
    
    var editButton: UIButton! = {
        var btn = UIButton()
        btn.setTitle(Localization(key: Spark.EDIT_ALARM), for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        return btn
    }()
    
    var backView: BaseUIView! = {
        let v = BaseUIView()
        v.alpha = 0
        return v
    }()
    
    var alarmTitleLabel: UILabel! = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.regular)
        lb.textAlignment = .center
        lb.text = Localization(key: Spark.VIEW_ALARM_LIST)
        lb.textColor = UIColor.orange
        lb.numberOfLines = 1
        return lb
    }()
    
    override func didLoad() {
        let context = SparkDataService.shared.context
        let request: NSFetchRequest<SparkAlarm> = SparkAlarm.fetchRequest()
        do {
            try dataprovider = context.fetch(request)
            self.forceInit()
            self.tableView.reloadData()
            
        } catch {
            print("error fetching array")
        }
    }
    
    override func initComponents() {
        tap = UITapGestureRecognizer(target: self, action: #selector(onTapAction))
        backView.addGestureRecognizer(tap)
        tableView.register(AlarmTableCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        closeBtn.addTarget(self, action: #selector(onTapAction), for: .touchUpInside)
    }
    
    @objc func onTapAction(){
        if let onClose = onClose {
            onClose(true)
        }
    }
    
    override func setupViews() {
        view.backgroundColor = UIColor.clear
        view.addSubview(backView)
        view.addSubview(alarmTitleLabel)
        view.addSubview(tableView)
        view.addSubview(closeBtn)
        view.addSubview(editButton)
        
    }
    
    override func setupLayouts() {
        
        _ = backView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        _ = alarmTitleLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 25, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 22)
        
        _ = tableView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 5, rightConstant: 5, widthConstant: view.bounds.size.width, heightConstant: view.bounds.size.height - 120)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.backView.alpha = 1
            self.backView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }, completion: nil)
        
        _ = editButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 56, leftConstant: 0, bottomConstant: 0, rightConstant: 25, widthConstant: 0, heightConstant: 22)
        
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 56).isActive = true
        closeBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 27).isActive = true
        closeBtn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        closeBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard dataprovider != nil else { return 0 }
        return dataprovider.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AlarmTableCell
        cell.dataprovider = dataprovider[indexPath.row]
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

/**
 sample display
 08:45am
 The Jack of all Trade
 with the voice of Erwin
 */

class AlarmTableCell: BaseTableViewCell {
    
    var dataprovider: SparkAlarm! {
        didSet {
            titleLabel.text = " \(String(describing: dataprovider.date)) lorem lorem lorem lorem lorel"
            detailLabel.text = "Helo world this is mucus"
        }
    }
    
    var timeLabel: UILabel! = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.thin)
        lb.text = "08:45"
        lb.textAlignment = .left
        lb.lineBreakMode = .byWordWrapping
        lb.textColor = UIColor(red: 168, green: 168, blue: 168)
        lb.numberOfLines = 0
        lb.backgroundColor = .clear
        return lb
    }()
    
    var symbols: UILabel! = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
        lb.text = "am"
        lb.textAlignment = .left
        lb.textColor = UIColor(red: 168, green: 168, blue: 168)
        lb.backgroundColor = .clear
        return lb
    }()
    
    var titleLabel: UILabel! = {
        let lb = UILabel()
        //lb.adjustsFontSizeToFitWidth = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = Localization(key: Spark.IN_PROGRESS)
        lb.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        lb.textAlignment = .left
        lb.lineBreakMode = .byWordWrapping
        lb.textColor = UIColor(red: 5, green: 157, blue: 123)
        lb.numberOfLines = 0
        lb.backgroundColor = .clear
        return lb
    }()
    
    var detailLabel: UILabel! = {
        let lb = UILabel()
        //lb.adjustsFontSizeToFitWidth = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = Localization(key: Spark.IN_PROGRESS)
        lb.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        lb.textAlignment = .left
        lb.lineBreakMode = .byWordWrapping
        lb.textColor = UIColor.gray
        lb.numberOfLines = 1
        lb.backgroundColor = .clear
        return lb
    }()
    
    override func setupViews() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(symbols)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
    }
    
    override func setupLayouts() {
        _ = timeLabel.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: titleLabel.topAnchor, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 60)
        
        _ = symbols.anchor(nil, left: timeLabel.rightAnchor, bottom: timeLabel.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        _ = titleLabel.anchor(timeLabel.bottomAnchor, left: timeLabel.leftAnchor, bottom: detailLabel.topAnchor, right: contentView.rightAnchor, topConstant: -10, leftConstant: 0, bottomConstant: 5, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        _ = detailLabel.anchor(titleLabel.bottomAnchor, left: timeLabel.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 20)
    }
}


