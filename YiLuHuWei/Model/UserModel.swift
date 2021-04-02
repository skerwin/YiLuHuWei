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
    var mobile = ""
    var avatar = ""
    var sex = 0
    var password = ""
    var balance = ""
    var create_time = 0.0
    var user_status = 0.0
    var user_login = ""
    var user_nickname = ""
    var user_email = ""
    var user_realname = ""
    var hospital = ""
    var department_id = 0
    var professional_id = 0
    var qualification_type = 0
    var qualifications = 0
    var qualifications_two = 0
    var id_card = ""
    var check_status = 0
    var reasons = ""
    var user_follow_count = 0
    var user_fans_count = 0
    var msg_count = 0
    var record_count = 0
    var like_count = 0
    var need_pwd = 0
    var avatar_url = ""
    var department_text = ""
    var professional_text = ""
    var qualifications_url = ""
    var qualificationstwo_url = ""
    var token = ""
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        mobile <- map["mobile"]
        avatar <- map["avatar"]
        sex <- map["sex"]
        token <- map["token"]
        avatar <- map["avatar"]
        avatar_url <- map["avatar_url"]
        password <- map["password"]
        balance <- map["balance"]
        create_time <- map["create_time"]
        user_status <- map["user_status"]
        user_login <- map["user_login"]
        user_nickname <- map["user_nickname"]
        user_email <- map["user_email"]
        hospital <- map["hospital"]
        department_id <- map["department_id"]
        professional_id <- map["professional_id"]
        qualification_type <- map["qualification_type"]
        qualifications <- map["qualifications"]
        id_card <- map["id_card"]
        check_status <- map["check_status"]
        reasons <- map["reasons"]
        user_follow_count <- map["user_follow_count"]
        user_fans_count <- map["user_fans_count"]
        msg_count <- map["msg_count"]
        record_count <- map["record_count"]
        like_count <- map["like_count"]
        need_pwd <- map["need_pwd"]
        department_text <- map["department_text"]
        professional_text <- map["professional_text"]
        token <- map["token"]
        qualifications_url <- map["qualifications_url"]
        qualificationstwo_url <- map["qualificationstwo_url"]
        user_realname <- map["user_realname"]
    }
    
    
    
    
    init?(map: Map) {
           
    }
    init?() {
           
    }
}
