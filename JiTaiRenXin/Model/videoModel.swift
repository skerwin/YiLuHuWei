//
//  videoModel.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/06.
//  Copyright © 2020 gansukanglin. All rights reserved.
//
 
import UIKit
import ObjectMapper
struct videoModel : Mappable {
    var id = -1 //编号
    var title = "" //标题
    var obj_type = 0 //1文章 2视频 3病例
    var source = "" //来源
    var source_link = "" //来源地址
    var user_type = -1 //
    var user_id = -1
    var img_id = -1
    var images = ""
    var desc = ""  //简介
    var content = "" //内容
    var status = -1 //
    var is_top = 0 //是否置顶 1是 0不是
    var recommended = 0 //是否推荐 1是 0不是
    var list_order = -1  //排序
    var hits = 0 //点击量
    var likes = 0 // 点赞量
    var collects = 0 //收藏量
    var comments = 0 //评论量
    var created_at:Double = 0 //创建时间
    var updated_at:Double = 0 //更新时间
    var published_at:Double = 0 //发布时间
    var group_id = -1 //栏目ID
    var is_collect = 0 //是否收藏 1是 0不是
    var is_like = 0//是否点赞 1是 0不是
    var show_type = 0 //展示类型 0无图 1一张图 2三张图 去imageList的前三张
    var img_url = "" //一张图片是时的地址
    var image_list = [ImageModel]()
    var publish_name = "" //管理员名
   // var extend_info = Dictionary<String, AnyObject>()
    var cat_ids = [Int]()
    var web_url = "" //详情web地址
   
    var publisher = Publisher() //发布者信息
    var groups = Dictionary<String, AnyObject>() //栏目信息
    
    var videoInfoModel = VideoInfoModel()
  
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        obj_type <- map["obj_type"]
        source <- map["source"]
        source_link <- map["source_link"]
        user_type <- map["user_type"]
        user_type <- map["user_type"]
        img_id <- map["img_id"]
        images <- map["images"]
        desc <- map["desc"]
        content <- map["content"]
        status <- map["status"]
        is_top <- map["is_top"]
        recommended <- map["recommended"]
        list_order <- map["list_order"]
        hits <- map["hits"]
        likes <- map["likes"]
        collects <- map["collects"]
        comments <- map["comments"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        published_at <- map["published_at"]
        group_id <- map["group_id"]
        is_collect <- map["is_collect"]
        is_like <- map["is_like"]
        show_type <- map["show_type"]
        
        image_list <- map["image_list"]
        publish_name <- map["publish_name"]
        videoInfoModel <- map["extend_info"]
        cat_ids <- map["cat_ids"]
        web_url <- map["web_url"]
        
        img_url <- map["img_url"]
        publisher <- map["publisher"]
        groups <- map["groups"]
 
     }
      init?(map: Map) {
          
      }
      init?() {
          
      }
}
