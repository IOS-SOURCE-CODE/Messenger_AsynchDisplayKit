//
//  StoreMessageModel.swift
//  MessengerUI
//
//  Created by Hiem Seyha on 4/25/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import RealmSwift

class StoreMessage:Object {
  
  dynamic var id: String = NSUUID().uuidString
  dynamic var messages = ""
  dynamic var participantsID = 0
  dynamic var userID = 0
  dynamic var roomID = 0
  dynamic var profileImage = ""
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
}

class RoomID: Object {
  
  dynamic var roomID = 0
}

class StorePagination: Object {
  
  dynamic var id: String = NSUUID().uuidString
  dynamic var totalCount = 0
  dynamic var pageCount = 0
  dynamic var page = 0
  dynamic var limit = 0
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
}
