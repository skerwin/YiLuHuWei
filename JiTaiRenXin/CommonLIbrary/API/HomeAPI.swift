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
    static let boot_imgPath = "/home/api/start"
    static func boot_imgPathAndParams(type:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        return (boot_imgPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //首页接口
    static let HomeAllPath = "/home/api/index"
    static func HomeAllPathAndParams(pageSize:Int = 10,page:Int = 1) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["pageSize"] = pageSize as AnyObject
        paramsDictionary["page"] = page as AnyObject
        return (HomeAllPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //通用列表接口
    static let AllListPath = "/article/api/index"
    static func AllListPathAndParams(page:Int = 1,pageSize:Int = 10,obj_type:Int = 1,is_recommended:Int = 1,group_id:Int = 1,keyword:String = "") -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["pageSize"] = pageSize as AnyObject
        paramsDictionary["obj_type"] = obj_type as AnyObject
        paramsDictionary["is_recommended"] = is_recommended as AnyObject
        paramsDictionary["group_id"] = group_id as AnyObject
        paramsDictionary["keyword"] = keyword as AnyObject
        
        return (AllListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //获取公共配置接口
    static let CommonDataPath = "/common/api/setting"
    static func CommonDataPathPathAndParams() -> PathAndParams {
        return (CommonDataPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    
    //根据广告位id获取广告图列表
    static let SlideListPath = "/common/api/slide_list"
    static func SlideListPathPathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (SlideListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //热门搜索词
    static let HotSearchPath = "/common/api/hot_search"
    static func HotSearchPathPathAndParams() -> PathAndParams {
        return (HotSearchPath, getRequestParamsDictionary(paramsDictionary:nil))
    }
    
    
    //获取注册短信验证码
    static let sendRegisterMessagecodePath = "/common/api/register_send_sms"
    static func sendRegisterMessagecodePathAndParams(mobile: String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["mobile"] = mobile as AnyObject
        return (sendRegisterMessagecodePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //获取找回密码短信验证码
    static let sendFindMessagecodePath = "/common/api/find_send_sms"
    static func sendFindMessagecodePathAndParams(mobile: String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["mobile"] = mobile as AnyObject
        return (sendFindMessagecodePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //手机号+验证码找回密码
    static let sendfindPwdCodePath = "/users/api/findPwd"
    static func sendfindPwdCodePathAndParams(mobile: String,sms_code:String,password:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["mobile"] = mobile as AnyObject
        paramsDictionary["sms_code"] = sms_code as AnyObject
        paramsDictionary["password"] = password as AnyObject
        
        return (sendfindPwdCodePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
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
    
    //个人中心
    static let personsCenter = "/users/api/center"
    static func personsCenterPathAndParams() -> PathAndParams {
        return (personsCenter, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    //退出登陆
    static let logoutAccount = "/users/api/logout"
    static func logoutAccountPathAndParams() -> PathAndParams {
        return (logoutAccount, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    
    //上传图片
    static let imageUploadPath = "/common/api/up_img"
    static func imageUploadPathAndParams() -> PathAndParams {
        let paramsDictionary = Dictionary<String, AnyObject>()
        return (imageUploadPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //科室列表接口
    static let departmentPath = "/department/api/index"
    static func departmentPathAndParams() -> PathAndParams {
        let paramsDictionary = Dictionary<String, AnyObject>()
        return (departmentPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //职称列表接口
    static let professionalPath = "/professional/api/index"
    static func professionalPathAndParams() -> PathAndParams {
        let paramsDictionary = Dictionary<String, AnyObject>()
        return (professionalPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //医师认证接口
    static let authDoctorPath = "/users/api/authDoctor"
    static func authDoctorPathAndParams(usermodel:UserModel) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        
        paramsDictionary["realname"] = usermodel.realname as AnyObject
        paramsDictionary["sex"] = usermodel.sex as AnyObject
        paramsDictionary["hospital"] = usermodel.doctorModel?.hospital as AnyObject
        paramsDictionary["department_id"] = usermodel.doctorModel?.department_id as AnyObject
        paramsDictionary["professional_id"] = usermodel.doctorModel?.professional_id as AnyObject
        paramsDictionary["breastplate_id"] = usermodel.doctorModel?.breastplate_id as AnyObject
        
        paramsDictionary["certificate_ids"] = usermodel.doctorModel?.certificate_ids as AnyObject
        return (authDoctorPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //注册医师认证接口
    static let registerAuthDoctorPath = "/users/api/registerTwo"
    static func registerAuthDoctorPathAndParams(usermodel:UserModel) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        
        paramsDictionary["mobile"] = usermodel.mobile as AnyObject
        paramsDictionary["password"] = usermodel.password as AnyObject
        paramsDictionary["realname"] = usermodel.realname as AnyObject
        paramsDictionary["sex"] = usermodel.sex as AnyObject
        paramsDictionary["hospital"] = usermodel.doctorModel?.hospital as AnyObject
        paramsDictionary["department_id"] = usermodel.doctorModel?.department_id as AnyObject
        paramsDictionary["professional_id"] = usermodel.doctorModel?.professional_id as AnyObject
        paramsDictionary["breastplate_id"] = usermodel.doctorModel?.breastplate_id as AnyObject
        paramsDictionary["certificate_ids"] = usermodel.doctorModel?.certificate_ids as AnyObject
        return (registerAuthDoctorPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    static let editProfilePath = "/users/api/editProfile"
    static func editProfilePathAndParams(usermodel:UserModel) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        
        paramsDictionary["avatar"] = usermodel.avatar_id as AnyObject
        paramsDictionary["nickname"] = usermodel.nickname as AnyObject
        paramsDictionary["realname"] = usermodel.realname as AnyObject
        paramsDictionary["sex"] = usermodel.sex as AnyObject
        
        return (editProfilePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    static let ContentDetailPath = "/article/api/detail"
    static func ContentDetailPathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (ContentDetailPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //内容点赞
    static let ContentlikePath = "/article/api/like"
    static func ContentlikePathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (ContentlikePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //内容收藏
    static let ContentCollectPath = "/article/api/collect"
    static func ContentCollectPathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (ContentCollectPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //评论列表接口
    static let commentPath = "/comment/api/index"
    static func commentPathAndParams(pageSize:Int = 10,page:Int = 1,id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["pageSize"] = pageSize as AnyObject
        return (commentPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //添加评论
    static let saveCommentPath = "/comment/api/save"
    static func saveCommentPathAndParams(obj_id:Int,parent_id:Int,content:String) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["obj_id"] = obj_id as AnyObject // 对那一条评论进行评论   | 如果没有就是 0
        paramsDictionary["parent_id"] = parent_id as AnyObject  //外键ID   | 可以通用替代文章id、病例id、视频id
        paramsDictionary["content"] = content as AnyObject //评论内容
        
        return (saveCommentPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    static let ColumnForPath = "/group/api/index"
    static func ColumnForPathAndParams() -> PathAndParams {
        return (ColumnForPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    static let ColumnForDetailPath = "/group/api/detail"
    static func ColumnForDetaiPathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (ColumnForDetailPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    static let ColumnCollectPath = "/group/api/collect"
    static func ColumnCollectPathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (ColumnCollectPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //收藏列表
    static let mineCollectPath = "/article/api/collect_list"
    static func mineCollectPathAndParams(obj_type:Int,pageSize:Int = 10,page:Int = 1) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        
        paramsDictionary["pageSize"] = pageSize as AnyObject
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["obj_type"] = obj_type as AnyObject
        return (mineCollectPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //点赞列表
    static let mineGoodListPath = "/article/api/like_list"
    static func mineGoodListPathAndParams(obj_type:Int,pageSize:Int = 10,page:Int = 1) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        
        paramsDictionary["pageSize"] = pageSize as AnyObject
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["obj_type"] = obj_type as AnyObject
        return (mineGoodListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //举报列表
    static let mineComplainPath = "/report/api/index"
    static func mineComplainPathAndParams() -> PathAndParams {
        
        return (mineComplainPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    //评论举报接口
    static let ComplainCommentPath = "/report/api/report"
    static func ComplainCommentPathAndParams(report_type:Int,categories:String,id:Int,reason:String,article_id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        paramsDictionary["report_type"] = report_type as AnyObject
        paramsDictionary["categories"] = categories as AnyObject
        paramsDictionary["reason"] = reason as AnyObject
        paramsDictionary["article_id"] = article_id as AnyObject
        return (ComplainCommentPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    // 消息通知接口
    static let messageloadPath = "/message/api/index"
    static func messageloadPathAndParams(pageSize:Int = 10,page:Int = 1) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["pageSize"] = pageSize as AnyObject
        paramsDictionary["page"] = page as AnyObject
        return (messageloadPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    // 消息详情接口
    static let messagedetailPath = "/message/api/detail"
    static func messagedetailPathAndParams(id:Int = 1) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        
        return (messagedetailPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
//    //首页接口
//    static let HomeAllPath = "api/home/index"
//    static func HomeAllPathAndParams(pagenum:Int = 10,page:Int = 1) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["pagenum"] = pagenum as AnyObject
//        paramsDictionary["page"] = page as AnyObject
//        return (HomeAllPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //首页更多接口
//    static let HomeMorePath = "api/more/index"
//    static func HomeMorePathAndParams(type:String,pagenum:Int = 10,page:Int = 1) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["pagenum"] = pagenum as AnyObject
//        paramsDictionary["page"] = page as AnyObject
//        paramsDictionary["type"] = type as AnyObject
//        return (HomeMorePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //搜索接口
//    static let SearchPath = "api/search/index"
//    static func SearchPathAndParams(word:String,pagenum:Int = 10,page:Int = 1,table:String) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["pagenum"] = pagenum as AnyObject
//        paramsDictionary["page"] = page as AnyObject
//        paramsDictionary["word"] = word as AnyObject
//        paramsDictionary["table"] = table as AnyObject
//        return (SearchPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //频道接口
//    static let ChannelPath = "api/channel/index"
//    static func ChannelPathAndParams(type:String,pagenum:Int = 10,page:Int = 1) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["pagenum"] = pagenum as AnyObject
//        paramsDictionary["page"] = page as AnyObject
//        paramsDictionary["type"] = type as AnyObject
//        return (ChannelPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//    //栏目
//
//    static let ColumnForPath = "api/category/index"
//    static func ColumnForPathAndParams() -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        return (ColumnForPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//    //栏目详情
//
//    static let ColumnForDetailPath = "api/category/detial"
//    static func ColumnForDetaiPathAndParams(type:String,id:Int,pagenum:Int = 10,page:Int = 1) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["type"] = type as AnyObject
//        paramsDictionary["id"] = id as AnyObject
//        paramsDictionary["pagenum"] = pagenum as AnyObject
//        paramsDictionary["page"] = page as AnyObject
//        return (ColumnForDetailPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//    //文章详情
//
//    static let ArticleDetailPath = "api/article/index/id"
//    static func ArticleDetailPathAndParams(id:Int) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["id"] = id as AnyObject
//        return (ArticleDetailPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //病例详情
//
//    static let CaseDetailPath = "api/cased/index/id"
//    static func CaseDetailPathAndParams(id:Int) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["id"] = id as AnyObject
//        return (CaseDetailPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//    //视频详情
//    static let videoDetailPath = "api/video/index"
//    static func videoDetailPathAndParams(id:Int) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["id"] = id as AnyObject
//        return (videoDetailPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //文章收藏
//
//    static let ArticleCollectPath = "api/collect/article"
//    static func ArticleCollectPathAndParams(id:Int) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["aid"] = id as AnyObject
//        if let userId = objectForKey(key: Constants.userid) {
//            paramsDictionary["uid"] = userId as AnyObject
//        }
//        return (ArticleCollectPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //病例收藏
//
//    static let CaseCollectPath = "api/collect/cases"
//    static func CaseCollectPathPathAndParams(id:Int) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["cid"] = id as AnyObject
//        if let userId = objectForKey(key: Constants.userid) {
//            paramsDictionary["uid"] = userId as AnyObject
//        }
//        return (CaseCollectPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//    //视频收藏
//
//    static let VideoCollectPath = "api/collect/video"
//    static func VideoCollectPathAndParams(id:Int) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["vid"] = id as AnyObject
//        if let userId = objectForKey(key: Constants.userid) {
//            paramsDictionary["uid"] = userId as AnyObject
//        }
//        return (VideoCollectPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //添加评论
//    static let saveCommentPath = "api/comment/save"
//    static func saveCommentPathAndParams(type:Int,to:Int,fid:Int,content:String) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//
//        if let userId = objectForKey(key: Constants.userid) {
//            paramsDictionary["uid"] = userId as AnyObject
//        }
//        paramsDictionary["type"] = type as AnyObject //评论类型
//        paramsDictionary["to"] = to as AnyObject // 对那一条评论进行评论   | 如果没有就是 0
//        paramsDictionary["fid"] = fid as AnyObject  //外键ID   | 可以通用替代文章id、病例id、视频id
//        paramsDictionary["content"] = content as AnyObject //评论内容
//        return (saveCommentPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //获取短信验证码
//    static let sendMessagecodePath = "api/sms/send"
//    static func sendMessagecodePathAndParams(mobile: String, type: Int) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["type"] = type as AnyObject
//        paramsDictionary["mobile"] = mobile as AnyObject
//        return (sendMessagecodePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //忘记密码
//    static let forgetPwdPath = "api/forget/reset"
//    static func forgetPwdPathAndParams(code: String = "", mobile: String,password:String) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["mobile"] = mobile as AnyObject
//        paramsDictionary["code"] = code as AnyObject
//        paramsDictionary["password"] = password as AnyObject
//        paramsDictionary["repassword"] = password as AnyObject
//        return (forgetPwdPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//    //注册
//    static let registerPath = "api/register/index"
//    static func registerPathAndParams(phone: String = "", password: String,code:String) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["phone"] = phone as AnyObject
//        paramsDictionary["password"] = password as AnyObject
//        paramsDictionary["code"] = code as AnyObject
//        return (registerPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//    //登录
//    static let loginPath = "api/login/index"
//    static func loginPathAndParams(phone: String = "", password: String = "") -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["phone"] = phone as AnyObject
//        paramsDictionary["password"] = password as AnyObject
//        return (loginPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //评论列表接口
//    static let commentPath = "api/comment2/index"
//    static func commentPathAndParams(pagenum:Int = 10,page:Int = 1,type:Int,fid:Int) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["type"] = type as AnyObject
//        paramsDictionary["fid"] = fid as AnyObject
//        paramsDictionary["page"] = page as AnyObject
//        paramsDictionary["pagenum"] = pagenum as AnyObject
//        return (commentPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //科室列表接口
//    static let departmentsPath = "api/departments/index"
//    static func departmentsPathAndParams() -> PathAndParams {
//        let paramsDictionary = Dictionary<String, AnyObject>()
//        return (departmentsPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //职称列表接口
//    static let jobtitlePath = "api/jobtitle/index"
//    static func jobtitlePathAndParams() -> PathAndParams {
//        let paramsDictionary = Dictionary<String, AnyObject>()
//        return (jobtitlePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//    //医师认证接口
//    static let authenPersonalPath = "api/user/personal"
//    static func authenPersonalPathAndParams(usermodel:UserModel) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//
//        paramsDictionary["truename"] = usermodel.truename as AnyObject
//        paramsDictionary["gender"] = usermodel.gender as AnyObject
//        paramsDictionary["jobtitle"] = usermodel.jobtitle as AnyObject
//        paramsDictionary["phone"] = usermodel.phone as AnyObject
//        paramsDictionary["breastplate"] = usermodel.breastplate as AnyObject
//        paramsDictionary["physicianmedicallicence"] = usermodel.physicianmedicallicence as AnyObject
//        paramsDictionary["departments"] = usermodel.departments as AnyObject
//        paramsDictionary["hospital"] = usermodel.hospital as AnyObject
//
//        if let userId = objectForKey(key: Constants.userid) {
//            paramsDictionary["adzoneId"] = userId as AnyObject
//        }
//        return (authenPersonalPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//
//    static let completePersonalPath = "api/user/complete"
//    static func completePersonalPathAndParams(usermodel:UserModel) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//
//        paramsDictionary["avatar"] = usermodel.avatar as AnyObject
//        paramsDictionary["nickname"] = usermodel.nickname as AnyObject
//        paramsDictionary["truename"] = usermodel.truename as AnyObject
//        paramsDictionary["gender"] = usermodel.gender as AnyObject
//        if let userId = objectForKey(key: Constants.userid) {
//            paramsDictionary["adzoneId"] = userId as AnyObject
//        }
//        return (completePersonalPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//    //上传图片token
//    static let gettokenPath = "api/upload/gettoken"
//    static func gettokenPathAndParams() -> PathAndParams {
//        let paramsDictionary = Dictionary<String, AnyObject>()
//        return (gettokenPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//    //上传图片
//    static let imageUploadPath = "api/upload/imageUpload"
//    static func imageUploadPathAndParams() -> PathAndParams {
//        let paramsDictionary = Dictionary<String, AnyObject>()
//        return (imageUploadPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//
//    //消息通知接口
//    static let messageloadPath = "api/message/index"
//    static func messageloadPathAndParams(pagenum:Int = 10,page:Int = 1) -> PathAndParams {
//
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        paramsDictionary["pagenum"] = pagenum as AnyObject
//        paramsDictionary["page"] = page as AnyObject
//        return (messageloadPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //用户个人信息接口
//    static let profilePath = "api/profile/index"
//    static func profilePathAndParams() -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        if let userId = objectForKey(key: Constants.userid) {
//            paramsDictionary["adzoneId"] = userId as AnyObject
//        }
//        return (profilePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //搜素热词和历史词
//    static let searchWordPath = "api/search/history"
//    static func searchWordPathAndParams() -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        if let userId = objectForKey(key: Constants.userid) {
//            paramsDictionary["adzoneId"] = userId as AnyObject
//        }
//        return (searchWordPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//
//    //收藏列表
//    static let mineCollectPath = "api/user/collect"
//    static func mineCollectPathAndParams(type:String,pagenum:Int = 10,page:Int = 1) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        if let userId = objectForKey(key: Constants.userid) {
//            paramsDictionary["adzoneId"] = userId as AnyObject
//        }
//        paramsDictionary["pagenum"] = pagenum as AnyObject
//        paramsDictionary["page"] = page as AnyObject
//        paramsDictionary["type"] = type as AnyObject
//        return (mineCollectPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //点赞列表
//    static let mineGoodListPath = "api/user/likes"
//    static func mineGoodListPathAndParams(type:String,pagenum:Int = 10,page:Int = 1) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        if let userId = objectForKey(key: Constants.userid) {
//            paramsDictionary["adzoneId"] = userId as AnyObject
//        }
//        paramsDictionary["pagenum"] = pagenum as AnyObject
//        paramsDictionary["page"] = page as AnyObject
//        paramsDictionary["type"] = type as AnyObject
//        return (mineGoodListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //举报列表
//    static let mineComplainPath = "api/user/inform"
//    static func mineComplainPathAndParams(type:String,pagenum:Int = 10,page:Int = 1) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        if let userId = objectForKey(key: Constants.userid) {
//            paramsDictionary["adzoneId"] = userId as AnyObject
//        }
//        paramsDictionary["pagenum"] = pagenum as AnyObject
//        paramsDictionary["page"] = page as AnyObject
//        paramsDictionary["type"] = type as AnyObject
//        return (mineComplainPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//
//
//
//    //收藏状态查询
//    static let CollectStatePath = "api/collect/state"
//    static func CollectStatePathAndParams(type:String,fid:Int) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//
//        if let userId = objectForKey(key: Constants.userid) {
//            paramsDictionary["adzoneId"] = userId as AnyObject
//        }
//        paramsDictionary["fid"] = fid as AnyObject
//        paramsDictionary["type"] = type as AnyObject
//        return (CollectStatePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //评论举报接口
//    static let ComplainCommentPath = "api/inform/comment"
//    static func ComplainCommentPathAndParams(type:String,reasons:String,cid:Int) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        if let userId = objectForKey(key: Constants.userid) {
//            paramsDictionary["adzoneId"] = userId as AnyObject
//        }
//        paramsDictionary["cid"] = cid as AnyObject
//        paramsDictionary["type"] = type as AnyObject
//        paramsDictionary["reasons"] = reasons as AnyObject
//        return (ComplainCommentPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //栏目关注
//    static let AttentionCategoryPath = "api/attention/category"
//    static func AttentionCategoryPathPathAndParams(cid:Int) -> PathAndParams {
//        var paramsDictionary = Dictionary<String, AnyObject>()
//        if let userId = objectForKey(key: Constants.userid) {
//            paramsDictionary["adzoneId"] = userId as AnyObject
//        }
//        paramsDictionary["cid"] = cid as AnyObject
//        return (AttentionCategoryPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//    }
//
//    //已关注的栏目列表
//     static let ListAttentionCategoryPath = "api/user/attention"
//     static func ListAttentionCategoryPathAndParams(type:String) -> PathAndParams {
//         var paramsDictionary = Dictionary<String, AnyObject>()
//         if let userId = objectForKey(key: Constants.userid) {
//             paramsDictionary["adzoneId"] = userId as AnyObject
//         }
//         paramsDictionary["type"] = type as AnyObject
//         return (ListAttentionCategoryPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//     }
//
//
//    //广告图
//      static let boot_imgPath = "api/boot_img/index"
//      static func boot_imgPathAndParams(type:String) -> PathAndParams {
//          var paramsDictionary = Dictionary<String, AnyObject>()
//          return (boot_imgPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//      }
//
//    //视频点赞
//       static let likeVideoPath = "api/like/video"
//       static func likeVideoPathAndParams(vid:Int) -> PathAndParams {
//           var paramsDictionary = Dictionary<String, AnyObject>()
//           if let userId = objectForKey(key: Constants.userid) {
//                   paramsDictionary["adzoneId"] = userId as AnyObject
//               }
//            paramsDictionary["vid"] = vid as AnyObject
//           return (likeVideoPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//       }
//
//    //文章点赞
//         static let likeArticlePath = "api/like/article"
//         static func likeArticlePathAndParams(vid:Int) -> PathAndParams {
//             var paramsDictionary = Dictionary<String, AnyObject>()
//             if let userId = objectForKey(key: Constants.userid) {
//                     paramsDictionary["adzoneId"] = userId as AnyObject
//                 }
//              paramsDictionary["aid"] = vid as AnyObject
//             return (likeArticlePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//         }
//
//
//    //病例点赞
//         static let likeCasesPath = "api/like/cases"
//         static func likeCasesPathAndParams(vid:Int) -> PathAndParams {
//             var paramsDictionary = Dictionary<String, AnyObject>()
//             if let userId = objectForKey(key: Constants.userid) {
//                     paramsDictionary["adzoneId"] = userId as AnyObject
//                 }
//              paramsDictionary["cid"] = vid as AnyObject
//             return (likeCasesPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//         }
//
//    //点赞状态
//       static let likeStatusPath = "api/user/like"
//    static func likeStatusPathAndParams(type:String,pagenum:Int = 10,page:Int = 1,vid:Int)-> PathAndParams {
//           var paramsDictionary = Dictionary<String, AnyObject>()
//           if let userId = objectForKey(key: Constants.userid) {
//                   paramsDictionary["adzoneId"] = userId as AnyObject
//               }
//          paramsDictionary["fid"] = vid as AnyObject
//          paramsDictionary["type"] = type as AnyObject
//         // paramsDictionary["pagenum"] = pagenum as AnyObject
//         // paramsDictionary["page"] = page as AnyObject
//          return (likeStatusPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
//       }
}

