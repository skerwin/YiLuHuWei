//
//  adverModel.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/10.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

import ObjectMapper

struct adverModel : Mappable {
    
    var id = 0
    var slide_id = 0
    var status = 0
    var list_order = 0
    var image = 0
  
    
    var title = ""
    var url = "" //跳转地址
    var description = ""
    var content = ""
    var image_url = ""  //图片地址
 
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        slide_id <- map["slide_id"]
        status <- map["status"]
        list_order <- map["list_order"]
        image <- map["image"]
        
        title <- map["title"]
        url <- map["url"]
        description <- map["description"]
        content <- map["content"]
        image_url <- map["image_url"]
    }
}
