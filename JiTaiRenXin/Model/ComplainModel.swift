//
//  ComplainModel.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/08/20.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
struct ComplainModel : Mappable {
    
    var id = -1
    var reporter_id = -1
    var obj_id = -1
    var comment_id = -1
    var report_type = -1
    var created_at:Double = 0
    var updated_at = ""
    var reply = ""
    var status = 0
    var categories = ""
    var reason = ""
    var reporter_name = ""
 
    var user = UserModel()
    var publisher = Publisher() //发布者信息
    var article = ArticleModel()
    var reports = CaseModel()
    var video = videoModel()
    
    
    var avatar = ""
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        id <- map["id"]
        reporter_id <- map["reporter_id"]
        obj_id <- map["obj_id"]
        comment_id <- map["comment_id"]
        
        report_type <- map["report_type"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        reply <- map["reply"]
        
        categories <- map["categories"]
        reason <- map["reason"]
        reporter_name <- map["reporter_name"]
        user <- map["user"]
        
        publisher <- map["publisher"]
        article <- map["articles"]
        reports <- map["articles"]
        video <- map["articles"]
        
    }
}
