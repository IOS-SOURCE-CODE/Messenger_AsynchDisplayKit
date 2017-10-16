//
//  UtilityPresenter.swift
//  MessengerUI
//
//  Created by Hiem Seyha on 5/5/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation


protocol PeoplePresenterProtocol {
  
  func recieveData(data:Friend)
  
}

class PeoplePresenter {
  
  var delegate: PeoplePresenterProtocol?
  
  func reciveDataFromResultSeach(data:Friend) {
    print("<<<<<<<<<< reciveDataFromResultSeach")
//    let peopleHome = PeopleViewController()
//    peopleHome.resultDelegate = self
//    delegate?.recieveData(data: data)
    
  }
  
}





