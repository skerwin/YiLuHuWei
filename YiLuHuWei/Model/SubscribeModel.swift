//
//  SubscribeModel.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/22.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
 
import ObjectMapper

struct SubscribeModel : Mappable {
    
    var id = 0
    var name = "" //名称
    var cover = "" //封面图
    var post_content = "" //内容
    var change_time = "" //
    var is_collect = 0 //是否收藏
    
 
 
    var parent_id = 0
 
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        
        cover <- map["cover"]
        post_content <- map["post_content"]
        
        change_time <- map["change_time"]
        is_collect <- map["is_collect"]
        
        parent_id <- map["parent_id"]
 
    }
}
