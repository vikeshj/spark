//
//  AlarmViewController.swift
//  spark
//
//  Created by Vikesh on 29/11/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class AlarmViewController: BaseViewController {
    
    // List VC
    var listVc: AlarmListsViewController! = nil
    var onDismiss: (()->Void)? = nil
    
    var alarm: Alarm! {
        didSet {
            //print(alarm)
            //let d = Date().millisecondsSince1970
            //print(Date.init(milliseconds: d).format)
            print(Date().format("2017-08-09 20:15"))
        }
    }
    
    let closeBtn: UIButton! = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "closeButton")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.setImage(UIImage(named: "closeButton")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        b.tintColor = UIColor.white//UIColor(red: 5, green: 28, blue: 48)
        return b
    }()
    
    let backView: BaseUIView = {
        let v = BaseUIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return v
    }()
    
    let segment: UISegmentedControl! = {
        let sc = UISegmentedControl(items:[Localization(key: Spark.AM), Localization(key: Spark.PM)])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = Color.selectedColor//UIColor(red: 0, green: 185, blue: 154)
        sc.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red: 0, green: 5, blue: 154)], for: UIControlState.selected)
        sc.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: Color.selectedColor], for: UIControlState.normal)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let timeIndicator: UIImageView! = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "time_indicators").withRenderingMode(.alwaysTemplate))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor.white
        iv.alpha = 0.3
        return iv
    }()
    
    let amPmLabel: UILabel! = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        lb.text = "AM"
        return lb
    }()
    
    let hourLabel: UILabel! = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 44, weight: UIFont.Weight.regular)
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        lb.text = "07"
        return lb
    }()
    
    let timeSeperatorLabel: UILabel! = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.regular)
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        lb.text = ":"
        return lb
    }()
    
    let minutesLabel: UILabel! = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 44, weight: UIFont.Weight.regular)
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        lb.text = "58"
        return lb
    }()
    
    var timeStack: UIStackView! = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .horizontal
        s.alignment = .fill
        return s
    }()
    
    let daysLabel: UILabel! = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: FontSize.shared.textSize, weight: UIFont.Weight.regular)
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        return lb
    }()
    
    let logo: UIImageView! = {
        let iv = UIImageView(image:#imageLiteral(resourceName: "homeIcon"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.alpha = 0.13
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let minutesCircularSlider: CircularSlider! = {
        let cs = CircularSlider()
        cs.backgroundColor = .clear
        cs.minimumValue = 0
        cs.maximumValue = 60
        cs.endPointValue = 20
        cs.diskFillColor = .clear
        cs.diskColor = .clear
        cs.trackFillColor = Color.selectedColor//UIColor(red: 5, green: 28, blue: 48)
        cs.trackColor = UIColor.white.withAlphaComponent(0.3)
        cs.lineWidth = 6
        cs.thumbRadius = 6
        cs.endThumbTintColor = UIColor.white//UIColor(red: 5, green: 28, blue: 48)
        cs.endThumbStrokeColor = UIColor.white//UIColor(red: 5, green: 28, blue: 48)
        cs.endThumbStrokeHighlightedColor = Color.selectedColor//UIColor(red: 5, green: 28, blue: 48)
        cs.translatesAutoresizingMaskIntoConstraints = false
        return cs
    }()
    
    let hourCircularSlider: CircularSlider! = {
        let cs = CircularSlider()
        cs.backgroundColor = .clear
        cs.minimumValue = 0
        cs.maximumValue = 12
        cs.endPointValue = 6
        cs.diskFillColor = .clear
        cs.diskColor = .clear
        cs.trackFillColor = Color.selectedColor//UIColor(red: 5, green: 28, blue: 48)
        cs.trackColor = UIColor.white.withAlphaComponent(0.3)
        cs.lineWidth = 8
        cs.thumbRadius = 6
        cs.endThumbTintColor = UIColor.white//UIColor(red: 5, green: 28, blue: 48)
        cs.endThumbStrokeColor = UIColor.white//UIColor(red: 5, green: 28, blue: 48)
        cs.endThumbStrokeHighlightedColor = Color.selectedColor//UIColor(red: 5, green: 28, blue: 48)
        cs.translatesAutoresizingMaskIntoConstraints = false
        return cs
    }()
    
    var titleLabel: UILabel! = {
        let lb = UILabel()
        lb.adjustsFontSizeToFitWidth = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = Localization(key: Spark.COMING_SOON)
        lb.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        lb.textAlignment = .center
        lb.textColor = UIColor.white
        lb.isHidden = true
        return lb
    }()
    
    var stack: UIStackView! = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.alignment = UIStackViewAlignment.fill
        return s
    }()
    
    var alamButton: UIButton = {
        var btn = UIButton()
        btn.setTitle(Localization(key: Spark.SET_ALARM), for: .normal)
        btn.setTitleColor(UIColor(red: 51, green: 105, blue: 30), for: .normal)
        btn.backgroundColor = Color.selectedColor
        btn.layer.cornerRadius = 5.0
        return btn
    }()
    
    var alarmListButton:UIButton = {
        var btn = UIButton()
        btn.setTitle(Localization(key: Spark.VIEW_ALARM_LIST), for: .normal)
        btn.backgroundColor = UIColor(red: 92, green: 107, blue: 192)
        btn.setTitleColor(UIColor(red: 232, green: 234, blue: 246), for: .normal)
        btn.layer.cornerRadius = 5.0
        return btn
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func initComponents() {
        createVibrancyWithblur()
        closeBtn.addTarget(self, action: #selector(close) , for: .touchUpInside)
        hourCircularSlider.addTarget(self, action: #selector(updateHours), for: .valueChanged)
        hourCircularSlider.addTarget(self, action: #selector(adjustHours), for: .editingDidEnd)
        
        minutesCircularSlider.addTarget(self, action: #selector(updateMinutes), for: .valueChanged)
        minutesCircularSlider.addTarget(self, action: #selector(adjustMinutes), for: .editingDidEnd)
        
        segment.addTarget(self, action: #selector(ampmSelected(_:)), for: .valueChanged)
        ampmSelected(segment)
        
        alamButton.addTarget(self, action: #selector(addAlarm), for: .touchUpInside)
        alarmListButton.addTarget(self, action: #selector(showList), for: .touchUpInside)
    }
    
    
    override func setupViews() {
        view.addSubview(backView)
        view.addSubview(bgImageView)
        view.addSubview(blurView)
        view.sendSubview(toBack: bgImageView)
        view.sendSubview(toBack: backView)
        view.addSubview(closeBtn)
        view.addSubview(segment)
        view.addSubview(timeIndicator)
        view.addSubview(logo)
        view.addSubview(minutesCircularSlider)
        view.addSubview(hourCircularSlider)
        view.addSubview(titleLabel)
        view.addSubview(stack)
        view.addSubview(alamButton)
        view.addSubview(alarmListButton)
        
        timeStack.insertArrangedSubview(hourLabel, at: 0)
        timeStack.insertArrangedSubview(timeSeperatorLabel, at: 1)
        timeStack.insertArrangedSubview(minutesLabel, at: 2)
        
        stack.insertArrangedSubview(amPmLabel, at: 0)
        stack.insertArrangedSubview(timeStack, at: 1)
        
        //view.addSubview(collectionView)
        
        setCurrentTime()
        
    }
    
    override func setupLayouts() {
        
        _ = blurView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        _ = bgImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        _ = backView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        backView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        closeBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        closeBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        segment.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        segment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segment.widthAnchor.constraint(equalToConstant: 200).isActive = true
        segment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //timeIndicator.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 40).isActive = true
        timeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        timeIndicator.widthAnchor.constraint(equalToConstant: 300).isActive = true
        timeIndicator.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        logo.centerXAnchor.constraint(equalTo: timeIndicator.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: timeIndicator.centerYAnchor).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 211).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 211).isActive = true
        
        
        minutesCircularSlider.centerXAnchor.constraint(equalTo: timeIndicator.centerXAnchor).isActive = true
        minutesCircularSlider.centerYAnchor.constraint(equalTo: timeIndicator.centerYAnchor).isActive = true
        minutesCircularSlider.widthAnchor.constraint(equalToConstant: 260).isActive = true
        minutesCircularSlider.heightAnchor.constraint(equalToConstant: 260).isActive = true
        
        
        hourCircularSlider.centerXAnchor.constraint(equalTo: timeIndicator.centerXAnchor).isActive = true
        hourCircularSlider.centerYAnchor.constraint(equalTo: timeIndicator.centerYAnchor).isActive = true
        hourCircularSlider.widthAnchor.constraint(equalToConstant: 211).isActive = true
        hourCircularSlider.heightAnchor.constraint(equalToConstant: 211).isActive = true
        
        stack.centerXAnchor.constraint(equalTo: timeIndicator.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: timeIndicator.centerYAnchor).isActive = true
        
        _ = alamButton.anchor(nil, left: view.leftAnchor, bottom: alarmListButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 15, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        _ = alarmListButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        _  = titleLabel.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        //_ = collectionView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 40, rightConstant: 10, widthConstant: 0, heightConstant: 70)
        
    }
    
    @objc func close(){
        if let removed = onDismiss {
            removed()
        }
    }
    
    fileprivate var blurEffect: UIBlurEffect!
    fileprivate var blurView: UIVisualEffectView!
    fileprivate var bgImageView: UIImageView!
    
    func createVibrancyWithblur(){
        bgImageView = UIImageView()
        bgImageView.image = #imageLiteral(resourceName: "mainBackground")
        bgImageView.contentMode = .scaleToFill
        blurEffect = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
    }
    
    @objc func updateHours() {
        var selectedHour = Int(hourCircularSlider.endPointValue)
        // TODO: use date formatter
        selectedHour = (selectedHour == 0 ? 12 : selectedHour)
        hourLabel.text = String(format: "%02d", selectedHour)
    }
    
    @objc func adjustHours() {
        let selectedHour = round(hourCircularSlider.endPointValue)
        hourCircularSlider.endPointValue = selectedHour
        updateHours()
    }
    
    @objc func updateMinutes() {
        var selectedMinute = Int(minutesCircularSlider.endPointValue)
        // TODO: use date formatter
        selectedMinute = (selectedMinute == 60 ? 0 : selectedMinute)
        minutesLabel.text = String(format: "%02d", selectedMinute)
    }
    
    @objc func adjustMinutes() {
        let selectedMinute = round(minutesCircularSlider.endPointValue)
        minutesCircularSlider.endPointValue = selectedMinute
        updateMinutes()
    }
    
    @objc func ampmSelected(_ sender: UISegmentedControl){
        amPmLabel.text =  sender.selectedSegmentIndex == 0 ? Localization(key: Spark.AM) : Localization(key: Spark.PM)
    }
    
    // MARK: - Now (set the time to the current hour / minutes)
    func setCurrentTime(){
        
        let date = SparkAlarmService.shared.current
        
        if let h = date.hour {
            let hour = h > 12 ? h - 12 : h
            hourCircularSlider.endPointValue = CGFloat(hour)
            updateHours()
            segment.selectedSegmentIndex = h > 12 ? 1 : 0
            ampmSelected(segment)
        }
        minutesCircularSlider.endPointValue = CGFloat(date.minute!)
        updateMinutes()
        
    }
    
    @objc func addAlarm(){
        
    }
    
    @objc func showList(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.view.alpha = 0.1
        }) { (bool) in }
        
        self.launch()
    }
    
    func launch(){
        listVc = AlarmListsViewController()
        listVc.modalPresentationStyle = .overCurrentContext
        listVc.onClose = { bool in
            if bool {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.view.transform = CGAffineTransform.identity
                    self.view.alpha = 1.0
                }, completion: nil)
                self.listVc.dismiss(animated: true, completion: {
                    self.listVc = nil
                })
            }
        }
        
        self.navigationController?.present(listVc, animated: true, completion: {
            self.navigationController?.modalPresentationStyle = .overCurrentContext
        })
        
    }

}
