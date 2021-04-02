//
//  DiseaseSubCourse.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/20.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
 
import ObjectMapper

struct DiseaseSubCourse : Mappable {
   
   var subId = ""
   var subName = ""
 
   init?(map: Map) {
       
   }
   init?() {
       
   }
   mutating func mapping(map: Map) {
    subId <- map["subId"]
    subName <- map["subName"]
   }
}
