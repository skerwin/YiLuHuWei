//
//  PerAVCModel.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/28.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
 
import ObjectMapper

struct PerAVCModel : Mappable {
    
    var thumbnail = ""
    var description = ""
    var url = "" //内容
    var user_id = 0
    var table_name = ""
    
    var title = ""
    var create_time = 0.0
    var is_collect = 0
    var id = 0
    var object_id = 0
    
    
    var articles = AVCModel()
    var videos = AVCModel()
    var cases = AVCModel()
    
     
    
    //举报列表用的字段
    var reporter = 0
    var post_id = 0
    var report_type = 0
    var publisher = 0
    var report_time = 0.0
    var status = 0
    var categories = 0
    
    var reason = ""
    var categories_name = ""
 
    var comments = CommentModel()

    
    
 
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        
        videos <- map["videos"]
        cases <- map["cases"]
        
        reporter <- map["reporter"]
        post_id <- map["post_id"]
        report_type <- map["report_type"]
        publisher <- map["publisher"]
        description <- map["description"]
        report_time <- map["report_time"]
        status <- map["status"]
        categories <- map["categories"]
        reason <- map["reason"]
        categories_name <- map["categories_name"]
        comments <- map["comments"]
        
        
        thumbnail <- map["thumbnail"]
        description <- map["description"]
        url <- map["url"]
        
        user_id <- map["user_id"]
        table_name <- map["table_name"]
        
        title <- map["title"]
        create_time <- map["create_time"]
        is_collect <- map["is_collect"]
        id <- map["id"]
        object_id <- map["object_id"]
        articles <- map["articles"]
        
    }
}
