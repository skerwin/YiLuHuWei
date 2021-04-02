//
//  SettingViewController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/02/01.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class SettingViewController: BaseTableController,Requestable {

    @IBOutlet weak var hidePublishBtn: UISwitch!
    
    @IBOutlet weak var loginOutBtn: UIButton!
    @IBAction func hidePublishAction(_ sender: Any) {
 
        if hidePublishBtn.isOn == true{
            setStringValueForKey(value: "" as String, key: Constants.hidePublish)
         }else{
            setStringValueForKey(value: "hidePublish" as String, key: Constants.hidePublish)
        }
      
    }
    @IBAction func loginOut(_ sender: Any) {
  
        let requestParams = HomeAPI.logoutAccountPathAndParam()
        getRequest(pathAndParams: requestParams,showHUD: false)
     }
 
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginOutBtn.layer.cornerRadius = 5
        loginOutBtn.layer.masksToBounds = true
        
        self.title = "设置"
        let hidePublish = stringForKey(key: Constants.hidePublish)
        if hidePublish == nil{
            setStringValueForKey(value: "hidePublish" as String, key: Constants.hidePublish)
        }
        if hidePublish == "" {
            hidePublishBtn.isOn = true
        }
        if hidePublish == "hidePublish" {
            hidePublishBtn.isOn = false
        }
       
 
    }
    override func onFailure(responseCode: String, description: String, requestPath: String) {
  
        tableView.mj_header?.endRefreshing()
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
        tableView.mj_header?.endRefreshing()
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
 
            JPUSHService.getAlias({ (iResCode, iAlias, seq) in
                print("iResCode---\(iResCode)")
                print("11getiAlias---\(iAlias ?? "")")
                print("seq---\(seq)")
            }, seq: 10000)
            
             JPUSHService.deleteAlias({ (iResCode, iAlias, seq) in
                print("iResCode---\(iResCode)")
                print("deleteiAlias---\(iAlias ?? "")")
                print("seq---\(seq)")
            }, seq: 10000)
            
            JPUSHService.getAlias({ (iResCode, iAlias, seq) in
                print("iResCode---\(iResCode)")
                print("22getiAlias---\(iAlias ?? "")")
                print("seq---\(seq)")
            }, seq: 10000)
 
            self.logoutAccount(account: "")
            showOnlyTextHUD(text: "账号已退出登录")
            loginOutBtn.isHidden = true
            UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
          
       
 
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1{
            let controller = UIStoryboard.getGetBackPasswordController()
            controller.isFormMine = true
            self.navigationController?.pushViewController(controller, animated: true)
        }else if indexPath.row == 2{
            let conroller = AboutYiLuHuWeiController()
            self.navigationController?.pushViewController(conroller, animated: true)
        }else if indexPath.row == 3{
            if clearMyCache(){
                DialogueUtils.showSuccess(withStatus: "清除成功")
            }else{
                DialogueUtils.showSuccess(withStatus: "成功清除")
            }
        }
        else if indexPath.row == 4{
            let conroller = PrivateStatusViewController()
            self.navigationController?.pushViewController(conroller, animated: true)
        }
      
    }


}
