//
//  Login.swift
//  spark
//
//  Created by Vikesh JOYPAUL on 20/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit
//import Firebase

class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    
    var completion: ((_ animate:Bool) -> ())!
    var logo: UIImageView!
    
    var inputContainerView: BaseUIView! = {
        let v = BaseUIView()
        v.layer.cornerRadius = 5.0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var inputContainerViewTopAnchor: NSLayoutConstraint?
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextfieldHeightAnchor: NSLayoutConstraint?
    var verifiedPasswordHeightAnchor: NSLayoutConstraint?
    
    var segmentControl: UISegmentedControl! = {
        let sc = UISegmentedControl(items:[Localization(key: Spark.LOGIN_TITLE), Localization(key: Spark.REGISTER_TITLE)])
        sc.tintColor = Color.selectedColor
        sc.selectedSegmentIndex = 0
        sc.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: UIControlState.selected)
        sc.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: UIControlState.normal)
        return sc
    }()
    
    var nameTextField: UITextField! = {
        let tf = UITextField()
        tf.placeholder = Localization(key: Spark.NAME_PLACEHOLDER_TITLE)
        tf.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var nameLineSeperatorView: UIView! = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var emailTextField: UITextField! = {
        let tf = UITextField()
        tf.placeholder = Localization(key: Spark.EMAIL_PLACEHOLDER_TITLE)
        tf.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    var passwordTextField: UITextField! = {
        let tf = UITextField()
        tf.placeholder = Localization(key: Spark.PASSWORD_PLACEHOLDER_TITLE)
        tf.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .alphabet
        return tf
    }()
    
    var verifiedPasswordTextField: UITextField! = {
        let tf = UITextField()
        tf.placeholder = Localization(key: Spark.VERIFIED_PASSWORD_PLACEHOLDER_TITLE)
        tf.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .alphabet
        return tf
    }()
    
    var emailLineSeperatorView: UIView! = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var passwordSeperatorView: UIView! = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var submitButton: UIButton! = {
        let btn = UIButton(type: UIButtonType.system)
        btn.backgroundColor = UIColor(red: 200, green: 247, blue: 239).withAlphaComponent(0.8)
        btn.setTitle(Localization(key: Spark.LOGIN_TITLE), for: .normal)
        btn.setTitleColor(UIColor(red: 20, green:157 , blue:131), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    override func initComponents() {
        logo = createImage(name: "logoWithGreenSun.png", scale: .scaleAspectFit)
        inputContainerView.backgroundColor = UIColor.white
        submitButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        segmentControl.addTarget(self, action: #selector(triggerAction), for: .valueChanged)
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        verifiedPasswordTextField.delegate = self
    }
    
    override func setupViews() {
        view.addSubview(background)
        view.addSubview(logo)
        view.addSubview(segmentControl)
        view.addSubview(inputContainerView)
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(passwordTextField)
        inputContainerView.addSubview(verifiedPasswordTextField)
        inputContainerView.addSubview(nameLineSeperatorView)
        inputContainerView.addSubview(emailLineSeperatorView)
        inputContainerView.addSubview(passwordSeperatorView)
        view.addSubview(submitButton)
        
        //triggerAction(segmentControl)
    }
    
    override func setupLayouts() {
        
        let index = segmentControl.selectedSegmentIndex
        
        _ = background.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        _ = logo.anchor(nil, left: view.leftAnchor, bottom: segmentControl.topAnchor, right: view.rightAnchor, topConstant: 40, leftConstant: 20, bottomConstant: 10, rightConstant: 20)
        logo.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        _ = segmentControl.anchor(logo.bottomAnchor, left: view.leftAnchor, bottom: inputContainerView.topAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 24, bottomConstant: 10, rightConstant: 24)
        segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //inputContainerViewTopAnchor = inputContainerView.topAnchor.
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant:-24).isActive = true
        inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: index == 0 ? 100 : 180)
        inputContainerViewHeightAnchor?.isActive = true
        
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor =  nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: index == 0 ? 0 : 1/4)
        nameTextFieldHeightAnchor?.isActive = true
        
         _ = nameLineSeperatorView.anchor(nameTextField.bottomAnchor, left: inputContainerView.leftAnchor, bottom: nil, right: inputContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        
        nameTextField.isHidden = index == 0 ? true : false
        nameLineSeperatorView.isHidden = index == 0 ? true : false
        
        
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameLineSeperatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: index == 0 ? 0 : 1/4)
        emailTextFieldHeightAnchor?.isActive = true
        
        _ = emailLineSeperatorView.anchor(emailTextField.bottomAnchor, left: inputContainerView.leftAnchor, bottom: nil, right: inputContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
       
        
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextfieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: index == 0 ? 0 : 1/4)
        passwordTextfieldHeightAnchor?.isActive = true
        
        
        verifiedPasswordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        verifiedPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        verifiedPasswordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        verifiedPasswordHeightAnchor = verifiedPasswordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: index == 0 ? 0 : 1/4)
        verifiedPasswordHeightAnchor?.isActive = true
        
        verifiedPasswordTextField.isHidden = index == 0 ? true : false
        
        
         _ = passwordSeperatorView.anchor(passwordTextField.bottomAnchor, left: inputContainerView.leftAnchor, bottom: nil, right: inputContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        passwordSeperatorView.isHidden = index == 0 ? true : false
        
        
        _ = submitButton.anchor(inputContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        triggerAction(segmentControl)
        
    }
    
    override func configureViewForLocalisation() {
        nameTextField.placeholder = Localization(key: Spark.NAME_PLACEHOLDER_TITLE)
        emailTextField.placeholder = Localization(key: Spark.EMAIL_PLACEHOLDER_TITLE)
        passwordTextField.placeholder = Localization(key: Spark.PASSWORD_PLACEHOLDER_TITLE)
        
        
        segmentControl.setTitle(Localization(key: Spark.LOGIN_TITLE), forSegmentAt: 0)
        segmentControl.setTitle(Localization(key: Spark.REGISTER_TITLE), forSegmentAt: 1)
        
        submitButton.setTitle(Localization(key: segmentControl.selectedSegmentIndex == 0 ? Spark.LOGIN_TITLE : Spark.REGISTER_TITLE ), for: .normal)
        
    }
    
     @objc func triggerAction(_ sender: UISegmentedControl) {
        
        let index = segmentControl.selectedSegmentIndex
        submitButton.setTitle(Localization(key: index == 0 ? Spark.LOGIN_TITLE : Spark.REGISTER_TITLE ), for: .normal)
        
        inputContainerViewHeightAnchor?.constant = index == 0 ? 100 : 180
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: index == 0 ? 0 : 1/4)
        nameTextFieldHeightAnchor?.isActive = true
       

        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: index == 0 ? 1/2 : 1/4)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextfieldHeightAnchor?.isActive = false
        passwordTextfieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: index == 0 ? 1/2 : 1/4)
        passwordTextfieldHeightAnchor?.isActive = true
        
        verifiedPasswordHeightAnchor?.isActive = false
        verifiedPasswordHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: index == 0 ? 1/2 : 1/4)
        verifiedPasswordHeightAnchor?.isActive = true
        
        nameTextField.isHidden = index == 0 ? true : false
        nameLineSeperatorView.isHidden = index == 0 ? true : false
        passwordSeperatorView.isHidden = index == 0 ? true : false
        verifiedPasswordTextField.isHidden = index == 0 ? true : false
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (bool) in
                
        }
       
    }
    
    override func keyboardHide(notification: Notification) {
        UIView.animate(withDuration: 1) {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
    }
    
    override func keyboardShow(notification: Notification) {
        UIView.animate(withDuration: 1) {
            self.view.frame = CGRect(x: 0, y: -80, width: self.view.frame.width, height: self.view.frame.height)
        }
    }
    
    
    // hide user keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
     @objc func handleLoginRegister(_ sender: UIButton){
        segmentControl.selectedSegmentIndex == 0 ? handleLogin() : handleRegister()
    }
    
     @objc func handleLogin() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            let alert = UIAlertController(title: Localization(key: Spark.ERROR_FORM_TITLE), message: Localization(key: Spark.ALL_FIELDS_ARE_REQUIRED), preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        if(email.count == 0 || password.count == 0) {
            self.createAlertViewController(title: Localization(key: Spark.ERROR_FORM_TITLE), message: Localization(key: Spark.ALL_FIELDS_ARE_REQUIRED))
            return
        }
        view.endEditing(true)
        
        SwiftSpinner.show(Localization(key: Spark.IN_PROGRESS), animated: true)
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if(error != nil){
                
                /*if let errCode = FIRAuthErrorCode(rawValue: error.code) {
                    switch errCode {
                    case .ErrorCodeInvalidEmail:
                        print("invalid email")
                    case .ErrorCodeEmailAlreadyInUse:
                        print("in use")
                    default:
                        print("Create User Error: \(error)")
                    }
                    
                }*/
                SwiftSpinner.hide()
                guard let errorMessage = error?.localizedDescription else { return }
                self.createAlertViewController(title: Localization(key: Spark.ERROR_FORM_TITLE), message: errorMessage)
                return
            }
            self.user.reset = true
            self.dismiss(animated: self.user.isFirstLaunched ? false : true, completion: {
                if( self.completion != nil){
                    self.completion(false)
                }
            })

            print(" login done \(String(describing: user))")
           
        })
        
    }
    
    func handleRegister() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text, let verified = verifiedPasswordTextField.text else {
            return
        }
        
        if email.count == 0 || password.count == 0 || name.count == 0 {
            self.createAlertViewController(title: Localization(key: Spark.ERROR_FORM_TITLE), message: Localization(key: Spark.ALL_FIELDS_ARE_REQUIRED))
            return
        }
        
        if password != verified {
            self.createAlertViewController(title: Localization(key: Spark.ERROR_FORM_TITLE), message: Localization(key: Spark.PASSWORD_NOT_MATCH))
            return
        }
        
        
        view.endEditing(true)
        SwiftSpinner.show(Localization(key: Spark.IN_PROGRESS), animated: true)
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if(error != nil) {
                //print(error.debugDescription.)
                guard let errorMessage = error?.localizedDescription else { return }
                self.createAlertViewController(title: Localization(key: Spark.ERROR_FORM_TITLE), message: errorMessage)
                return
            }
            guard let ui = user?.uid else { return }
            let userReference = SparkDataService.shared.firebaseChildnode("user").child(ui)
            let values = ["email" : email.lowercased(),
                          "name": name.lowercased(),
                          "subscription": ServerValue.timestamp()] as [String : Any]
            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                
                if(error != nil){
                    self.createAlertViewController(title: Localization(key: Spark.ERROR_FORM_TITLE), message: (error?.localizedDescription)!)
                    return
                }
                
                self.dismiss(animated: false, completion: {
                    if( self.completion != nil){
                        self.completion(false)
                    }
                    SwiftSpinner.hide({})
                })
                
            })
            
            
            print(" register done \(String(describing: user))")
            
        }
       
    }
    
}
