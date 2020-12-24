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
class AppDelegate: UIResponder, UIApplicationDelegate {
  
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 
        
       
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
        
        return true
    }


//
     func applicationWillResignActive(_ application: UIApplication) {
           // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
           // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
       }

       func applicationDidEnterBackground(_ application: UIApplication) {
           // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
           // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
       }

       func applicationWillEnterForeground(_ application: UIApplication) {
           // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
       }

       func applicationDidBecomeActive(_ application: UIApplication) {
           // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       }

       func applicationWillTerminate(_ application: UIApplication) {
           // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       }


}

