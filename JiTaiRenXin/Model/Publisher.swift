//
//  Publisher.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/11/06.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper

struct Publisher : Mappable {
    
    var name = ""
    var avatar_url = ""
    var title = ""
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        name <- map["name"]
        avatar_url <- map["avatar_url"]
        title <- map["title"]
     
    }
}
