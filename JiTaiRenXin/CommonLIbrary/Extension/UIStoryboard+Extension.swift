//
//  UIStoryboard+Extension.swift
//  O2OManager
//
//  Created by zhaoyuanjing on 16/8/23.
//  Copyright © 2016年 Berchina. All rights reserved.
//

import Foundation
import UIKit

enum StoryBoardType: String {
    case Home = "Home",Channel = "Channel", Artic = "Artic",  Mine = "Mine"
}


extension UIStoryboard {
    
    class func getStoryboardByType(type: StoryBoardType) -> UIStoryboard {
         //printLog("StoryboardName: \(type.rawValue)")
         let storyboard = UIStoryboard(name: type.rawValue, bundle: nil)
         return storyboard
     }
    
    class func getMineViewController() -> MineViewController
        {
          return getStoryboardByType(type: .Mine).instantiateViewController(withIdentifier: "MineView") as! MineViewController
        }
    class func getPersonsInfoController() -> PersonsInfoController
         {
             return getStoryboardByType(type: .Mine).instantiateViewController(withIdentifier: "PersonsInfoController") as! PersonsInfoController
         }
    class func getAuthenController() -> AuthenController
        {
        return getStoryboardByType(type: .Mine).instantiateViewController(withIdentifier: "AuthenController") as! AuthenController
        }
    class func getFeedBackController() -> FeedBackController
        {
        return getStoryboardByType(type: .Mine).instantiateViewController(withIdentifier: "FeedBackController") as! FeedBackController
        }
    
    class func getAuthenSubmitedController() -> AuthenSubmitedController
        {
          return getStoryboardByType(type: .Mine).instantiateViewController(withIdentifier: "AuthenSubmitedController") as! AuthenSubmitedController
        }
  
    class func getNewLoginController() -> NewLoginController
        {
             return getStoryboardByType(type: .Mine).instantiateViewController(withIdentifier: "NewLoginController") as! NewLoginController
        }
  
    class func getGetBackPasswordController() -> GetBackPasswordController
        {
               return getStoryboardByType(type: .Mine).instantiateViewController(withIdentifier: "GetBackPasswordController") as! GetBackPasswordController
        }
    class func getComplainTypeController() -> ComplainTypeController
           {
                  return getStoryboardByType(type: .Mine).instantiateViewController(withIdentifier: "ComplainTypeController") as! ComplainTypeController
           }
    
    class func getNotifyDetailController() -> NotifyDetailController
           {
                  return getStoryboardByType(type: .Mine).instantiateViewController(withIdentifier: "NotifyDetailController") as! NotifyDetailController
           }
    
}
