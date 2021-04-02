//
//  PhotoInfoModel.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/22.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
 
import ObjectMapper

struct PhotoInfoModel : Mappable {
    
    var url = ""
    var name = ""
 
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
    
        url <- map["url"]
        name <- map["name"]
    }
}
