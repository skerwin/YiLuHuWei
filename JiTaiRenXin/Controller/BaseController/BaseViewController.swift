//
//  BaseViewController.swift
//  BossJob
//
//  Created by zhaoyuanjing on 2017/09/26.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDCycleScrollView


class BaseViewController: UIViewController,AlertPresenter,LoadingPresenter,AccountAndPasswordPresenter{
    
    
    
    let topAdvertisementViewHeight = screenWidth * 0.4
    
    let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    
    var pagenum = 10
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //去掉导航栏箭头旁边的字
        self.view.backgroundColor = .white
        
        self.navigationItem.backBarButtonItem = item;
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenChange(note:)), name: NSNotification.Name(rawValue: Constants.TokenChangeRefreshNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenDlete(note:)), name: NSNotification.Name(rawValue: Constants.TokenChangeDeleteNotification), object: nil)
        
    }
 
    
    func forLoginController() {
        self.pushLoginController()
        return
    }
    
    
    @objc func tokenDlete(note: NSNotification){
        
        self.logoutAccount(account: "")
        self.showSingleButtonAlertDialog(message: "您的账号已在其他终端登陆，或账号已被修改，请重新登录") { (type) in
            self.logoutAccount(account: "")
            self.pushLoginController()
        }
    }
    
    
    @objc func tokenChange(note: NSNotification){
        self.logoutAccount(account: "")
        self.showSingleButtonAlertDialog(message: "您的账号已在其他终端登陆，或账号已被修改，请重新登录") { (type) in
            self.logoutAccount(account: "")
            self.pushLoginController()
        }
    }
    
    
    
    override func loadView() {
        super.loadView()
        
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = true
        
        
        self.view.autoresizesSubviews = true
        self.view.autoresizingMask    = [ .flexibleWidth, .flexibleHeight ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func currentIsLogin() -> Bool {
        if (stringForKey(key: Constants.token) != nil && stringForKey(key: Constants.token) != "") {
            return true
        }else{
            return false
        }
    }
    
    
    
    func pushLoginController(){
        let controller = UIStoryboard.getNewLoginController()
            //UIStoryboard.getLoginController()
        controller.modalPresentationStyle = .fullScreen
//        controller.reloadLogin = {[weak self] () -> Void in
//
//        }
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        
        DialogueUtils.dismiss()
    }
    func onFailure(responseCode: String, description: String, requestPath: String) {
        DialogueUtils.dismiss()
        showOnlyTextHUD(text: description)
        // DialogueUtils.showError(withStatus: description)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.resignFirstResponder()
    }
    
    
    //收键盘注册点击事件
    func backKeyBoard(){
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))
    }
    
    //对应方法
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            //  你的textfield.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    //自定义导航栏之后会失去全屏滑动返回效果
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
