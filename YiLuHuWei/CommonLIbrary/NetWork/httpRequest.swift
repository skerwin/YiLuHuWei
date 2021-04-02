//
//  httpRequest.swift
//  WisdomJapan
//
//  Created by zhaoyuanjing on 2017/09/15.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//
import Foundation
import SwiftyJSON
import Alamofire
/**
 *  网络请求统一入口
 */


typealias FSResponseSuccess = (_ response: String) -> Void
typealias FSResponseFail = (_ error: String) -> Void
typealias FSNetworkStatus = (_ NetworkStatus: Int32) -> Void
typealias FSProgressBlock = (_ progress: Int32) -> Void

struct HttpRequest {
    // 参考地址： http://qiita.com/k-yamada@github/items/569c4c97f0b8e4605e04
    
    static func restfulRequest(methodType: HTTPMethod,
                               pathAndParams: PathAndParams,
                               urlStr: String = "",
                               completionHandler: @escaping (_ responseResult: ResponseResult<JSON>) -> Void){
        
        let requestPath = pathAndParams.0
        let parameters  = pathAndParams.1
       
       
        let  Url = URL.init(string: URLs.getHostAddress() + requestPath)

        var request: DataRequest?
        //print(Url!.absoluteString)
        //let parametersJson = JSON(parameters!)
        //print(parametersJson)
        
        var token = ""
        if stringForKey(key: Constants.token) != nil {
            token = stringForKey(key: Constants.token)!
        }
        ////        构造header
        let headers: HTTPHeaders = [
            "XX-Api-Version": "1.0.0",
            "XX-Device-Type": "iphone",
            "XX-Token": token
        ]
        switch methodType {
        case .get, .delete:
            request =  AF.request(Url!, method: methodType,encoding: JSONEncoding.default, headers: headers)
        case .post, .put:
            request =  AF.request(Url!, method: methodType, parameters: parameters,encoding: JSONEncoding.default, headers: headers)
            
        default:
            break
        }
        request?.responseJSON(completionHandler: { (response) in
            let result = response.result
            switch result {
            case .success:
                guard let dict = response.value else {
                    //print("数据请求出错")
                    DialogueUtils.dismiss()
                    completionHandler(.Failure(JSON(["code":"100888"])))
                    return
                }
                let responseJson = JSON(dict)
                print(Url!.absoluteString)
                print(responseJson)
                if requestPath == HomeAPI.departmenListPath{
                    XHNetworkCache.save_asyncJsonResponse(toCacheFile: dict, andURL: requestPath) { (result) in
                        if(result){
                            //print("科目(异步)写入/更新缓存数据 成功");
                        }
                        else
                        {
                           // print("科目(异步)写入/更新缓存数据 失败");
                        }
                    }
                }
                if requestPath == HomeAPI.groupAllListPath{
                    XHNetworkCache.save_asyncJsonResponse(toCacheFile: dict, andURL: requestPath) { (result) in
                        if(result){
                           // print("科目(异步)写入/更新缓存数据 成功");
                        }
                        else
                        {
                           // print("科目(异步)写入/更新缓存数据 失败");
                        }
                    }
                }
                
                completionHandler(.Success(responseJson))
            case .failure:
                //print("数据请求出错")
                completionHandler(.Failure(JSON(["code":"100888"])))
                 DialogueUtils.dismiss()
               // completionHandler(.Failure(Error.self as! Error))
            }
        })
    }
    
//    [XHNetworkCache clearCache];
//    //获取缓存大小(M)
//    float cacheSize = [XHNetworkCache cacheSize];
//    //或者(以..kb/..M)形式获取
//    NSString *cacheSizeFormat = [XHNetworkCache cacheSizeFormat];
//    //获取缓存路径
//    NSString *path = [XHNetworkCache cachePath];
    
    static func EeternalRestfulRequest(methodType: HTTPMethod,
                               pathAndParams: PathAndParams,
                               urlStr: String = "",
                               completionHandler: @escaping (_ responseResult: ResponseResult<JSON>) -> Void){
        
        
       
       //[XHNetworkCache checkCacheWithURL:self.URL params:self.params];
        
        
        let requestPath = pathAndParams.0
        let parameters  = pathAndParams.1
        
        var Url = URL.init(string: "http://ali-disease.showapi.com" + requestPath)
        
        //如果是列表数据先查看是否缓存，缓存了直接返回就行
        if requestPath == HomeAPI.diseasetypelistPath{
            let result = XHNetworkCache.check(withURL: requestPath)
            let urlStr = "http://ali-disease.showapi.com" + requestPath
            Url = URL.init(string: urlStr.urlEncoded())
            if result {
                print(Url!.absoluteString)
                let dict = XHNetworkCache.cacheJson(withURL: requestPath)
                let responseJson = JSON(dict)
                print("缓存读取")
                print(responseJson)
                completionHandler(.Success(responseJson ))
                return
            }
        }else if requestPath == HomeAPI.diseasesSarchlistPath{
 
            let querys:String = parameters!["querys"] as! String
            let urlStr = "http://ali-disease.showapi.com" + requestPath + querys
            Url = URL.init(string: urlStr.urlEncoded())
            
            let result = XHNetworkCache.check(withURL: urlStr)
            if result {
                print(urlStr)
                let dict = XHNetworkCache.cacheJson(withURL: urlStr)
                let responseJson = JSON(dict)
                print("缓存读取")
                print(responseJson)
                completionHandler(.Success(responseJson ))
                return
            }
        }else if requestPath == HomeAPI.diseaseDetailPath{
            
            let querys:String = parameters!["querys"] as! String
            let urlStr = "http://ali-disease.showapi.com" + requestPath + querys
            Url = URL.init(string: urlStr.urlEncoded())
            
            let result = XHNetworkCache.check(withURL: urlStr)
            if result {
                print(urlStr)
                let dict = XHNetworkCache.cacheJson(withURL: urlStr)
                let responseJson = JSON(dict)
                print("缓存读取")
                print(responseJson)
                completionHandler(.Success(responseJson ))
                return
            }
        }
 
       
        print(Url!.absoluteString)
        
     
        let parametersJson = JSON(parameters!)
        print(parametersJson)
        
        let appCode = "4f7e6b77ca1e413083a76726cdd39865"
        var request: DataRequest?
        //  构造header
        let headers: HTTPHeaders = [
            "Authorization": "APPCODE " + appCode,
         ]
        switch methodType {
        case .get, .delete:
             request =  AF.request(Url!, method: methodType,encoding: JSONEncoding.default, headers: headers)
        case .post, .put:
            request =  AF.request(Url!, method: methodType, parameters: parameters,encoding: JSONEncoding.default)
        default:
            break
        }
        
        request?.responseJSON(completionHandler: { (response) in
            let result = response.result
            switch result {
            case .success:
                guard let dict = response.value else {
                    DialogueUtils.dismiss()
                    completionHandler(.Failure(JSON(["code":"100888"])))
                    return
                }
                let responseJson = JSON(dict)
                print(Url!.absoluteString)
                print(responseJson)
                if requestPath == HomeAPI.diseasetypelistPath{
                    XHNetworkCache.save_asyncJsonResponse(toCacheFile: dict, andURL: requestPath) { (result) in
                        if(result){
                            print("科目(异步)写入/更新缓存数据 成功");
                        }
                        else
                        {
                            print("科目(异步)写入/更新缓存数据 失败");
                        }
                    }
                } else if requestPath == HomeAPI.diseasesSarchlistPath{
                    XHNetworkCache.save_asyncJsonResponse(toCacheFile: dict, andURL: Url!.absoluteString ) { (result) in
                        if(result){
                            print("病例(异步)写入/更新缓存数据 成功");
                        }
                        else
                        {
                            print("病例(异步)写入/更新缓存数据 失败");
                        }
                    }
                }else if requestPath == HomeAPI.diseaseDetailPath{
                    XHNetworkCache.save_asyncJsonResponse(toCacheFile: dict, andURL: Url!.absoluteString ) { (result) in
                        if(result){
                            print("病例(异步)写入/更新缓存数据 成功");
                        }
                        else
                        {
                            print("病例(异步)写入/更新缓存数据 失败");
                        }
                    }
                }
                completionHandler(.Success(responseJson))
            case .failure:
                //print("数据请求出错")
                completionHandler(.Failure(JSON(["code":"100888"])))
                 DialogueUtils.dismiss()
            }
        })
    }
    
    static func EeternalGetRequest(pathAndParams: PathAndParams, completionHandler: @escaping (_ responseResult: ResponseResult<JSON>) -> Void) {
        EeternalRestfulRequest(methodType: .get, pathAndParams: pathAndParams, completionHandler: completionHandler)
    }
    
    
    static func getRequest(pathAndParams: PathAndParams, completionHandler: @escaping (_ responseResult: ResponseResult<JSON>) -> Void) {
        restfulRequest(methodType: .get, pathAndParams: pathAndParams, completionHandler: completionHandler)
    }
    
    static func postRequest(pathAndParams: PathAndParams, completionHandler: @escaping (_ responseResult: ResponseResult<JSON>) -> Void) {
        restfulRequest(methodType: .post, pathAndParams: pathAndParams, completionHandler: completionHandler)
    }
    
    static func postRequestSpecical(url:String ,pathAndParams: PathAndParams, completionHandler: @escaping (_ responseResult: ResponseResult<JSON>) -> Void) {
        restfulRequest(methodType: .post, pathAndParams: pathAndParams,urlStr: url, completionHandler: completionHandler)
    }
    
    
    static func putRequest(pathAndParams: PathAndParams, completionHandler: @escaping (_ responseResult: ResponseResult<JSON>) -> Void) {
        restfulRequest(methodType: .put, pathAndParams: pathAndParams, completionHandler: completionHandler)
    }
    
    static func deleteRequest(pathAndParams: PathAndParams, completionHandler: @escaping (_ responseResult: ResponseResult<JSON>) -> Void) {
        restfulRequest(methodType: .delete, pathAndParams: pathAndParams, completionHandler: completionHandler)
    }
    
    
    static func uploadImage(url:String,filePath:String,success: @escaping (_ content:JSON) -> Void, failure: @escaping (_ errorInfo: String?) -> Void){
        let fileUrl = URL.init(fileURLWithPath: filePath)
        var token = ""
        if stringForKey(key: Constants.token) != nil {
            token = stringForKey(key: Constants.token)!
        }
        let upUrlstr = URLs.getHostAddress() + url
        let headers: HTTPHeaders = [
            "Device-Type": "ios",
            "XX-Token": token
        ]
        
        var fileNamepara = ""
        if url == "/users/api/editAvatar" {
            fileNamepara = "avatar"
        }else{
            fileNamepara = "file"
        }
         AF.upload(multipartFormData: { multipartFormData in
             multipartFormData.append(fileUrl, withName: fileNamepara)
         }, to: upUrlstr, usingThreshold: MultipartFormData.encodingMemoryThreshold,method: .post, headers: headers, interceptor: nil, fileManager:.default).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let dict = response.value else {
                    //failure("图片服务器出错")
                    //("图片上传出错")
                    return
                }
                let responseJson = JSON(dict)
                let responseData = responseJson[BerResponseConstants.responseData]
                print(upUrlstr)
                print(responseJson)
                if responseJson["code"].intValue == 1 {
                    success(responseData)
                }else{
                    let msg = responseJson["msg"].stringValue
                    failure(msg)
                   // print(content + msg)
                }
            case .failure:
                failure("图片服务器出错")
                print("图片上传出错")
            }
        }
    }
    
}




