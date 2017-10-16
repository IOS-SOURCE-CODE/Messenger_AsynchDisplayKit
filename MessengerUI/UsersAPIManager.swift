//
//  UsersAPIManager.swift
//  MessengerUI
//
//  Created by MacBook Pro on 4/25/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import UIKit

//MARK - ServiceProtocol
protocol ServiceProtocol{
    
    func didLoginSuccess(result:String, data:[UserModel])
    func didLoginFail(result:String)
    func didSignupSuccess(result:String)
    func didSingupFail(result:String)
    func didResponseImageUrl(url:String)
}

//=======================
//Service Class
//=======================

class UserService{
    var delegate:ServiceProtocol?
    
    //Login
    func loginData(data:UserModel){
        print("=====Service ====", data.email ?? "")
        let param : Parameters = [
            "email":"\(data.email)",
            "password":"\(data.password)"]
        
        //"http://192.168.17.39:2000/api/v1/user/login"
        
        
        Alamofire.request(URL_CHAT + "user/login", method: .post, parameters: param, encoding: JSONEncoding.default, headers: head).responseArray(queue: nil, keyPath: "user", context: nil) { (response:DataResponse<[UserModel]>) in
            debugPrint(response)
            if let data = response.result.value {
                print("=======Response data=======", data)
                print("========Login Succes in Service==========")
                self.delegate?.didLoginSuccess(result: "Successfully Loged In", data: data)
            } else {
                self.delegate?.didLoginFail(result: "Login Failed")
            }
        }
    }
}

// Signup
extension UserService{
    func uploadSignUpData(data:UserModel){
        let param : Parameters = [
            "email":"\(data.email)",
            "password":"\(data.password)",
            "first_name":"\(data.firstName)",
            "lastname":"\(data.lastName)",
            "username":"\(data.userName)",
            "profile_image":"\(data.profileImage)"
        ]
        
        print("==========Service=========",data.email)
        Alamofire.request(URL_CHAT + "user/add", method: .post, parameters: param, encoding: JSONEncoding.default, headers: head).responseJSON{ response in
            let responseJSON = JSON(data: response.data!)
            if responseJSON["code"] == "200"{
                print("Success==========", responseJSON)
                self.delegate?.didSignupSuccess(result: "Login Success")
            }else{
                print("Fail sign up ======")
                self.delegate?.didSingupFail(result: "Signup Fail")
            }
            
        }
    }
}

//Upload sign up data without image
extension UserService{
    func uploadSignupDataWithoutImage(data:UserModel){
        let param : Parameters = [
            "email":"\(data.email)",
            "password":"\(data.password)",
            "first_name":"\(data.firstName)",
            "lastname":"\(data.lastName)",
            "username":"\(data.userName)",
            
        ]
        
        print("==========Service=========",data.email)
        Alamofire.request(URL_CHAT + "user/add", method: .post, parameters: param, encoding: JSONEncoding.default, headers: head).responseJSON{ response in
            let responseJSON = JSON(data: response.data!)
            if responseJSON["code"] == "200"{
                print("Success==========", responseJSON)
                self.delegate?.didSignupSuccess(result: "Login Success")
            }else{
                print("Fail sign up ======")
                self.delegate?.didSingupFail(result: "Signup Fail")
            }
            
        }
    }
    
}

//Upload Image from Photo Library
extension UserService{
    func uploadOriginalImage (image:UIImage){
        Alamofire.upload(multipartFormData: {formData in
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            
            formData.append(imageData!, withName: "profile_image", fileName: "image.jpg", mimeType: "image/jpg")
        }, usingThreshold: 0, to: URL(string: URL_CHAT + "image/upload")!, method: .post, headers: head, encodingCompletion: {
            
            result in
            
            print("==============")
            debugPrint(result)
            switch result{
            case .success(request: let upload, _, _):
                upload.responseJSON(completionHandler: {
                    
                    response in
                    
                    if let data = response.result.value as? [String:AnyObject]{
                        if data["code"] as! String == "200"{
                            self.delegate?.didResponseImageUrl(url: data["path"] as! String)
                            debugPrint("==========", data)
                        }
                    }
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
