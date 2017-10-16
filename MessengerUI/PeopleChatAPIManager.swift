//
//  PeopleChatAPIManager.swift
//  MessengerUI
//
//  Created by Hiem Seyha on 4/24/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import RealmSwift
import SocketIO

class PeopleChatAPIManager {
  
  // delegate to notify back to presenter
  var delegatePeople:PeopleAPIManagerPresnterProtocol?
  var delegateChat:ChatAPIServiceProtocol?
  
  // ========== Get all user =============
  func requestFriends(userID:Int) {
    
    print("getFriendByUser API", URL_CHAT + GET_FRIEND + "\(userID)")
    
    Alamofire.request(URL_CHAT + GET_FRIEND + "\(userID)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseArray(queue: nil, keyPath: "data", context: nil){ (response:DataResponse<[Friend]>) in
      
      print("getFriendByUser", URL_CHAT + GET_FRIEND)
      if let data = response.result.value {
        
        // Notify Data Success
        self.delegatePeople?.reponseDataFromAPIService(data: data)
        
      } else {
        
        self.delegatePeople?.reponseDataFromAPIService(data: [])
        print("Faild To Loading News")
        
      }
      
      print("getFriendByUser", URL_CHAT + GET_FRIEND)
    }

  } // endgetFriendByUserID
  
  // ======== Get Message Chat ===============
  func requestMessages(userID:Int, participantID:Int, page:Int, limit:Int){
    
    // URL CONNECTION
    let url = URL_CHAT + GET_CHAT_MESSAGE + "\(userID)" + "/\(participantID)" + "/\(page)" + "/\(limit)"
    print("url=====>", url)
    
    Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
      
      if let data = response.result.value as? [String:Any] {
        
        if let successs = data["code"] as? String, successs == "200" {
          
          // Set Pagination
          if let pagination = data["Pagination"] as? [String:Int] {
            
            Pagination.shareInstance.limit = pagination["limit"]
            Pagination.shareInstance.page = pagination["page"]
            Pagination.shareInstance.pageCount = pagination["pageCount"]
            Pagination.shareInstance.totalCount = pagination["totalCount"]
            
            if Pagination.shareInstance.page != nil {
              
              self.savePagination()
            }
            
          }
          
          
          // Get Messages
          var myMessages:[Message] = []
          if let messages = data["data"] as? [Any] {
            
            for message in messages {
              myMessages.append(Message(JSON: message as! [String:Any])!)
            }
            
            print("MESSAGE FROM API", myMessages.count)
            //Get RoomID
            let roomID = data["room_id"] as! Int
          
            print("RoomID FROM SERVICE=========>", roomID)
            
            // Notify to presenter
            self.delegateChat?.responseDataFromService(data: myMessages, roomID: roomID)

          }
        }
       
      } else {
        print("========= Nothing happen ==========")
        // Notify to presenter
        self.delegateChat?.responseDataFromService(data: [], roomID: 0)
        
      }
      
    } // end alamofire
  } // end getMessageChat
  
  // ======== Get Message Chat ===============
  func checkRoom(userID:Int, participantID:Int, completion: @escaping (_ result:Bool, _ roomID:Int)->()) {
    
    print("checkRoom")
    let url = URL_CHAT + CHECK_ROOM + "\(userID)" + "/\(participantID)"
    Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { response in
    
    
      if let result = response.result.value as? [String:Any] {
     
        if result["code"] as! String == "200" {
          print("Hello checking room ", result)
           completion(true, result["room_id"] as! Int)
           return
          
        } else {
          
          print("========== No Room ==============")
          self.createRoomChat(users: [userID, participantID], completion: { (result, roomID) in
            
            print("result===>", result)
            completion(result, roomID)
            
          })
          
        }
        
      }
    }
    
  }
  
  // createRoomChat
  func createRoomChat(users:[Int], title:String = "", completion:@escaping (_ result:Bool, _ roomID:Int) ->()) {
    
    // Paramenter
    let param: Parameters = [
        "user_id":users ,
        "title":title
    ]
    
    // Set Header
    let header: HTTPHeaders = [
      "Content-Type":"application/json"
    ]
    
    Alamofire.request(URL_CHAT + CREATE_ROOM, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
      
      if let result = response.result.value as? [String:Any] {
        if result["code"] as! String == "200" {
          completion(false, result["room_id"] as! Int)
        }
      }
    }
  }
  
  // Search people
  
  func searchByPoepleName(name:String) {
    
    let url = URL_CHAT + SEARCH_PEOPLE + name
    
    print("url=====>", url)
    
    Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseArray(queue: nil, keyPath: "data", context: nil){ (response:DataResponse<[Friend]>) in
      
      if let data = response.result.value {
      
        self.delegatePeople?.responsePeopleFromAPIService(data: data)
        
      } else {
        
        self.delegatePeople?.responsePeopleFromAPIService(data: [])
        print("Faild To People")
      }
      
    }

  }
  
  // ========= Save Pagination ========
  func savePagination() {
    
    let realm = try? Realm()
    
    if (realm?.objects(StorePagination.self).count)! > 0 {
      try! realm?.write {
        realm?.deleteAll()
      }
    }
    
    //save
    let temp = StorePagination()
    temp.limit = Pagination.shareInstance.limit!
    temp.page = Pagination.shareInstance.page!
    temp.pageCount = Pagination.shareInstance.pageCount!
    temp.totalCount = Pagination.shareInstance.totalCount!
    
    try! realm?.write {
      
      realm?.add(temp)
    }
  }
}
