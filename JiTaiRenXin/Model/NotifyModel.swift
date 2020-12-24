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
    
 
    var id = -1
    var title = ""
    var message_type = -1
    var send_id = -1
    var content = ""
    var created_at:Double = 0
    var updated_at:Double = 0
    var read_num = 0
    var message_type_name = ""
    var admin = Publisher() //发布者信息
    
    var published_at:Double = 0
    var web_url = ""
   
    
 
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        message_type <- map["message_type"]
        send_id <- map["send_id"]
        content <- map["content"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        read_num <- map["read_num"]
        message_type_name <- map["message_type_name"]
        admin <- map["admin"]
        published_at <- map["published_at"]
        web_url <- map["web_url"]
     }
}
