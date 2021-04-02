//
//  DoctorModel.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/11/10.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import Foundation
import ObjectMapper

struct DoctorModel: Mappable {
    
    var user_id = 0
    var id_card = ""
    var hospital = "" //医院
    var department_id = -1 //科室id
    var professional_id = -1 //职称id
    var breastplate_id = -1//胸牌图片id
    var certificate_ids = "" //医生证明图片id，多个以逗号分割
    var check_status = 0 //审核状态 1未通过 2审核中 3不通过 4通过
    
    var department_name = "" //科室名称
    var professional_name = "" //职称名称
    var breastplate_url = "" //胸牌图片地址
 
    var certificates = [String]() //胸牌图片地址
    var certificate_urls = [String]() //胸牌图片地址
    
    
    init?(map: Map) {
           
    }
    init?() {
           
    }
    mutating func mapping(map: Map) {
        
        user_id <- map["user_id"]
        id_card <- map["id_card"]
        hospital <- map["hospital"]
        department_id <- map["department_id"]
        professional_id <- map["professional_id"]
        breastplate_id <- map["breastplate_id"]
        certificate_ids <- map["certificate_ids"]
        check_status <- map["check_status"]
        department_name <- map["department_name"]
        professional_name <- map["professional_name"]
        breastplate_url <- map["breastplate_url"]
        
        certificates <- map["certificates"]
        certificate_urls <- map["certificate_urls"]
    }
}
