//
//  SignUpViewController.swift
//  MessengerUI
//
//  Created by MacBook Pro on 4/19/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import UIKit

class SignUpScreen: UIViewController {
    
    //8 MARK - Sign Up Label => "Sign Up With Messenger"
    lazy var signUpLabel:UILabel = {
        let signUp = UILabel()
        signUp.translatesAutoresizingMaskIntoConstraints = false
        signUp.text = "Sign up with Messenger"
        signUp.numberOfLines = 4
        signUp.font = signUp.font.withSize(30)
        signUp.textAlignment = .center
        return signUp
    }()
    
    //5 MARK - Sign Up Email Text Field
    lazy var emailField:UITextField = {
        let email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.placeholder = "Email or Phone"
        email.textAlignment = .center
        email.clearButtonMode = UITextFieldViewMode.whileEditing
        return email
    }()
    
    //4 MARK - Sign Up Password Text Field
    lazy var passwordField:UITextField = {
        let pwd = UITextField()
        pwd.translatesAutoresizingMaskIntoConstraints = false
        pwd.placeholder = "Password"
        pwd.textAlignment = .center
        pwd.isSecureTextEntry = true
        pwd.clearButtonMode = UITextFieldViewMode.whileEditing
        return pwd
    }()
    
    //7 MARK - Underline Email
    lazy var underlineEmail:UIView = {
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = UIColor.gray
        underline.layer.opacity = 0.5
        return underline
    }()
    
    //6 MARK - Underline Password
    lazy var underlinePwd:UIView = {
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = UIColor.gray
        underline.layer.opacity = 0.5
        return underline
    }()
    
    //3 MARK - Sign Up Continue Button
    lazy var continueBtn:UIButton = {
        let signUp = UIButton(type: UIButtonType.system)
        signUp.translatesAutoresizingMaskIntoConstraints = false
        signUp.setTitle("Continue", for: .normal)
        return signUp
    }()
    
    //2 MARK - Sign Up Privacy Label
    lazy var privacyLabel: UILabel = {
        let privacy = UILabel()
        privacy.translatesAutoresizingMaskIntoConstraints = false
        privacy.text = "By continuing, you are indicating that you are agree the Privacy and Terms."
        privacy.numberOfLines = 4
        privacy.textColor = UIColor.gray
        privacy.textAlignment = .center
        privacy.font = privacy.font.withSize(14)
        return privacy
    }()
    
    //1 MARK - Button Login With Gmail
    lazy var login:UIButton = {
        let login = UIButton(type: UIButtonType.system)
        login.translatesAutoresizingMaskIntoConstraints = false
        login.setTitle("I already have an account!", for: .normal)
        return login
    }()
    //=====================
    //==== viewDidload ====
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setLogin()              //1
        setPrivacy()            //2
        setContinueBtn()        //3
        setPassword()           //4
        setEmail()              //5
        setPasswordUnderline()  //6
        setEmailUnderline()     //7
        setLabel()              //8
        print("SignUp Here")
    }
}

//MARK: Setup Interface
extension SignUpScreen{
    
    //1 TODO: Setup Gmail Login Button
    func setLogin(){
        self.view.addSubview(login)
        login.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        login.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        login.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        login.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        login.addTarget(self, action: #selector(self.loginBtnPressed), for: UIControlEvents.touchUpInside)
    }
    
    //2 TODO: Setup Sign Up Privacy Lable
    func setPrivacy(){
        self.view.addSubview(privacyLabel)
        privacyLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        privacyLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        privacyLabel.bottomAnchor.constraint(equalTo: login.topAnchor, constant: -40).isActive = true
    }
    
    //3 TODO: Setup Continue Button
    func setContinueBtn(){
        self.view.addSubview(continueBtn)
        continueBtn.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        continueBtn.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        continueBtn.bottomAnchor.constraint(equalTo: privacyLabel.topAnchor, constant: -40).isActive = true
        continueBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        
        continueBtn.addTarget(self, action: #selector(self.continueBtnPressed), for: UIControlEvents.touchUpInside)
        
    }
    
    //4 TODO: Setup Password Text Field
    func setPassword(){
        self.view.addSubview(passwordField)
        passwordField.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        passwordField.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        passwordField.bottomAnchor.constraint(equalTo: continueBtn.topAnchor, constant:-20).isActive = true
    }
    
    //5 TODO: Setup Email Text Field
    func setEmail(){
        self.view.addSubview(emailField)
        emailField.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        emailField.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        emailField.bottomAnchor.constraint(equalTo: passwordField.topAnchor, constant: -20).isActive = true
    }
    
    //6 TODO: Setup Password Underline
    func setPasswordUnderline(){
        self.view.addSubview(underlinePwd)
        underlinePwd.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        underlinePwd.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        underlinePwd.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 5.0).isActive = true
        underlinePwd.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    //7 TODO: Setup Email Underline
    func setEmailUnderline(){
        self.view.addSubview(underlineEmail)
        underlineEmail.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        underlineEmail.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        underlineEmail.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 5.0).isActive = true
        underlineEmail.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    //6 TODO: Setup Label => "Sign Up With Messenger"
    func setLabel(){
        self.view.addSubview(signUpLabel)
        signUpLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        signUpLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        signUpLabel.bottomAnchor.constraint(equalTo: emailField.topAnchor, constant: -50).isActive = true
    }
}

//MARK - View Functionalities
extension SignUpScreen{
    func continueBtnPressed(){
        
        let email = emailField.text
        let password = passwordField.text
        var userSignUp = UserSignUp()
        userSignUp.email = email
        userSignUp.password = password
        let signUpInfo = SignUpInfo()
        signUpInfo.userSignUp = userSignUp
        
        if (email?.isEmpty)! || (password?.isEmpty)!{
            if (email?.isEmpty)!{
                alertMessage(Message: "Please enter your email address to Sign Up")
            }else if (password?.isEmpty)!{
                alertMessage(Message: "Please enter password")
            }
        }else if isValidEmailAddress(emailAddressString: email!){
            print("Valid")
            self.navigationController?.pushViewController(signUpInfo, animated: true)
        }else {
            alertMessage(Message: "Email address is invalid")
        }
        
    }
    //Go back to Login
    func loginBtnPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //Alert Message
    func alertMessage(Message:String){
        let alertController = UIAlertController(title: "Attention", message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (ACTION) in
            if (self.emailField.text?.isEmpty)!{
                self.emailField.becomeFirstResponder()
            } else if (self.passwordField.text?.isEmpty)!{
                self.passwordField.becomeFirstResponder()
            } else{
                self.emailField.becomeFirstResponder()
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}






