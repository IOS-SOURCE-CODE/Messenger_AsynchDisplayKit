//
//  UserModel.swift
//  MessengerUI
//
//  Created by Mean Reaksmey on 4/24/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import ObjectMapper

class UserModel: Mappable {
    
    var id = Int()
    var userName = ""
    var isActive = Int()
    var profileImage = ""
    var userID = Int()
    var roomID = Int()
    var roomStatus = Int()
    var userStatus = Int()
    var email = ""
    var password = ""
    var firstName = ""
    var lastName = ""
    
    
    
    required init?(map: Map){
        
    }
    
    required init?(){
    }
    
    func mapping(map: Map) {
        
        id            <- map["id"]
        userName      <- map["username"]
        isActive      <- map["is_active"]
        profileImage  <- map["profile_image"]
        userStatus    <- map["user_status"]
        userID        <- map["id"]
        roomID        <- map["room_status"]
        userStatus    <- map["user_status"]
        email           <- map["email"]
        password        <- map["password"]
        firstName       <- map["first_name"]
        lastName        <- map["lastname"]
        
    }
}
