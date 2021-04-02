//
//  HomeAPI.swift
//  BossJob
//
//  Created by zhaoyuanjing on 2017/12/01.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import Foundation

//static let HomeAllPath = "http://talent.gskanglin.com/api/v2/index/index"
struct HomeAPI {
    
    //广告图
    static let boot_imgPath = "/index/start_page"
    static func boot_imgPathAndParams(type:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        return (boot_imgPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //首页接口
    static let HomePath = "/index/yilu_index"
    static func HomeAllPathAndParams(limit:Int = 10,page:Int = 1) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
        return (HomePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //首页加载更多接口
    static let ArticleRecommendPath = "/index/article_recommend"
    static func ArticleRecommendPathAndParams(page:Int = 1,pageSize:Int = 10) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = pageSize as AnyObject
     
        return (ArticleRecommendPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //根据广告位id获取广告图列表
    static let SlideListPath = "/common/api/slide_list"
    static func SlideListPathPathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (SlideListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
 
    
    //获取注册短信验证码
    static let sendRegisterMessagecodePath = "/common/api/register_send_sms"
    static func sendRegisterMessagecodePathAndParams(mobile: String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["mobile"] = mobile as AnyObject
        return (sendRegisterMessagecodePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    

    
    //手机号+验证注册
    static let sendRegisterPath = "/users/api/registerOne"
    static func sendRegisterPathAndParams(mobile: String,sms_code:String,password:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["mobile"] = mobile as AnyObject
        paramsDictionary["sms_code"] = sms_code as AnyObject
        paramsDictionary["password"] = password as AnyObject
        return (sendRegisterPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //登陆
    static let LoginPath = "/users/api/login"
    static func LoginPathAndParams(mobile: String,password:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["mobile"] = mobile as AnyObject
        paramsDictionary["password"] = password as AnyObject
        return (LoginPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }

    
    //上传图片
    static let imageUploadPath = "/common/api/up_img"
    static func imageUploadPathAndParams() -> PathAndParams {
        let paramsDictionary = Dictionary<String, AnyObject>()
        return (imageUploadPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }

    
    
    //评论黑名单
    static let blackPath = "/comment/api/black"
    static func blackPathAndParams(user_id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        
        //        if let userId = objectForKey(key: Constants.userid) {
        //            paramsDictionary["uid"] = userId as AnyObject
        //        }
        paramsDictionary["user_id"] = user_id as AnyObject
        return (blackPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }

    
    static let ColumnForPath = "/group/api/index"
    static func ColumnForPathAndParams() -> PathAndParams {
        return (ColumnForPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
   
    
    ///////////////////////------------------------////////////////
    
    
    //热门搜索词
    static let HotSearchPath = "/system/hot_search"
    static func HotSearchPathPathAndParams() -> PathAndParams {
        return (HotSearchPath, getRequestParamsDictionary(paramsDictionary:nil))
    }
    
    // 消息详情接口
    static let messagedetailPath = "/user/message_info"
    static func messagedetailPathAndParams(id:Int = 1) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["msg_id"] = id as AnyObject
        
        return (messagedetailPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    // 消息通知接口
    static let messageloadPath = "/user/message_list"
    static func messageloadPathAndParams(pageSize:Int = 10,page:Int = 1) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["limit"] = pageSize as AnyObject
        paramsDictionary["page"] = page as AnyObject
        return (messageloadPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    // 屏蔽内容列表接口
    static let shieldListPath = "/shield/index"
    static func shieldListPathAndParams(pageSize:Int = 10,page:Int = 1) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["limit"] = pageSize as AnyObject
        paramsDictionary["page"] = page as AnyObject
        return (shieldListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    

    //评论屏蔽
    static let shieldPath = "/shield/handle"
    static func shieldPathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (shieldPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //添加意见反馈
    static let feedbackPath = "/feedback/save"
    static func feedbackPathAndParams(content:String,images:String,phone:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        
        paramsDictionary["content"] = content as AnyObject
        paramsDictionary["images"] = images as AnyObject
        paramsDictionary["phone"] = phone as AnyObject
        
        return (feedbackPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //获取找回密码短信验证码
    static let sendFindMessagecodePath = "/login/send"
    static func sendFindMessagecodePathAndParams(user_login: String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["user_login"] = user_login as AnyObject
        return (sendFindMessagecodePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //手机号+验证码找回密码
    static let sendfindPwdCodePath = "/login/password_reset"
    static func sendfindPwdCodePathAndParams(user_login: String,verification_code:String,user_pass:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["user_login"] = user_login as AnyObject
        paramsDictionary["verification_code"] = verification_code as AnyObject
        paramsDictionary["user_pass"] = user_pass as AnyObject
        
        return (sendfindPwdCodePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //退出登陆
    static let logoutAccountPath = "/login/logout"
    static func logoutAccountPathAndParam() -> PathAndParams {
        return (logoutAccountPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    
    //隐私政策
    static let privacyStatement = "/system/get_privacy_settings"
    static func privacyStatementAndParam() -> PathAndParams {
        return (privacyStatement, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    
    //关于我们
    static let aboutUsPath = "/system/get_daren_settings"
    static func aboutUsPathAndParam() -> PathAndParams {
        return (aboutUsPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    
    //举报列表文章病例视频
    static let mineComplainPath = "/report/article"
    static func mineComplainPathAndParams(limit:Int = 10,page:Int = 1,report_type:Int = 1) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        
        paramsDictionary["limit"] = limit as AnyObject
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["report_type"] = report_type as AnyObject
        return (mineComplainPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //举报列表评论
    static let mineComplainCommentPath = "/report/comment"
    static func mineComplainCommentPathAndParams(limit:Int = 10,page:Int = 1) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        
        paramsDictionary["limit"] = limit as AnyObject
        paramsDictionary["page"] = page as AnyObject
        
        return (mineComplainCommentPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //注册医师认证接口
    static let authDoctorPath = "/user/doctor_auth"
    static func authDoctorPathAndParams(usermodel:UserModel) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        
        paramsDictionary["user_realname"] = usermodel.user_realname as AnyObject
        paramsDictionary["sex"] = usermodel.sex as AnyObject
        paramsDictionary["mobile"] = usermodel.mobile as AnyObject
        paramsDictionary["hospital"] = usermodel.hospital as AnyObject
        paramsDictionary["department_id"] = usermodel.department_id as AnyObject
        paramsDictionary["professional_id"] = usermodel.professional_id as AnyObject
        paramsDictionary["qualification_type"] = usermodel.qualification_type as AnyObject
        paramsDictionary["qualifications"] = usermodel.qualifications as AnyObject
        paramsDictionary["qualifications_two"] = usermodel.qualifications_two as AnyObject
        return (authDoctorPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //职称科室列表接口
    static let professionalPath = "/system/depart_pro"
    static func professionalPathAndParams() -> PathAndParams {
        let paramsDictionary = Dictionary<String, AnyObject>()
        return (professionalPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //发布病例
    static let cesesSavePath = "/cases/save"
    static func cesesSavePathAndParams(title:String,group_id:Int,sex:Int,age:String,content:String,collection:String,physique:String,auxiliary:String,diagnosis:String,treatment:String,follow_up:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["title"] = title as AnyObject
        paramsDictionary["group_id"] = group_id as AnyObject
        
        if let userSex = objectForKey(key: Constants.gender) {
            paramsDictionary["sex"] = userSex as AnyObject
        }else{
            paramsDictionary["sex"] = sex as AnyObject
        }
        paramsDictionary["age"] = age as AnyObject
        paramsDictionary["content"] = content as AnyObject
        paramsDictionary["collection"] = auxiliary as AnyObject
        paramsDictionary["physique"] = diagnosis as AnyObject
        paramsDictionary["auxiliary"] = follow_up as AnyObject
        paramsDictionary["diagnosis"] = "" as AnyObject
        paramsDictionary["treatment"] = treatment as AnyObject
        paramsDictionary["follow_up"] = "" as AnyObject
        return (cesesSavePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    //发布文章
    
    static let articleSavePath = "/article/add_articles"
    static func articleSavePathAndParams(post_title:String,group_id:Int,more:Dictionary<String, AnyObject>,post_content:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["post_title"] = post_title as AnyObject
        paramsDictionary["group_id"] = group_id as AnyObject
        paramsDictionary["more"] = more as AnyObject
        paramsDictionary["post_content"] = post_content as AnyObject
        return (articleSavePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //添加笔记
    
    static let noteSavePath = "/note/save"
    static func noteSavePathPathAndParams(id:Int,title:String,group_id:Int,content:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        //paramsDictionary["id"] = id as AnyObject
        paramsDictionary["title"] = title as AnyObject
        paramsDictionary["group_id"] = group_id as AnyObject
        paramsDictionary["images"] = 0 as AnyObject
        paramsDictionary["content"] = content as AnyObject
        return (noteSavePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    

    //添加评论
    static let saveCommentPath = "/comments/setComments"
    static func saveCommentPathAndParams(object_id:Int,table_name:String,url:String,parent_id:Int,to_user_id:Int,content:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["object_id"] = object_id as AnyObject
        paramsDictionary["table_name"] = table_name as AnyObject
        paramsDictionary["content"] = content as AnyObject
        paramsDictionary["to_user_id"] = to_user_id as AnyObject
        paramsDictionary["url"] = url as AnyObject
        paramsDictionary["parent_id"] = parent_id as AnyObject
        
        return (saveCommentPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //评论列表接口
    static let commentPath = "/comment/get_list"
    static func commentPathAndParams(limit:Int = 10,page:Int = 1,object_id:Int,table_name:String,order_type:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["object_id"] = object_id as AnyObject
        paramsDictionary["table_name"] = table_name as AnyObject
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
       // paramsDictionary["order_type"] = order_type as AnyObject
        return (commentPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //举报接口
    static let ContentComplainPath = "/user/set_report"
    static func ContentComplainPathAndParams(id:Int,table_name:String,title:String,reason:String,publisher:Int,categories:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        paramsDictionary["table_name"] = table_name as AnyObject
        paramsDictionary["title"] = title as AnyObject
        paramsDictionary["publisher"] = publisher as AnyObject
        paramsDictionary["categories"] = categories as AnyObject
        paramsDictionary["reason"] = reason as AnyObject
        return (ContentComplainPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    
    //内容点赞
    static let ContentlikePath = "/like/obj_like"
    static func ContentlikePathAndParams(id:Int,table_name:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        paramsDictionary["table_name"] = table_name as AnyObject
        return (ContentlikePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //内容收藏
    static let ContentCollectPath = "/favorite/obj_collect"
    static func ContentCollectPathAndParams(mode:AVCModel) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = mode.id as AnyObject
        paramsDictionary["title"] = mode.title as AnyObject
        paramsDictionary["url"] = mode.url as AnyObject
        paramsDictionary["thumbnail"] = mode.thumbnail as AnyObject
        paramsDictionary["description"] = mode.description as AnyObject
        paramsDictionary["table_name"] = mode.table_name as AnyObject
        return (ContentCollectPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
   
    //个人中心广告位
    static let site_infoCenter = "/system/site_info"
    static func siteInfoCenterPathAndParams() -> PathAndParams {
        return (site_infoCenter, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    //获取广告
    static let slides_info = "/index/slides_info"
    static func slidesInfoPathAndParams(slide_id:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["slide_id"] = slide_id as AnyObject
        return (slides_info, getRequestParamsDictionary(paramsDictionary: paramsDictionary ))
    }
    
   
    
    //个人中心
    static let personsCenter = "/user/center"
    static func personsCenterPathAndParams() -> PathAndParams {
        return (personsCenter, getRequestParamsDictionary(paramsDictionary: nil))
    }
    //个人中心笔记
    static let noteListPath = "/note/index"
    static func noteListPathAndParams(page:Int = 1,limit:Int = 10) -> PathAndParams {
        return (noteListPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    
    
    //个人中心点赞
    static let personsLikeList = "/user/like_list"
    static func personsLikeListPathAndParams(page:Int = 1,limit:Int = 10,table_name:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["table_name"] = table_name as AnyObject
        paramsDictionary["page"] = String.init(page) as AnyObject
        paramsDictionary["limit"] = String.init(limit) as AnyObject
        return (personsLikeList, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    //个人中心收藏
    static let favoriteList = "/favorite/index"
    static func favoriteListPathAndParams(page:Int = 1,limit:Int = 10,table_name:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["table_name"] = table_name as AnyObject
        paramsDictionary["page"] = String.init(page) as AnyObject
        paramsDictionary["limit"] = String.init(limit) as AnyObject
        return (favoriteList, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //个人中心发布
    static let myPublishPath = "/user/my_publish"
    static func myPublishPathAndParams(page:Int = 1,limit:Int = 10,list_type:Int = 0) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["list_type"] = list_type as AnyObject
        paramsDictionary["page"] = String.init(page) as AnyObject
        paramsDictionary["limit"] = String.init(limit) as AnyObject
        return (myPublishPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //搜索
    static let HomeSearchPath = "/portal/search"
    static func HomeSearchPathAndParams(keyword:String, page:Int = 1,limit:Int = 100,list_type:Int = 0) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["keyword"] = keyword as AnyObject
        paramsDictionary["list_type"] = list_type as AnyObject
        paramsDictionary["page"] = String.init(page) as AnyObject
        paramsDictionary["limit"] = String.init(100) as AnyObject
        return (HomeSearchPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //个人中心订阅
    static let myGroupListPath = "/index/my_group_list"
    static func myGroupListPathAndParams() -> PathAndParams {
        return (myGroupListPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    static let editProfilePath = "/user/profile"
    static func editProfilePathAndParams(usermodel:UserModel) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        
        paramsDictionary["avatar"] = usermodel.avatar as AnyObject
        paramsDictionary["sex"] = usermodel.sex as AnyObject
        paramsDictionary["user_nickname"] = usermodel.user_nickname as AnyObject
        
        return (editProfilePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //视频详情
    static let VideoShowPath = "/video/show"
    static func VideoShowPathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (VideoShowPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //文章详情
    static let ArticleShowPath = "/article/show"
    static func ArticleShowPathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (ArticleShowPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    //病例详情
    static let CasesShowPath = "/cases/show"
    static func CasesShowPathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (CasesShowPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //栏目小组收藏操作
    static let ColumnCollectPath = "/group/group_collect"
    static func ColumnCollectPathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["group_id"] = id as AnyObject
        return (ColumnCollectPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //获取短信验证码
    static let sendCodePath = "/common/send_code"
    static func sendCodePathPathAndParams(mobile: String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["user_login"] = mobile as AnyObject
        return (sendCodePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //短信验证码登录
    static let loginCodeRegisterPath = "/system/login_register"
    static func loginCodeRegisterPathAndParams(mobile: String,verificationCode:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["user_login"] = mobile as AnyObject
        paramsDictionary["verification_code"] = verificationCode as AnyObject
        return (loginCodeRegisterPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //密码登录
    static let  passwordRegisterPath = "/login/do_login"
    static func passwordRegisterPathAndParams(user_login: String,user_pass:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["user_login"] = user_login as AnyObject
        paramsDictionary["user_pass"] = user_pass as AnyObject
        return (passwordRegisterPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //短信验证码登录后设置密码
    static let setPasswordPath = "/system/set_password"
    static func setPasswordPathAndParams(user_pass: String,user_nickname:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["user_pass"] = user_pass as AnyObject
        paramsDictionary["user_nickname"] = user_nickname as AnyObject
        return (setPasswordPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //根据小组Id获取小组详情和其下的文章视频列表
    static let groupShowListPath = "/group/show"
    static func groupShowListPathAndParams(page:Int = 1,limit:Int = 10,id:Int,list_type:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = String.init(page) as AnyObject
        paramsDictionary["limit"] = String.init(limit) as AnyObject
        paramsDictionary["id"] = id as AnyObject
        paramsDictionary["list_type"] = list_type as AnyObject
        
        return (groupShowListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //云学院
    static let cloudVideoListPath = "/index/cloud_video"
    static func cloudVideoListPathAndParams(page:Int = 1,limit:Int = 10,order_type:Int,department_id:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = String.init(page) as AnyObject
        paramsDictionary["limit"] = String.init(limit) as AnyObject
        paramsDictionary["order_type"] = order_type as AnyObject
        paramsDictionary["department_id"] = department_id as AnyObject
        
        return (cloudVideoListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    
    //最新热门接口
    static let articleListPath = "/index/article_list"
    static func articleListPathAndParams(page:Int = 1,limit:Int = 10,order_by:String) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = String.init(page) as AnyObject
        paramsDictionary["limit"] = String.init(limit) as AnyObject
        paramsDictionary["order_by"] = order_by as AnyObject
        return (articleListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //栏目/药企成果/医学前沿列表
    static let groupListPath = "/index/group_list"
    static func groupListPathAndParams(group_type:Int = 1) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["group_type"] = String.init(group_type) as AnyObject
        
        return (groupListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //病例列表
    static let caseListPath = "/index/case_list"
    static func caseListPathAndParams(page:Int = 1,limit:Int = 10) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = String.init(page) as AnyObject
        paramsDictionary["limit"] = String.init(limit) as AnyObject
        
        return (caseListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    
    //获取所有小组
    ///group/group_list
    
    static let groupAllListPath = "/group/group_list"
    static func groupAllListPathAndParams() -> PathAndParams {
        return (groupAllListPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    
    
    static let departmenListPath = "/index/department_list"
    static func departmenListPathAndParams() -> PathAndParams {
        
        return (departmenListPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    
    //外部科室接口
    static let diseasetypelistPath = "/disease/type_list"
    static func diseasetypelistPathAndParams() -> PathAndParams {
        
        return (diseasetypelistPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    
    //外部详情接口
    static let diseaseDetailPath = "/disease/disease_info"
    static func diseaseDetailPathAndParams(id:String = "") -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (diseaseDetailPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //外部关键字查询接口
    static let diseasesSarchlistPath = "/disease/disease_list"
    static func diseasesSarchlistPathAndParams(key:String = "",page:String = "",subTypeId:String = "",typeId:String = "") -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        
        if key != ""{
            paramsDictionary["keyword"] = key as AnyObject
        }
        if page != ""{
            paramsDictionary["page"] = page as AnyObject
        }
        if subTypeId != ""{
            paramsDictionary["subTypeId"] = subTypeId as AnyObject
        }
        if typeId != ""{
            paramsDictionary["typeId"] = typeId as AnyObject
        }
        
        return (diseasesSarchlistPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
}

////外部科室接口
//static let diseasetypelistPath = "/disease-type-list"
//static func diseasetypelistPathAndParams() -> PathAndParams {
//
//     return (diseasetypelistPath, getRequestParamsDictionary(paramsDictionary: nil))
//}
//
//
////外部详情接口
//static let diseaseDetailPath = "/disease-detail"
//static func diseaseDetailPathAndParams(id:String = "") -> PathAndParams {
//    var paramsDictionary = Dictionary<String, AnyObject>()
//
//    var querys = ""
//    if id != ""{
//        querys = "?id=" + id
//    }
//
//    paramsDictionary["querys"] = querys as AnyObject
//    return (diseaseDetailPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//}
//
//
////外部关键字查询接口
//static let diseasesSarchlistPath = "/search-disease"
//static func diseasesSarchlistPathAndParams(key:String = "",page:String = "",subTypeId:String = "",typeId:String = "") -> PathAndParams {
//
//    var paramsDictionary = Dictionary<String, AnyObject>()
//
//    var querys = ""
//
//    if key != ""{
//        querys = querys + "key=" + key
//    }
//    if page != ""{
//        if querys != "" {
//            querys = querys + "&page=" + page
//        }else{
//            querys = querys + "page=" + page
//        }
//    }
//    if subTypeId != ""{
//        if querys != "" {
//            querys = querys + "&subTypeId=" + subTypeId
//        }else{
//            querys = querys + "subTypeId=" + subTypeId
//        }
//    }
//    if typeId != ""{
//        if querys != "" {
//            querys = querys + "&typeId=" + typeId
//        }else{
//            querys = querys + "typeId=" + typeId
//        }
//    }
//    if querys != "" {
//        querys =  "?" + querys
//    }
//
//    paramsDictionary["querys"] = querys as AnyObject
//
//    return (diseasesSarchlistPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//}
