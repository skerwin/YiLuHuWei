//
//  UserModel.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/08/13.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper

struct UserModel: Mappable {
    
    var id = 0
    var name = ""
    var email = ""
    var mobile = ""
    var avatar = ""
    var nickname = ""
    var realname = ""
    var avatar_url = ""
    var sex = 0
    var status = 0
    
    var password = ""
    
    
    var avatar_id = 0 //传参数需要
    var doctorModel = DoctorModel()
    
//    var hospital = ""
//    var departments = ""
//    var jobtitle = ""
//    var breastplate = ""
//    var physicianmedicallicence = ""
//
//
//    var adzoneId = 0
//    var loginfailure = ""
//    var prevtime = ""
//    var ischeck = 0
    var token = ""
    
    init?(map: Map) {
           
    }
    init?() {
           
    }
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        nickname <- map["nickname"]
        realname <- map["realname"]
        avatar <- map["avatar"]
        sex <- map["sex"]
        mobile <- map["mobile"]
        token <- map["token"]
        avatar <- map["avatar"]
        avatar_url <- map["avatar_url"]
        doctorModel <- map["extend_info"]
        password <- map["password"]
    }
}
