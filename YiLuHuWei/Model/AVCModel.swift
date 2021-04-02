//
//  ArticleModel.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/08/06.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper

struct AVCModel : Mappable {
    
    var id = 0 //编号
    var post_title = "" //标题
    var post_excerpt = "" //简介
    var obj_type = 0 //1文章 2视频 3病例
    var source = "" //来源
    var source_link = "" //来源地址
    var group_id = -1 //栏目ID
    var thumbnail = "" //缩略图
   //more{thumbnail photos { url name}}
 
    var create_time:Double = 0 //创建时间
    var published_time:Double = 0 //发布时间
    var updated_time:Double = 0 //更新时间
    var post_hits = 0 //点击量
    var post_favorites = 0 //收藏量
    var post_like = 0 //点赞量
    var comment_count = 0 //评论量
    
    var category_id = -1
    var user_login = ""
    var user_nickname = "" //发布者昵称
    var user_email = ""
    var avatar = ""
    var user_realname = "" //医生名称
    var hospital = "" //医院
    var professional_id = -1
    var check_status = 0
    var group_name = "" //发布者昵称
    var group_img = ""
    var avatar_url = "" //发布者昵称
    var category_name = ""
    var professional_name = -1
    
    var is_collect = 0 //是否收藏 1是 0不是
    var is_like = 0//是否点赞 1是 0不是
    var show_type = 0 //展示类型 0无图 1一张图 2三张图 去imageList的前三张
    var more = ImageModel()
    var publish_name = "" //管理员名
    var web_url = "" //详情web地址
    
    var url = "" //详情web地址
    var is_report = 0 //
    
    var description = "" //
    var table_name = ""
    
    //格式化后的量
    var format_post_hits = "" //
    var format_post_favorites = "" //
    var format_post_like = "" //
    var format_comment_count = "" //
    
    //视频单独有
    var video_id = "" //
    var video_time = "" //
    var excerpt = "" //
    
    
    //文章单独有
    var collection = "" //
    var title = "" //
    var content = "" //
    
    //纯文字内容的时候，把文字高度计算好
    var contentHeight:CGFloat = 0
  
    //评论处要用的发文章的人的信息
    
    var user_id = 0
    
    
    var post_status = 0
    
    var users = UserModel()
    
    
    mutating func mapping(map: Map) {
 
        users <- map["users"]
        post_status <- map["post_status"]
        
        table_name <- map["table_name"]
        description <- map["description"]
        excerpt <- map["excerpt"]
        
        user_id <- map["user_id"]
        id <- map["id"]
        post_title <- map["post_title"]
        post_excerpt <- map["post_excerpt"]
        obj_type <- map["obj_type"]
        source <- map["source"]
        source_link <- map["source_link"]
        group_id <- map["group_id"]
        thumbnail <- map["thumbnail"]
        more <- map["more"]
        
        create_time <- map["create_time"]
        published_time <- map["published_time"]
        updated_time <- map["updated_time"]
        post_hits <- map["post_hits"]
        post_favorites <- map["post_favorites"]
        post_like <- map["post_like"]
        category_id <- map["category_id"]
        user_login <- map["user_login"]
        user_nickname <- map["user_nickname"]
        user_email <- map["user_email"]
        avatar <- map["avatar"]
        user_realname <- map["user_realname"]
        hospital <- map["hospital"]
        professional_id <- map["professional_id"]
        check_status <- map["check_status"]
        group_name <- map["group_name"]
        group_img <- map["group_img"]
        avatar_url <- map["avatar_url"]
 
        category_name <- map["category_name"]
        professional_name <- map["professional_name"]
        comment_count <- map["comment_count"]
        is_collect <- map["is_collect"]
        is_like <- map["is_like"]
        show_type <- map["show_type"]

        publish_name <- map["publish_name"]
        web_url <- map["web_url"]

        video_id <- map["video_id"]
        video_time <- map["video_time"]
        
        
        format_post_hits <- map["format_post_hits"]
        format_post_favorites <- map["format_post_favorites"]
        format_post_like <- map["format_post_like"]
        format_comment_count <- map["format_comment_count"]
        
        collection <- map["collection"]
        title <- map["title"]
        content <- map["content"]
  
        url <- map["url"]
        is_report <- map["is_report"]
        
         
     }
      init?(map: Map) {
          
      }
      init?() {
          
      }
}
