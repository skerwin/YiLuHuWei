//
//  RegisterController.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/08/06.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import SwiftyJSON
import IQKeyboardManagerSwift

class RegisterController: BaseViewController,Requestable ,UITextFieldDelegate{
    
    @IBOutlet weak var accountBgview: UIView!
    @IBOutlet weak var vertifyCodeBgview: UIView!
    @IBOutlet weak var accountText: UITextField!
    @IBOutlet weak var vertifyCodeText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var psaawordBgview: UIView!
    
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var account = ""
    var password = ""
    
    func createRightNavItem(title:String = "返回",imageStr:String = "") {
        if imageStr == ""{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: title, style: .plain, target: self, action:  #selector(rightNavBtnClick))
        }else{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: imageStr), style: .plain, target: self, action: #selector(rightNavBtnClick))
        }
        
    }
    
    
    @objc func rightNavBtnClick(){
        
        self.dismiss(animated: true, completion: nil)
        //跳转前的操作写这里
    }
    

    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
 
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
        
    }
    
    
    
    @IBAction func registerBtn(_ sender: Any) {
        
        
        account = accountText.text!
        
        password = passwordText.text!
        let password1 = vertifyCodeText.text!
        
        if account.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "昵称不能为空")
            return
        }
        
//        if !(CheckoutUtils.isPasswordNOSpecial(pwd:account)){
//            showOnlyTextHUD(text: "昵称应在2-8个字符之间 且不能包含特殊字符")
//            return
//        }
//
        
        if password.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "密码不能为空")
            return
        }
        
        if password != password1{
            DialogueUtils.showError(withStatus: "两次密码不一致")
            return
        }
        
        
        let pathAndParams = HomeAPI.setPasswordPathAndParams(user_pass: password,user_nickname:account)
        DialogueUtils.showWithStatus("正在注册")
        postRequest(pathAndParams: pathAndParams,showHUD: false)
    }
    
    
    @IBOutlet weak var registerBtnbtn: UIButton!
    override func viewDidLoad() {
 
        super.viewDidLoad()
        self.title = "注册"
        
        
        registerBtnbtn.layer.cornerRadius = 20
        registerBtnbtn.layer.masksToBounds = true
        
//        backBtn.isHidden = true
//        backBtn.isEnabled = false
 
        // createRightNavItem(title: "返回", imageStr: "backarrow")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
//        accountText.resignFirstResponder()
//        vertifyCodeText.resignFirstResponder()
//        passwordText.resignFirstResponder()
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
  
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//class hw_TextField: NSObject, UITextFieldDelegate
