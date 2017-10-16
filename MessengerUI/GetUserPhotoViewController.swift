//
//  GetUserPhotoViewController.swift
//  MessengerUI
//
//  Created by MacBook Pro on 4/19/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import UIKit

var imageVIew = UIImageView()

class UserPhoto: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var presenter:UserPresenter?
    var userSignUp:UserSignUp!      //Passing data
    var imagePath: UIImage!         //Original img from library
    var didResponseImagePath:String!
    
    //1 MARK - Sign Up Profile Photo
    lazy var imageLabel: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "profileImage")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 60.0
        img.backgroundColor = UIColor.red
        img.clipsToBounds = true
        //       img.layer.borderColor = UIColor(hex: "0084ff").cgColor
        img.layer.borderColor = UIColor.gray.cgColor
        img.layer.borderWidth = 3
        
        imageVIew = img
        return img
    }()
    
    //2 MARK - Text Lable => "Whant to add a photo?"
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Want to add a photo?"
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.font = label.font.withSize(30)
        return label
    }()
    
    //3 MARK - Description Text Label
    lazy var descriptionLabel:UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.text = "Add a photo so your friends can regconize you."
        description.textAlignment = .center
        description.numberOfLines = 3
        description.font = description.font.withSize(14)
        description.textColor = UIColor.gray
        return description
    }()
    
    //4 MARK - Done Button
    lazy var doneBtn:UIButton = {
        let choose = UIButton(type: UIButtonType.system)
        choose.translatesAutoresizingMaskIntoConstraints = false
        choose.setTitle("DONE", for: .normal)
        return choose
    }()
    
    //5 Not Now Button
    lazy var notNowBtn:UIButton = {
        let notNow = UIButton(type: UIButtonType.system)
        notNow.translatesAutoresizingMaskIntoConstraints = false
        notNow.setTitle("NOT NOW", for: .normal)
        notNow.setTitleColor(.gray, for: .normal)
        return notNow
    }()
    
    var signUp : SignUpScreen? //Signup Obj
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello this is User Photo Class")
        signUp = SignUpScreen() //Initial
        presenter = UserPresenter() //Initial User Presenter
        presenter?.signupDelegate = self
        presenter?.imageUrlDelegate = self
        
        self.view.backgroundColor = UIColor.white
        
        setNotNowBtn()
        setDoneBtn()
        setDescription()
        setLabel()
        setImageLabel()
        
        
    }
}

// MARK - Func for Seting Up Interface
extension UserPhoto{
    
    //TODO: Setup Not Now Button
    func setNotNowBtn(){
        self.view.addSubview(notNowBtn)
        notNowBtn.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        notNowBtn.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        notNowBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -40).isActive = true
        notNowBtn.addTarget(self, action: #selector(notNowBtnPressed), for: UIControlEvents.touchUpInside)
    }
    //TODO: Setup Done Button
    func setDoneBtn(){
        self.view.addSubview(doneBtn)
        doneBtn.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: 100).isActive = true
        doneBtn.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: -100).isActive = true
        doneBtn.bottomAnchor.constraint(equalTo: notNowBtn.topAnchor, constant: -170).isActive = true
        
        doneBtn.addTarget(self, action: #selector(doneBtnPressed), for: UIControlEvents.touchUpInside)
    }
    
    //TODO: Setup Description Detail
    func setDescription(){
        self.view.addSubview(descriptionLabel)
        descriptionLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: doneBtn.topAnchor, constant: -40).isActive = true
    }
    
    //TODO: Setup Description Tittle
    func setLabel(){
        self.view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -10).isActive = true
    }
    
    //TODO Setup Profile Image
    func setImageLabel(){
        self.view.addSubview(imageLabel)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageLabel.isUserInteractionEnabled = true
        imageLabel.addGestureRecognizer(tapGestureRecognizer)
        
        imageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imageLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageLabel.bottomAnchor.constraint(equalTo: label.topAnchor, constant:-40).isActive = true
    }
}

// MARK - View Functionalities
extension UserPhoto{
    
    //TODO - Getting image from PHOTO LIBRARY & CAMERA
    func chooseImage(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose an image", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: " ❌ Attention!", message: "Sorry! Camera is not available!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler:nil)
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imagePath = image          //Assign image to public variable
        imageLabel.image = image        //Set selected image to User Profile
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Send original image url to server
    func doneBtnPressed(){
        if imagePath != nil{
            self.presenter?.originalImage(image: imagePath) //Call delegate & send img to server
        }else{
            let alert = UIAlertController(title: "👤Attention", message: "Please Choose an Image Profile!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler:{action in
                self.chooseImage()
            })
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Prepare SignUp data for server, upload with image
    func uploadSignupData(){
        
        userSignUp.image = didResponseImagePath             //Add image value to userSignup
        
        //Prepare Signup data for server
        let userSignupData = UserModel()
        userSignupData?.email = userSignUp.email
        userSignupData?.password = userSignUp.password
        userSignupData?.firstName = userSignUp.firstName
        userSignupData?.lastName = userSignUp.lastName
        userSignupData?.userName = userSignUp.username
        userSignupData?.profileImage = userSignUp.image
        
        self.presenter?.signupData(data: userSignupData!)   //Call delegate & send data to server
    }
    
    //Upload data without image
    func notNowBtnPressed(){
        //Prepare Signup data for server
        let userSignupData = UserModel()
        userSignupData?.email = userSignUp.email
        userSignupData?.password = userSignUp.password
        userSignupData?.firstName = userSignUp.firstName
        userSignupData?.lastName = userSignUp.lastName
        userSignupData?.userName = userSignUp.username
        
        self.presenter?.signupDataWithoutImage(data: userSignupData!)
    }
}

extension UserPhoto:SignupPresenterProtocol{
    func didSignupSuccess(result: String) {
        print("User photo success=======")
        //        if imagePath == nil{
        //            print("===Image path has nil value===")
        //        }else{
        
        let alert = UIAlertController(title: "✅ Success", message: "Sign Up Successfully, Please login!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler:{ (Action) in
            
            //Navigate to login screen
            let login = RootLogin()
            self.navigationController?.pushViewController(login, animated: true)
        })
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didSignupFail(result: String) {
        let alert = UIAlertController(title: "Sign Up Fail!", message: "Either Email Address or User Name is already in use! Please try a new one", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler:{ (Action) in
            
            //Navigate to login screen
            let signUp = SignUpScreen()
//            self.navigationController?.pushViewController(login, animated: true)
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
}

//Response image path from server
extension UserPhoto:ImageUrlResponseProtocol{
    func didResponseImageUrl(url: String) {
        self.didResponseImagePath = url     //Assign responsed Image Path value to variable
        uploadSignupData()                  //Upload Signup data to server after image url response success
    }
}
