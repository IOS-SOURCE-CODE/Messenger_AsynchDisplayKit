//
//  UserDefault.swift
//  MessengerUI
//
//  Created by MacBook Pro on 5/2/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import Foundation

class SessionManager {
    
    static let sharedInstance = SessionManager()
    var userDefault = UserDefaults.standard
    
    func setUserSession(_ user_id : Int) {
        userDefault.set(user_id, forKey: "id")
        print("=====This is user defualt in func======",userDefault.string(forKey: "id"))
    }
    
    func getUserSession() -> Int {
        let i = userDefault.integer(forKey: "id")
        return i
    }
    
    func clearUserSession() {
        userDefault.set(0, forKey: "id")
    }
}



