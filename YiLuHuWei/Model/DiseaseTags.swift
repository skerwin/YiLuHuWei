//
//  DiseaseTagsList.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/21.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
 
import ObjectMapper

struct DiseaseTags : Mappable {
    
    var name = ""
    var content = ""
 
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        name <- map["name"]
        content <- map["content"]
 
    }
}
