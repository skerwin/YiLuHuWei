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
    
    
    
    let topAdvertisementViewHeight = screenWidth * 0.42
    
    let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    
    var pagenum = 10
    var page = 1
    var limit = 10
    
    lazy var floatingView: UIView = {
        
        let normalButton:UIButton = UIButton(type: UIButton.ButtonType.system)
        //normalButton.backgroundColor = .red
        normalButton.frame = CGRect(x: 0, y: 0, width: 68, height: 68)
        normalButton.layer.cornerRadius = 34
        normalButton.addTarget(self, action: #selector(printer(_:)), for: .touchUpInside)
        normalButton.setBackgroundImage(UIImage.init(named: "fabuAction"), for: .normal)
        normalButton.setBackgroundImage(UIImage.init(named: "fabuAction"), for: .selected)
        var floatingView = UIView.init(frame: CGRect(x: screenWidth - 85, y: screenHeight - 250, width: 68, height: 68))
        
        floatingView.addSubview(normalButton)
        
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture(panGesture:)))
        panGesture.cancelsTouchesInView = false
        floatingView.addGestureRecognizer(panGesture)
        return floatingView
    }()
    
    @objc private func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .began {
            //self.delegate?.viewDraggingDidBegin(view: self.floatingView, in: self.floatingWindow)
        }
        
        if panGesture.state == .ended {
            let point = panGesture.translation(in: self.view)
            var newPoint = CGPoint(x: self.floatingView.center.x + point.x, y: self.floatingView.center.y + point.y)
            if newPoint.x < self.view.bounds.width / 2.0 {
                newPoint.x = 40.0
            } else {
                newPoint.x = self.view.bounds.width - 40.0
            }
            if newPoint.y <= 40.0 {
                newPoint.y = 40.0
            } else if newPoint.y >= self.view.bounds.height - 40.0 {
                newPoint.y = self.view.bounds.height - 40.0
            }
            // 0.5秒 吸边动画
            UIView.animate(withDuration: 0.5) {
                self.floatingView.center = newPoint
            }
        }
        if panGesture.state == .changed{
            // floatBtn 获取移动轨迹
            let translation = panGesture.location(in: self.floatingView)
            self.floatingView.center = CGPoint(x: self.floatingView.center.x + translation.x, y: self.floatingView.center.y + translation.y)
        }
        panGesture.setTranslation(.zero, in: self.view)
    }
 
    
    @objc func printer(_ btn: UIButton){
        let controller = UIStoryboard.getPostViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        floatingView.isHidden = true
        
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        floatingView.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //去掉导航栏箭头旁边的字
        self.view.backgroundColor = ZYJColor.tableViewBg
        self.navigationItem.backBarButtonItem = item;
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenChange(note:)), name: NSNotification.Name(rawValue: Constants.TokenChangeRefreshNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenDlete(note:)), name: NSNotification.Name(rawValue: Constants.TokenChangeDeleteNotification), object: nil)
       
    }
    
    
    func forLoginController() {
        self.pushLoginController()
        return
    }
    
    func isNative() -> Bool{
        if (stringForKey(key: "ios_orig") != nil && stringForKey(key: "ios_orig") != "" && stringForKey(key: "ios_orig") == "1") {
            return true
        }else{
            return false
        }
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
        self.showSingleButtonAlertDialog(message: "您的账号已在其他终端登陆，或账号已退出，请重新登录") { (type) in
            self.logoutAccount(account: "")
            self.pushLoginController()
        }
    }
    
    override func loadView() {
        super.loadView()
        //
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = true
        
        
        self.view.autoresizesSubviews = true
        self.view.autoresizingMask    = [ .flexibleWidth, .flexibleHeight ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func currentIsLogin() -> Bool {
        if (stringForKey(key: Constants.token) != nil && stringForKey(key: Constants.token) != "") {
            return true
        }else{
            return false
        }
    }
    
    
    
    func pushLoginController(){
        
        UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
//        let controller = UIStoryboard.getNewLoginController()
//        controller.modalPresentationStyle = .fullScreen
//        self.present(controller, animated: true, completion: nil)
    }
    
    
    func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        
        DialogueUtils.dismiss()
    }
    func onFailure(responseCode: String, description: String, requestPath: String) {
        DialogueUtils.dismiss()
        showOnlyTextHUD(text: description)
    }
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    //        self.view.resignFirstResponder()
    //    }
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
    
}
