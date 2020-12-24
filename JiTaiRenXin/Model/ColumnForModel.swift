//
//  ColumnForModel.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/12.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper

struct ColumnForModel : Mappable {
    
    var desc = ""
    var id = -1
    var name = ""
    
    var img_id = 1
    var is_collect = 0 //0未关注 已关注
    var img_url = ""
 
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        desc <- map["desc"]
        id <- map["id"]
        name <- map["name"]
    
        img_id <- map["img_id"]
        is_collect <- map["is_collect"]
        img_url <- map["img_url"]
    }
}
