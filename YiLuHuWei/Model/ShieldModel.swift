//
//  ShieldModel.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/02/08.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
 
import ObjectMapper

struct ShieldModel : Mappable {
    
    var comment_id = 0
    var id = 0
    var member_id = 0
    var create_time = 0.0
    var update_time = 0.0
 
    var comments = CommentModel()

 
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        
        comment_id <- map["comment_id"]
        id <- map["id"]
        member_id <- map["member_id"]
        create_time <- map["create_time"]
        update_time <- map["update_time"]
        comments <- map["comments"]
    }
}
