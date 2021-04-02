//
//  hotWord.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/08/21.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper

struct HotWord : Mappable {
    
 
    var id = 0
    var title = ""
    var stime = ""
    var ctime = ""
    
    var num = 0
    var fid = 0
    var table = ""
    
 
 
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        stime <- map["stime"]
        ctime <- map["ctime"]
        num <- map["num"]
        fid <- map["fid"]
        table <- map["table"]
    }
}
