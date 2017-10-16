//
//  UsersPresenter.swift
//  MessengerUI
//
//  Created by MacBook Pro on 4/24/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import UIKit

protocol PresenterProtocol {
    func didLoginSuccess(result:String, data:[UserModel])
    func didLoginFail(result:String)
}


//extension PresenterProtocol {
//    func didSignupSuccess(result:String){}
//    func didSignupFail(result:String){}
//}

protocol SignupPresenterProtocol {
    func didSignupSuccess(result:String)
    func didSignupFail(result:String)
}

//Work with image url
protocol ImageUrlResponseProtocol {
    func didResponseImageUrl(url:String)
}
//MARK - Presenter Class
class UserPresenter {
    
    
    var delegate:PresenterProtocol?                 //Log in
    var signupDelegate:SignupPresenterProtocol?     // Sign Up
    var imageUrlDelegate:ImageUrlResponseProtocol?  //Response image from url
    var service:UserService?                        //User Service Object
    
    init() {
        service = UserService() //Initial
        service?.delegate = self //Setup user service delegate
    }
    
    //TODO: Pass Login data to service
    func loginData(data:UserModel){
        service?.loginData(data: data)
        print("======Presenter Data=======", data.email ?? "")
    }
    //TODO: Pass Signup Data to service
    func signupData(data:UserModel) {
        service?.uploadSignUpData(data: data)
        print("This is rigister data in presenter============",data.email)
    }
    //TODO: Pass Signup Data without image
    func signupDataWithoutImage(data: UserModel){
        service?.uploadSignupDataWithoutImage(data: data)
    }
    
    //TODO: Pass original Image to service
    func originalImage(image: UIImage){
        service?.uploadOriginalImage(image: image)
    }
    
}

//MARK - Work with service
extension UserPresenter:ServiceProtocol{
    
    // ====Login Success====
    func didLoginSuccess(result: String, data:[UserModel]) {
        print("=========Login Succcess in Presenter========", result)
        delegate?.didLoginSuccess(result: result, data: data)
    }
    // ====Login Failed====
    func didLoginFail(result: String) {
        print("========Login Failed in Presenter=========", result)
        delegate?.didLoginFail(result: result)
    }
    
    //====Signup Success===
    func didSignupSuccess(result: String) {
        print("====Presenter Signup Success===")
        signupDelegate?.didSignupSuccess(result: result)
    }
    //===Signup Fail===
    func didSingupFail(result: String) {
        print("===Presnter Signup Fail===")
        signupDelegate?.didSignupFail(result: result)
    }
    
    //====Responsed Image Url====
    func didResponseImageUrl(url: String) {
        imageUrlDelegate?.didResponseImageUrl(url: url)
    }
}
