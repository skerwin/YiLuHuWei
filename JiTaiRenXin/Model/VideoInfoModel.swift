//
//  VideoInfoModel.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/11/12.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import Foundation
import ObjectMapper

struct VideoInfoModel : Mappable {
    
 
    var video_time = ""
    var video_id = -1
    var video_url = ""
    var article_id = -1
 
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        video_time <- map["video_time"]
        video_id <- map["video_id"]
        video_url <- map["video_url"]
        article_id <- map["article_id"]
    }
}
