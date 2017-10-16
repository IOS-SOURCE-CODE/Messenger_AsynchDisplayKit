//
//  APIManager.swift
//  MessengerUI
//
//  Created by Hiem Seyha on 4/25/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import Alamofire


open class Http {
  open class func get(url:String, parameter: [String: AnyObject]!, model:Any, callback:@escaping (Bool, JSON?, JSON?) -> Void){
    
//      Alamofire.request(CHAT_URL + url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseArray(queue: nil, keyPath: "data", context: nil){ (response:DataResponse<[]>) in
//        
//        if let data = response.result.value {
//          
//          print("Data Response", data)
//          
//        } else {
//          
//          print("Faild To Loading News", CHAT_URL + url)
//        }
//        
//      }

  }

}
