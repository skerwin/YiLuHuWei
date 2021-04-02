//
//  NewLoginController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/10/19.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import ObjectMapper

class NewLoginController: BaseViewController,Requestable {
    
    @IBOutlet weak var forgetBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var accountTextF: UITextField!
    
    @IBOutlet weak var passwordTextF: UITextField!
    
    @IBOutlet weak var verCodeBtn: UIButton!
    
    
    @IBOutlet weak var changeloginStyleBtn: UIButton!
    
    //之后要删除的方法
    @IBOutlet weak var backBtn: UIButton!
    
    var isCodeLogin = true
    
    var isFromMine = false
    
    @IBAction func changeloginStyleBtnAction(_ sender: Any) {
        
        if isCodeLogin == true{
            isCodeLogin = false
            verCodeBtn.isHidden = true
            accountTextF.text = ""
            passwordTextF.text = ""
            changeloginStyleBtn.setTitle("验证码登录", for: .normal)
            passwordTextF.placeholder = "请输入密码"
            passwordTextF.isSecureTextEntry = true
 
        }else{
            accountTextF.text = ""
            passwordTextF.text = ""
            isCodeLogin = true
            verCodeBtn.isHidden = false
            passwordTextF.isSecureTextEntry = false
            changeloginStyleBtn.setTitle("密码登录", for: .normal)
            passwordTextF.placeholder = "请输入验证码"
        }
    }
    
    
    
    
    var reloadLogin:(() -> Void)?
    
    var verCode = ""
    var account = ""
    var password = ""
    
    var usermodel = UserModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        loadPrivateAndAbouutUs()
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.masksToBounds = true
        verCodeBtn.titleLabel?.text = "获取验证码"
        verCodeBtn.setTitle("获取验证码", for: .normal)
        verCodeBtn.setTitleColor(ZYJColor.main, for: .normal)
        
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.titleLabel?.text = "登录"
    
        
    }
    @IBAction func verCodeBtnAction(_ sender: Any) {
        getVertifycodeBtnAction()
    }
    
    
    
    func loadPrivateAndAbouutUs() {
        
        let requestParamsP = HomeAPI.privacyStatementAndParam()
        getRequest(pathAndParams: requestParamsP,showHUD: false)
        
        let requestParamsA = HomeAPI.aboutUsPathAndParam()
        getRequest(pathAndParams: requestParamsA,showHUD: false)
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        
        if (reloadLogin != nil) {
            self.reloadLogin!()
        }
       
  
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forgetPwdAction(_ sender: Any) {
        let controller = UIStoryboard.getGetBackPasswordController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func privateAgreement(_ sender: Any) {
        let conroller = PrivateStatusViewController()
        self.present(conroller, animated: true, completion: nil)
    }
     
    
    @IBAction func loginBtnAction(_ sender: Any) {
        account = accountTextF.text!
        
        if account.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "账号不能为空")
            return
        }
        
        if !(CheckoutUtils.isMobile(mobile: account)){
            DialogueUtils.showWarning(withStatus: "请输入正确的手机号")
            return
        }
        if isCodeLogin {
            
            verCode = passwordTextF.text!
            if verCode.isLengthEmpty() {
                DialogueUtils.showError(withStatus: "验证码不能为空")
                return
            }
            
            let pathAndParams = HomeAPI.loginCodeRegisterPathAndParams(mobile: account, verificationCode: verCode)
            DialogueUtils.showWithStatus("正在登录")
            postRequest(pathAndParams: pathAndParams,showHUD: false)
 
        }else{
            password = passwordTextF.text!
            if password.isLengthEmpty(){
                DialogueUtils.showError(withStatus: "密码不能为空")
                return
            }
            
            if !(CheckoutUtils.isPasswordNOSpecial(pwd:password)){
                showOnlyTextHUD(text: "密码应在6—16个字符之间 且不能包含特殊字符")
                return
            }
            
            let pathAndParams = HomeAPI.passwordRegisterPathAndParams(user_login: account, user_pass: password)
            DialogueUtils.showWithStatus("正在登录")
            postRequest(pathAndParams: pathAndParams,showHUD: false)
            
            
        }
    }
    
    
    
    func getVertifycodeBtnAction(){
        account = accountTextF.text!
        if account.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "账号不能为空")
            return
        }
        if !(CheckoutUtils.isMobile(mobile: account)){
            DialogueUtils.showWarning(withStatus: "请输入正确的手机号")
            return
        }
        let pathAndParams = HomeAPI.sendCodePathPathAndParams(mobile: account)
        postRequest(pathAndParams: pathAndParams,showHUD: false)
    }
    
    
    
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        //ischeck 是否审核  0 未审核  1  审核中  2 通过审核 3 审核为通过
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        if requestPath == HomeAPI.sendCodePath{
            
            DialogueUtils.showSuccess(withStatus: "发送成功")
            
            verCodeBtn.titleLabel?.text = "验证码已发送"
            verCodeBtn.setTitle("验证码已发送", for: .normal)
            verCodeBtn.setTitleColor(UIColor.darkGray, for: .normal)
            passwordTextF.placeholder = "请在5分钟内输入"
            
            
            
            // verCode = responseResult["code"].stringValue
        } else if requestPath == HomeAPI.loginCodeRegisterPath || requestPath == HomeAPI.passwordRegisterPath{
            
            usermodel = Mapper<UserModel>().map(JSONObject: responseResult["user"].rawValue)
            let token = responseResult["token"].stringValue
            let adzoneId = usermodel?.id
            let phone = usermodel?.mobile
            
            setValueForKey(value: usermodel?.avatar_url as AnyObject, key: Constants.avatar)
            //setValueForKey(value: usermodel?.doctorModel?.check_status as AnyObject, key: Constants.isCheck)
            setValueForKey(value: usermodel?.user_realname as AnyObject, key: Constants.truename)
            setValueForKey(value: usermodel?.user_nickname as AnyObject, key: Constants.nickname)
            setValueForKey(value: usermodel?.sex as AnyObject, key: Constants.gender)
            saveAccountAndPassword(account: phone!, password: password, token: token, userid: adzoneId!)
            
            if usermodel?.need_pwd == 1{
                let controller = UIStoryboard.getRegisterController()
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }else {
                
                if isFromMine {
                    self.reloadLogin!()
                    self.dismiss(animated: true, completion: nil)
                }else{
                    UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
                }
                 
            }
         }
        if requestPath == HomeAPI.privacyStatement{
             setStringValueForKey(value: responseResult["url"].stringValue as String, key: "privacy_url")
             return
        }
        if requestPath == HomeAPI.aboutUsPath{
             setStringValueForKey(value: responseResult["url"].stringValue as String, key: "about_url")
             return
        }
        else {
         
            let account = responseResult["mobile"].stringValue
            let password = responseResult["password"].stringValue
            setValueForKey(value: account as AnyObject, key: Constants.account)
            setValueForKey(value: password as AnyObject, key: Constants.password)
      
            
        }
        
        
        
        
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    
    
    //    func sendCode() {
    //        getVertifycodeBtnAction()
    //    }
    
    
}
