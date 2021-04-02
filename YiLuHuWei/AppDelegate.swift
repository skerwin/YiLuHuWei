//
//  AppDelegate.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/07/23.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import XHLaunchAd
import SwiftyJSON
import Alamofire
import Harpy


@UIApplicationMain
class AppDelegate: UIResponder,JPUSHRegisterDelegate, UIApplicationDelegate,XHLaunchAdDelegate {
    //601ca640425ec25f10ec7c27
    let AppKey = "656bb129b85300bdf78ed31b"
    
    var window: UIWindow?
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
       

        jshareInit()
        //UMshareInit()
        if (stringForKey(key: Constants.token) != nil && stringForKey(key: Constants.token) != "") {
            
         }else{
            JPUSHServiceRegister(launchOptions: launchOptions)
         }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.makeKeyAndVisible()
 
        LaunchImageLoad()
        
        window?.backgroundColor = UIColor.white
        self.window?.rootViewController =  MainTabBarController()
        let hidePublish = stringForKey(key: Constants.hidePublish)
        if hidePublish == nil{
            setStringValueForKey(value: "hidePublish" as String, key: Constants.hidePublish)
        }
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            //print(registrationID)
        }
        
        Harpy.sharedInstance()?.presentingViewController = self.window?.rootViewController
        Harpy.sharedInstance()?.checkVersion()
 
        return true
    }

//极光分享
    
    func jshareInit(){
        let shareConfig = JSHARELaunchConfig.init()
        shareConfig.appKey = AppKey;
        shareConfig.qqAppId = "1111415077"
        shareConfig.qqAppKey = "sjVMivqYmZz7NAQ3"
        shareConfig.weChatAppId = "wx4ea1dc579a521f01"
        shareConfig.weChatAppSecret = "0d39048c840bb89e5b8174d4aca67a85"
        shareConfig.universalLink = "https://m0juy.share2dlink.com/"
        JSHAREService.setup(with: shareConfig)
        JSHAREService.setDebug(false)
    }
    
    //加载广告页
    func LaunchImageLoad(){
        let imageAdconfiguration = XHLaunchImageAdConfiguration.default()
        XHLaunchAd.setLaunch(.launchImage)
        XHLaunchAd.setWaitDataDuration(5)
        
        let  Url = URL.init(string: (URLs.getHostAddress() + HomeAPI.boot_imgPath))
        //print(Url!.absoluteString)
        var request: DataRequest?
        
        let headers: HTTPHeaders = [
            "Device-Type": "ios",
            "XX-Token": ""
        ]
        request =  AF.request(Url!, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: headers)
        
        request?.responseJSON(completionHandler: { (response) in
            let result = response.result
            switch result {
            case .success:
                guard let dict = response.value else {
                    //print("启动图数据请求出错")
                    return
                }
                
                let responseJson = JSON(dict)
                // print(responseJson)
                let responseData = responseJson[BerResponseConstants.responseData]["start_page"].stringValue
                let openModel = responseJson[BerResponseConstants.responseData]["start_url"].stringValue
                
                imageAdconfiguration.duration = 3;
                imageAdconfiguration.imageNameOrURLString = responseData
                imageAdconfiguration.openModel = openModel
                XHLaunchAd.imageAd(with: imageAdconfiguration, delegate: self)
        
            case .failure:
                print("启动图数据请求出错!")
            }
        })
    }
    
    func xhLaunchAd(_ launchAd: XHLaunchAd, clickAtOpenModel openModel: Any, click clickPoint: CGPoint) -> Bool {

        let urls = openModel as? String
        if urls == nil || urls == ""{
            return false
        }
        let vc = AdverController()
        vc.urlString = openModel as? String
        vc.isFromLaunchImage = true
         let nav = MainNavigationController.init(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.window?.rootViewController?.present(nav, animated: true, completion: nil)
        return true
    }
    
    
    
    
    func JPUSHServiceRegister(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        //注册极光推送
        let entity = JPUSHRegisterEntity()
        entity.types = 1 << 0 | 1 << 1 | 1 << 2
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        //通知类型（这里将声音、消息、提醒角标都给加上）
        let userSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                                      categories: nil)
        if ((UIDevice.current.systemVersion as NSString).floatValue >= 8.0) {
            //可以添加自定义categories
            JPUSHService.register(forRemoteNotificationTypes: userSettings.types.rawValue,
                                  categories: nil)
        }
        else {
            //categories 必须为nil
            JPUSHService.register(forRemoteNotificationTypes: userSettings.types.rawValue,
                                  categories: nil)
        }
        
        JPUSHService.setup(withOption: launchOptions, appKey: AppKey, channel: "App Store", apsForProduction: false, advertisingIdentifier: nil)
 
    }
    
    //
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
 
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Harpy.sharedInstance()?.checkVersionWeekly()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //点推送进来执行这个方法
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification")
        //print(userInfo)
        
        let tabc = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        let nvc = tabc.selectedViewController as! MainNavigationController
        let vc = nvc.viewControllers.last
        
        if let msg_type = userInfo["msg_type"] {
            print(msg_type)
            if msg_type as! Int == 0{  //系统消息
                
                if (stringForKey(key: Constants.token) != nil && stringForKey(key: Constants.token) != "") {
                    let dvc = NotifyController()
                    vc?.navigationController?.pushViewController(dvc, animated: true)
                }else{
                    let dvc =  UIStoryboard.getNewLoginController()
                    vc?.navigationController?.pushViewController(dvc, animated: true)
                }
            }else{         //内容消息
                if let obj_type = userInfo["obj_type"] {
                    
                    let msg_id = userInfo["msg_id"] as! Int
                    print(obj_type)
                    print(msg_id)
                    
                    if (stringForKey(key: Constants.token) != nil && stringForKey(key: Constants.token) != "") {
                        if obj_type as! Int == 0{  //系统消息
                            //文章
                            let dvc = ArcticleDetailController()
                            dvc.fid = msg_id
                            vc?.navigationController?.pushViewController(dvc, animated: true)
                        }else if obj_type as! Int == 1{
                            
                            let dvc = VideoContentController()
                            dvc.fid = msg_id
                            vc?.navigationController?.pushViewController(dvc, animated: true)
                             //视频
                        }else if obj_type as! Int == 2{
                            
                            let dvc = ArcticleDetailController()
                            dvc.fid = msg_id
                            vc?.navigationController?.pushViewController(dvc, animated: true)
                            //病例
                        }
                    }else{
                        let dvc =  UIStoryboard.getNewLoginController()
                        vc?.navigationController?.pushViewController(dvc, animated: true)
                    }
                   
                }
            }
          
        }
    
        JPUSHService.handleRemoteNotification(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    //系统获取Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       // setValue(deviceToken, forKey: "deviceToken")
        UserDefaults.standard.set(deviceToken, forKey: "deviceToken")
        JPUSHService.registerDeviceToken(deviceToken)
    }
    //获取token 失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { //可选
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
 
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //在应用进入后台时清除推送消息角标
        application.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        JSHAREService.handleOpen(url)
        return true
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        JSHAREService.handleOpen(userActivity.webpageURL)
        return true
        
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        print("willPresent")
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        print("didReceive")
       
        let userInfo = response.notification.request.content.userInfo
       
        JPUSHService.setBadge(0)
        if let msg_type = userInfo["msg_type"] {
            print(msg_type)
            if msg_type as! Int == 0{  //系统消息
                
            }else{         //内容消息
                if let obj_type = userInfo["obj_type"] {
                    
                    let msg_id = userInfo["msg_id"] as! Int
                    print(obj_type)
                    print(msg_id)
                    if obj_type as! Int == 0{  //系统消息
                        //文章
                    }else if obj_type as! Int == 1{
                        //视频
                    }else if obj_type as! Int == 2{
                        //病例
                    }
                }
            }
          
        }
        
        let tabController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        let nvc = tabController.selectedViewController
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        // 系统要求执行这个方法
        completionHandler()
        
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        print("openSettingsFor")
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        if ((notification) != nil) {
          //从通知界面直接进入应用
        }else{
          //从通知设置界面进入应用
        }
        
    }
    
}


//
//        let remoteNotification = launchOptions?[UIApplication.LaunchOptionsKey(rawValue: "UIApplicationLaunchOptionsRemoteNotificationKey")];
//        if (remoteNotification != nil) {
//            print(remoteNotification)
//        }

//  NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey]
