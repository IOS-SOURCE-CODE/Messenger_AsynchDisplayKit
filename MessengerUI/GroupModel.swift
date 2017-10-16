//
//  GroupModel.swift
//  MessengerUI
//
//  Created by Mean Reaksmey on 4/20/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import ObjectMapper

class GroupModel{
    
    var groupName:String?
    var status:String?
    var member = ""
    var imageGroup = [String]()
    
    init(json:JSON) {
        
        groupName = "\(json["name"])"
        status = "\(json["status"])"
        
        // add name to member of group
        var i = 0
        
        innerLoop: for item in json["photo"] {
            print("photo: ",item)
            imageGroup.append("\(item.1)")
            i += 1
            if i > 2{  break innerLoop }
        }
        
        i = 0
        
        for item in json["member"] {
            member += "\(item.1)"
            i += 1
            if i > 2{ return }
            member += ", "
        }
    }
}

class GroupModelMapper: Mappable {
    
    var status = Int()
    var id = Int()
    var title = ""
    var userID = Int()
    var createAt:String?
    var updatedAt:String?
    var images = [String]()
    var members = ""
    var day = Int()
    var profile = ""
    
    fileprivate var member = [String]()
    fileprivate var imageGroup = [String]()
    
    
    required init?(map: Map){
        
    }
    
    required init?(){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        userID <- map["user_id"]
        title <- map["title"]
        createAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        imageGroup <- map["profile"]
        status <- map["status"]
        imageGroup <- map["member_profile"]
        member <- map["usermember"]
        day <- map["day"]
        profile <- map["profile"]
        
        
        print("imageGroup: ",member)
        
        
        //        // add name to member of group
        var i = 0
        //
        if profile.isEqual(""){
            images = []
            innerLoop: for item in imageGroup {
                // print("photo: ",item)
                images.append("\(item)")
                i += 1
                if i > 2{  break innerLoop }
            }
        }else{
            images = [profile]
            print("image profile: ",images)
            
        }
        
        i = 0
        
        for item in member {
            members += "\(item)"
            i += 1
            if i > 2{ return }
            members += ", "
        }
        
        print("======>syring",members)
        
    }
    
}


class Forecast: Mappable {
    var day: String?
    var temperature: Int?
    var conditions: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        day <- map["day"]
        temperature <- map["temperature"]
        conditions <- map["conditions"]
    }
}


