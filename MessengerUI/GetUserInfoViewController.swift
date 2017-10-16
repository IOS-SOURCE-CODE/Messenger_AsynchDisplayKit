//
//  GetUserInfoViewController.swift
//  MessengerUI
//
//  Created by MacBook Pro on 4/19/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import UIKit

class SignUpInfo:UIViewController {
    
    var userSignUp : UserSignUp!
    
    lazy var infoLabel: UILabel = {
        let info = UILabel()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.text = "What is your name?"
        info.numberOfLines = 4
        info.textAlignment = .center
        info.font = info.font.withSize(30)
        return info
    }()
    
    lazy var infoDescription: UILabel = {
        var desc = UILabel()
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.text = "Use your real name so people know it's you. Once you tap *Continue* you wont be able to change it."
        desc.font = desc.font.withSize(14)
        desc.textColor = UIColor.gray
        desc.numberOfLines = 4
        desc.textAlignment = .center
        return desc
    }()
    
    lazy var firstNameField: UITextField = {
        let fName = UITextField()
        fName.translatesAutoresizingMaskIntoConstraints = false
        fName.placeholder = "First Name"
        fName.textAlignment = .center
        fName.clearButtonMode = UITextFieldViewMode.whileEditing
        return fName
    }()
    
    lazy var lastNameField: UITextField = {
        let lName = UITextField()
        lName.translatesAutoresizingMaskIntoConstraints = false
        lName.placeholder = "Last Name"
        lName.textAlignment = .center
        lName.clearButtonMode = UITextFieldViewMode.whileEditing
        return lName
    }()
    
    lazy var userNameField:UITextField = {
        let userName = UITextField()
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.placeholder = "User Name"
        userName.textAlignment = .center
        userName.clearButtonMode = UITextFieldViewMode.whileEditing
        return userName
    }()
    
    lazy var continueBtn: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        return button
    }()
    
    lazy var underlineLastName:UIView = {
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = UIColor.gray
        underline.layer.opacity = 0.5
        return underline
    }()
    
    lazy var underlineFirstName:UIView = {
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.layer.opacity = 0.5
        return underline
    }()
    
    lazy var underlineUserName:UIView = {
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = UIColor.gray
        underline.layer.opacity = 0.5
        return underline
    }()
    //Mark - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        print("This is sign up info")
        setContinueBtn()
        setupUserName()
        setLastName()
        setFirstName()
        setupUnderlineUserName()
        setUnderlineLastName()
        setUnderlineFirstName()
        setDescription()
        setInfoLabel()
    }
}

//MARK - Setup Interface
extension SignUpInfo{
    func setContinueBtn(){
        self.view.addSubview(continueBtn)
        continueBtn.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        continueBtn.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        continueBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -200).isActive = true
        continueBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        continueBtn.addTarget(self, action: #selector(self.continueBtnPressed), for: UIControlEvents.touchUpInside)
    }
    
    func setupUserName(){
        self.view.addSubview(userNameField)
        userNameField.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        userNameField.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        userNameField.bottomAnchor.constraint(equalTo: continueBtn.topAnchor, constant: -20).isActive = true
    }
    
    func setLastName(){
        self.view.addSubview(lastNameField)
        lastNameField.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        lastNameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.43).isActive = true
        lastNameField.bottomAnchor.constraint(equalTo: userNameField.topAnchor, constant: -20).isActive = true
    }
    
    func setFirstName(){
        self.view.addSubview(firstNameField)
        firstNameField.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        firstNameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.43).isActive = true
        firstNameField.bottomAnchor.constraint(equalTo: userNameField.topAnchor, constant: -20).isActive = true
    }
    
    func setupUnderlineUserName(){
        self.view.addSubview(underlineUserName)
        underlineUserName.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        underlineUserName.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        underlineUserName.topAnchor.constraint(equalTo: userNameField.bottomAnchor).isActive = true
        underlineUserName.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    //Underline Last Name Field
    func setUnderlineLastName(){
        self.view.addSubview(underlineLastName)
        underlineLastName.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        underlineLastName.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: 5.0).isActive = true
        underlineLastName.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.43).isActive = true
        underlineLastName.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    //Underline First Name Field
    func setUnderlineFirstName(){
        self.view.addSubview(underlineFirstName)
        underlineFirstName.backgroundColor = UIColor.gray
        underlineFirstName.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        underlineFirstName.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: 5.0).isActive = true
        underlineFirstName.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.43).isActive = true
        underlineFirstName.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    func setDescription(){
        self.view.addSubview(infoDescription)
        infoDescription.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        infoDescription.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        infoDescription.bottomAnchor.constraint(equalTo: firstNameField.topAnchor, constant:-30).isActive = true
    }
    
    func setInfoLabel(){
        self.view.addSubview(infoLabel)
        infoLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        infoLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: infoDescription.topAnchor, constant: -30).isActive = true
    }
}

//MARK - In-View Functionalities
extension SignUpInfo{
    func continueBtnPressed(){
        print("ContinuePressed")
        
        let firstName = firstNameField.text
        let lastName = lastNameField.text
        let userName = userNameField.text
        
        userSignUp.lastName = lastNameField.text!
        userSignUp.firstName = firstNameField.text!
        userSignUp.username = userNameField.text!
        let userPhoto = UserPhoto()
        userPhoto.userSignUp = userSignUp
        
        if (firstName?.isEmpty)! || (lastName?.isEmpty)! || (userName?.isEmpty)!{
            if (firstName?.isEmpty)!{
                alertMessage(Message: "Please enter your First Name")
            }else if (lastName?.isEmpty)!{
                alertMessage(Message: "Please enter your Last Name")
            }else if (userName?.isEmpty)!{
                alertMessage(Message: "Please enter Username")
            }
        }else {
            self.navigationController?.pushViewController(userPhoto, animated: true)
        }
    }
    
    func alertMessage(Message:String){
        let alertController = UIAlertController(title: "Attention", message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (ACTION) in
            if (self.firstNameField.text?.isEmpty)!{
                self.firstNameField.becomeFirstResponder()
            } else if (self.lastNameField.text?.isEmpty)!{
                self.lastNameField.becomeFirstResponder()
            } else{
                self.userNameField.becomeFirstResponder()
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
