//
//  DiseaseCourse.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/20.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper

struct DiseaseCourse : Mappable {
    
    var typeName = ""
    var typeId = ""
    var subList = [DiseaseSubCourse]()
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
     typeName <- map["typeName"]
     subList <- map["subList"]
     typeId <- map["typeId"]
     
    }
}
