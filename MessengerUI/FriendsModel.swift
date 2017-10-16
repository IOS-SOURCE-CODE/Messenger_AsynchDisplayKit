//
//  FriendsModel.swift
//  Messenger
//
//  Created by Hiem Seyha on 4/6/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper


class CurrentUser {
  
  var id: Int?
  var hashCode:String?
  var email: String?
  var password:String?
  var firstName:String?
  var lastName:String?
  var username:String?
  var profileImage:String?
  var isActive:Int?
  var vartificationCode:Int?
  
  private init(){}
  
  static let shareInstance = CurrentUser()
  
}

class Friend:Mappable {
  
  var id: Int?
  var hashCode:String?
  var email: String?
  var password:String?
  var firstName:String?
  var lastName:String?
  var username:String?
  var profileImage:String?
  var isActive:Int?
  var vartificationCode:Int?
  
  required init?(map:Map){}
  
  func mapping(map:Map){
    id                 <-  map["id"]
    hashCode           <-  map["hashCode"]
    password           <-  map["password"]
    firstName          <-  map["first_name"]
    email              <-  map["email"]
    lastName           <-  map["last_name"]
    username           <-  map["username"]
    profileImage       <-  map["profile_image"]
    isActive           <-  map["is_active"]
    vartificationCode  <-  map["verification_code"]
  }
  
  init(id: Int, hashCode: String, email: String, password: String, firstName: String, lastName: String, username: String, profileImage: String, isActive: Int, vartificationCode: Int)  {
    
    self.id = id
    self.hashCode = hashCode
    self.email = email
    self.password = password
    self.firstName = firstName
    self.lastName = lastName
    self.username = username
    self.profileImage  = profileImage
    self.isActive = isActive
    self.vartificationCode = vartificationCode
    
  }
  
}


struct UserActive {
 
  static func getUserActive() -> [Friends]{
    return [
        Friends(userProfile: "https://scontent-hkg3-1.xx.fbcdn.net/v/t31.0-8/15732174_941413352656320_7594404466250029989_o.jpg?oh=f638102ab64addbe807775222798fba7&oe=5957E40C", userName: "Hiem Seyha", section: 0)
    ]
  }
}

struct Friends {
  var userProfile:String
  var userName:String
  var section:Int

}
