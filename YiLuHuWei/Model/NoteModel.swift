//
//  NoteModel.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/02/01.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
 
import ObjectMapper

struct NoteModel : Mappable {
    
    var id = 0
    var user_id = 0 //封面图
    var group_id = 0
    
    var images = "" //baiti
    var content = "" //baiti
    var create_time = 0.0 //baiti
    var update_time = 0.0 //baiti
    var group_name = "" //baiti
    
    var status = 0
    var title = "" //baiti
    
    
 
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        group_id <- map["group_id"]
        images <- map["images"]
        content <- map["content"]
        
        id <- map["id"]
        create_time <- map["create_time"]
        update_time <- map["update_time"]
        group_name <- map["group_name"]
        status <- map["status"]
        title <- map["title"]
        
    }
}
