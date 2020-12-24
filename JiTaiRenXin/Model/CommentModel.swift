//
//  commentModel.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/08/12.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper

struct CommentModel: Mappable {
    
    var id = -1
    var parent_id = -1
    var user_id = -1
    var obj_id = -1
    var created_at:Double = -1
    var content = ""
    var child_list = [CommentModel]()
    var parent_user = UserModel()
    var objs = Dictionary<String, AnyObject>()
    var users = UserModel()
    
  
    
  
    
 
    init?(map: Map) {
           
    }
    init?() {
           
    }
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        parent_id <- map["parent_id"]
        user_id <- map["user_id"]
        
        obj_id <- map["obj_id"]
        created_at <- map["created_at"]
        content <- map["content"]
        
        child_list <- map["child_list"]
        objs <- map["objs"]
        users <- map["users"]
        
        parent_user <- map["parent_user"]
    }
 

}
