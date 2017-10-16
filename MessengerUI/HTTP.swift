//
//  HttpURL.swift
//  MessengerUI
//
//  Created by Mean Reaksmey on 4/24/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration
//
//var mainURL = "http://192.168.17.156:5000/api/v1/"
//var imageURL = "http://192.168.17.156:5000/api/v1/"
//mama
var mainURL = "http://192.168.17.39:2000/api/v1/"
var imageURL = "http://192.168.17.39:2000/api/v1/"

var head:HTTPHeaders = ["Authorization":"Basic YWRtaW46MjAxNy8wNC8yOQ==","Content-Type":"application/json"]

open class HttpRequest{
    
    //    init(){
    //        let configuration = URLSessionConfiguration.default
    //        configuration.timeoutIntervalForResource = 60 // seconds
    //        alamofireManager = SessionManager(configuration: configuration)
    //    }
    
    open class func get(_ url:String, parameter: [String: AnyObject]!, callback:@escaping (Bool, JSON?, JSON?) -> Void){
        //        alamofireManager?.request(mainUrl + url, parameters: parameter, headers: head)
        Alamofire.request(mainURL + url, parameters: parameter, headers: head)
            //  .authenticate(usingCredential: credential)
            .responseJSON { response in
                if response.result.error == nil{
                    if let data = response.result.value{
                        DispatchQueue.main.async {
                            if(response.response?.statusCode == 200){
                                callback(true, JSON(data), JSON((response.response?.statusCode)!))
                            } else if((response.response?.statusCode) != nil){
                                callback(false, JSON(data), JSON((response.response?.statusCode)!))
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        if let status = response.response?.statusCode{
                            callback(false, JSON(status),JSON((response.response?.statusCode)!))
                        }else{
                            callback(false,JSON(self.getStatusCodeString(408)),JSON(408))
                        }
                    }
                }
        }
    }
    
    open class func post(_ url:String, parameter: [String: AnyObject], callback:@escaping (Bool, JSON?,JSON?) -> Void){
        Alamofire.request(mainURL + url,method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: head)
            .responseJSON { response in
                if response.result.error == nil{
                    if let data = response.result.value{
                        DispatchQueue.main.async {
                            if(response.response?.statusCode == 200){
                                callback(true, JSON(data), JSON((response.response?.statusCode)!))
                            } else{
                                callback(false, JSON(data), JSON((response.response?.statusCode)!))
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        if let status = response.response?.statusCode{
                            callback(false, JSON(status),JSON((response.response?.statusCode)!))
                        }else{
                            callback(false,JSON(self.getStatusCodeString(408)),JSON(408))
                        }
                    }
                }
        }
    }
    
    open class func upload(_ url:String, parameters: [String:Data], callback:@escaping (Bool, JSON?,JSON?) -> Void){
        
        let requestUrl = try! URLRequest(url: mainURL + url, method: .post, headers: head)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append(value, withName: key, fileName: "picture10.png", mimeType: "image/png")
            }
            
        }, with: requestUrl, encodingCompletion: { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON{
                    response in
                    if let data = response.result.value{
                        DispatchQueue.main.async {
                            if(response.response?.statusCode == 200){
                                callback(true, JSON(data), JSON((response.response?.statusCode)!))
                            } else{
                                callback(false, JSON(data), JSON((response.response?.statusCode)!))
                            }
                        }
                    }
                }
                
            case .failure(let encodingError):
                DispatchQueue.main.async {
                    print("on error: ", encodingError)
                    callback(false,JSON(self.getStatusCodeString(408)),JSON(408))
                }
                
            }
            
        })
    }
    
    open class func getStatusCodeString(_ status: Int) -> String {
        switch status{
        case 400:
            return "\(status) Bad Request"
        case 401:
            return "\(status) Unauthorized"
        case 402:
            return "\(status) Payment Required"
        case 403:
            return "\(status) Forbidden"
        case 404:
            return "\(status) Not Found"
        case 405:
            return "\(status) Method Not Allowed"
        case 406:
            return "\(status) Not Acceptable"
        case 407:
            return "\(status) Proxy Authentication Required"
        case 408:
            return "\(status) Request Timeout"
        case 409:
            return "\(status) Conflict"
        case 410:
            return "\(status) Gone"
        case 411:
            return "\(status) Length Required"
        case 412:
            return "\(status) Precondition Failed"
        case 413:
            return "\(status) Request Entity Too Large"
        case 414:
            return "\(status) Request-URI Too Long"
        case 415:
            return "\(status) Unsupported Media Type"
        case 416:
            return "\(status) Requested Range Not Satisfiable"
        case 417:
            return "\(status) Expectation Failed"
        case 500:
            return "\(status) Internal Server Error"
        case 501:
            return "\(status) Not Implemented"
        case 502:
            return "\(status) Bad Gateway"
        case 503:
            return "\(status) Service Unavailable"
        case 504:
            return "\(status) Gateway Timeout"
        case 505:
            return "\(status) HTTP Version Not Supported"
        default:
            return "\(status) Connection Timeout"
        }
    }
    
    // If have Internet connection It will return true, If not It will return false
    open class func checkInternetConnection() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}







