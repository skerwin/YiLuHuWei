//
//  DiseaseListModel.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/21.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper

struct DiseaseListModel: Mappable {
    
    var subTypeName = ""
    var summary = ""
    var id = ""
    var subTypeId = ""
    var typeName = ""
    var name = ""
    var typeId = ""
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    
    
    mutating func mapping(map: Map) {
        subTypeName <- map["subTypeName"]
        summary <- map["summary"]
        id <- map["id"]
        subTypeId <- map["subTypeId"]
        typeName <- map["typeName"]
        name <- map["name"]
        typeId <- map["typeId"]
        
     
    }
 }
