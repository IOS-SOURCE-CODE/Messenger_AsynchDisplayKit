//
//  PeopleChatAPIPresenter.swift
//  MessengerUI
//
//  Created by Hiem Seyha on 4/24/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation

/*
 ============================
  PeopleView Controller
 ============================
 */

//MARK: =========== PROTOCOL WORK WITH SERVICE ===========
protocol PeopleAPIManagerPresnterProtocol {
  func reponseDataFromAPIService(data:[Friend])
  func responsePeopleFromAPIService(data:[Friend])
}


//MARK: ===========  WORK WITH CLIENT ===========
class PeopleAPIPresenter:PeopleAPIManagerPresnterProtocol {

  
  //Properties
  var delegate:PeopleAPIPresenterProtocol?
  var APIManager = PeopleChatAPIManager()

  
  init(delegate:PeopleAPIPresenterProtocol) {
    self.delegate = delegate
    APIManager.delegatePeople = self
  }
  
  // Request from client
  func getUsers(userID:Int) {
    
    APIManager.requestFriends(userID:userID)
    
  }
  
  // Search Poeple
  func searchPeople(name:String) {
    
    APIManager.searchByPoepleName(name: name)
  }
  
  // notify from service
  func reponseDataFromAPIService(data: [Friend]) {
    guard !(data.isEmpty) else {
      delegate?.reponseData(data: [])
      return
    }
    delegate?.reponseData(data: data)
  }
  
  func responsePeopleFromAPIService(data: [Friend]) {
    delegate?.responseDataPeopleSearch(data: data)
    
  }
  
}

//====== PROTOCOL WORK WITH CLIENT ============

protocol PeopleAPIPresenterProtocol {
  
  func reponseData(data:[Friend])
  func responseDataPeopleSearch(data:[Friend])
  
}

//make optional protocol
extension PeopleAPIPresenterProtocol {
  
  func reponseData(data:[Friend]){}
  func responseDataPeopleSearch(data:[Friend]){}
}

/*
 
 ============================
  Chat View Controller
 ============================
 
 */

//MARK: =========== PROTOCOL WORK WITH SERVICE ===========
protocol ChatAPIServiceProtocol {
  func responseDataFromService(data:[Message], roomID:Int)
}

// MAIN PRESENTER
class ChatAPIPresenter:ChatAPIServiceProtocol {
  //Propeties
  var delegate: ChatAPIPresenterProtocol?
  var APIManager = PeopleChatAPIManager()
 
  //Request from client
//  func requestData(roomID:Int, page:Int, limit:Int) {
//    APIManager.delegateChat = self
//    APIManager.getMessageChat(userID: 0, participantID: 0, page: 0, limit: 0)
//  }
  
  func getMessage(userID:Int, participantID:Int, page:Int,limit:Int) {
    
    APIManager.delegateChat = self
    APIManager.requestMessages(userID: userID, participantID: participantID, page: page, limit: limit)
  }
  
  // notify from service
  func responseDataFromService(data: [Message], roomID:Int) {
    print("responseDataFromService presenter")
    guard !(data.isEmpty) else {
      delegate?.responseData(data: [], roomID:roomID)
      return
    }
    delegate?.responseData(data: data, roomID:roomID)
  }
}



//====== PROTOCOL WORK WITH CLIENT ============
protocol ChatAPIPresenterProtocol {
  func responseData(data:[Message], roomID:Int)
}

// ========== Closure Style ========
class PeopleAPIClosure {
  
  let APIManager = PeopleChatAPIManager()
  
  func checkRoom(userID:Int, participantID:Int, completion: @escaping (_ result:Bool, _ roomID:Int) -> ()) {
    
    print("PeopleAPICloseure")
    APIManager.checkRoom(userID: userID, participantID: participantID) { (result, roomID) in
      print("completed", roomID)
      completion(result, roomID)
    }
    
  }
}
