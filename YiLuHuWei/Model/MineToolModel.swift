//
//  MineToolModel.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/08/13.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper

struct MineToolModel : Mappable {
    
 
    var id = 0
    var name = ""
    
    var createtime = ""
    var order = 0
    
    var status = 0
 
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        createtime <- map["createtime"]
        order <- map["order"]
        status <- map["status"]
    }
}
