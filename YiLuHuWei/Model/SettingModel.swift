//
//  SettingModel.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/02/08.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper

struct SettingModel : Mappable {
   
   var url = ""
   var daren_content = ""
    
   var privacy_content = ""
 

   init?(map: Map) {
       
   }
   init?() {
       
   }
   mutating func mapping(map: Map) {
     url <- map["url"]
    daren_content <- map["daren_content"]
    privacy_content <- map["privacy_content"]
    
   }
}
