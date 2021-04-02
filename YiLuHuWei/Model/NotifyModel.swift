//
//  NotifyModel.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/08/15.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper

struct NotifyModel : Mappable {
    
 
    var id = 0
   
//    var message_type = -1
//    var send_id = -1
//
//    var created_at:Double = 0
//    var updated_at:Double = 0
//    var read_num = 0
//    var message_type_name = ""
//
//    var published_at:Double = 0
    var web_url = ""
    
 
    var is_lock:Double = 0
    var publish_time:Double = 0
    var title = ""
    var content = ""
    var update_time:Double = 0
    var sender = ""
    var hits = 0
    var create_time:Double = 0
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        is_lock <- map["is_lock"]
        publish_time <- map["publish_time"]
        content <- map["content"]
        update_time <- map["update_time"]
        sender <- map["sender"]
        hits <- map["hits"]
        create_time <- map["create_time"]
        web_url <- map["web_url"]
     }
}
