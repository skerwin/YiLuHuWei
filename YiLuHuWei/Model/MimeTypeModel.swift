//
//  MimeModelType.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/11/17.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct MimeTypeModel: Mappable {
 
    
    
    var id = -1
    var user_id = -1
  
    
    var obj_id = -1
    
    var created_at:Double = 0
    var updated_at = ""
    var article = AVCModel()
    var reports = AVCModel()
    var video = AVCModel()
    
 
 
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        obj_id <- map["obj_id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        article <- map["articles"]
        reports <- map["articles"]
        video <- map["articles"]
     }
}
