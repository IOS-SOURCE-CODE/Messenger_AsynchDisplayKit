//
//  ChatModel.swift
//  MessengerUI
//
//  Created by Hiem Seyha on 4/10/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import ObjectMapper

// ==== Chating Message ======
class Message :Mappable{
  
  var id:Int?
  var roomID:Int?
  var userStatus:Int?
  var messages:String?
  var participantsID:Int?
  var userID:Int?
  var profileImage:String?
  
  
  init(){}
  
  required init?(map:Map){}
  
  func mapping(map: Map) {
    id              <-    map["id"]
    roomID          <-    map["room_id"]
    userStatus      <-    map["user_status"]
    messages        <-    map["messages"]
    participantsID  <-    map["participants_id"]
    userID          <-    map["user_id"]
    profileImage    <-    map["profile_image"]
    
  }
  
  init(participantsID:Int, userID:Int, messages:String,profileImage:String) {
    self.participantsID = participantsID
    self.userID = userID
    self.messages = messages
    self.profileImage = profileImage
  }
  
  init(id:Int,roomID:Int,userStatus:Int,participantsID:Int, userID:Int, messages:String, profileImage:String) {
    self.id = id
    self.roomID = roomID
    self.userStatus = userStatus
    self.participantsID = participantsID
    self.userID = userID
    self.messages = messages
    self.profileImage = profileImage
  }
  
}

//====== Get Friend By UseriD  ========

class People: Mappable {
  
  var id:Int?
  var phone:String?
  var email:String?
  var password:String?
  var firstName:String?
  var lastName:String?
  var profileImage:String?
  var isActive:Int?
  var vertificationCode:Int?
  var username:String?
  
  init(){}
  
  required init?(map: Map){
  }
  
  func mapping(map:Map){
     id                 <-  map["id"]
     phone              <-  map["phone"]
     email              <-  map["email"]
     password           <-  map["password"]
     firstName          <-  map["first_name"]
     lastName           <-  map["last_name"]
     profileImage       <-  map["profile_image"]
     isActive           <-  map["is_active"]
     vertificationCode  <-  map["verification_code"]
     username           <-  map["username"]
  }
  
  
}

//======== Pagination  =========

class Pagination:Mappable{
  
  var totalCount: Int?
  var pageCount: Int?
  var page: Int?
  var limit: Int?
  
  required init?(map: Map) {}
  
  private init(){}

  static let shareInstance = Pagination()
  
  func mapping(map: Map) {
    
    totalCount  <-  map["totalCount"]
    pageCount   <-  map["pageCount"]
    page        <-  map["page"]
    limit       <-  map["limit"]
    
  }
  
}


