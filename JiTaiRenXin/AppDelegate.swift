//
//  AppDelegate.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/23.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import XHLaunchAd
import SwiftyJSON
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder,JPUSHRegisterDelegate, UIApplicationDelegate {
    
    let AppKey = "5323257feb478930e6081b09"
    
    var window: UIWindow?
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
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
 
        
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
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
                    print("启动图数据请求出错")
                    return
                }
                
                let responseJson = JSON(dict)
                // print(responseJson)
                let responseData = responseJson[BerResponseConstants.responseData]["start_img"].stringValue
                
                imageAdconfiguration.duration = 3;
                imageAdconfiguration.imageNameOrURLString = responseData
                //imageAdconfiguration.openModel = "http://www.it7090.com"
                XHLaunchAd.imageAd(with: imageAdconfiguration, delegate: self)
                
            //                print(Url!.absoluteString)
            //                print(responseJson)
            case .failure:
                print("启动图数据请求出错!")
            }
        })
        
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor.white
        if (stringForKey(key: Constants.token) != nil && stringForKey(key: Constants.token) != "") {
            self.window?.rootViewController =  MainTabBarController()
        }else{
            self.window?.rootViewController = UIStoryboard.getNewLoginController()
        }
        print("111111")
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            print(registrationID)
        }
        return true
    }
    
    
    //
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("22222")
    }
    
 
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("33333")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //点推送进来执行这个方法
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
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
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        // 系统要求执行这个方法
        completionHandler()
        
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        
    }
    
}
