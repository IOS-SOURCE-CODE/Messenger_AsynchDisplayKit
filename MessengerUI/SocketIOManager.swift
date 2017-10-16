//
//  SocketIOManager.swift
//  MessengerUI
//
//  Created by Hiem Seyha on 4/25/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
  
  static let sharedInstance = SocketIOManager()
  
//  var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://192.168.17.50:3000/api/v1/message/add")!)
  let socket = SocketIOClient(socketURL: URL(string: URL_CHAT + "message/add")!, config: [.log(true), .forcePolling(true)])

  
  override init() {
    super.init()
  }
  
  func establishConnection() {
    socket.connect()
  }
  
  func closeConnection() {
    socket.disconnect()
  }
  
  // ===== Sending Message =====
  func sendMessage(event:String, message:String, pariticipantID:Int, roomID:Int) {
    print("== ==== == = Emit Message==== == = = = ======")
    
    let myData:[String:Any] = ["messages" : message,"participants_id": pariticipantID, "room_id":roomID]
    print("myData", myData)
    
    socket.emit(event, myData)
    
  }
  
  // ===== Get Message =====
  func getChatMessage(event:String, completion: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
    
    socket.on(event) { (dataArray, socketAck) -> Void in
      
      var messageDictionary = [String: AnyObject]()
      
      messageDictionary["messages"] = (dataArray[0] as! Dictionary)["messages"]!
      messageDictionary["participants_id"] = (dataArray[0] as! Dictionary)["participants_id"]!
      messageDictionary["room_id"] = (dataArray[0] as! Dictionary)["room_id"]!
      
      print("getChatMessage", messageDictionary)
      print("get participant Id", messageDictionary["participants_id"])
      completion(messageDictionary)
    }
  }
  
}























