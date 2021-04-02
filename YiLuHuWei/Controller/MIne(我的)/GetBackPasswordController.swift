//
//  GetBackPasswordController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/08/06.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import SwiftyJSON
import IQKeyboardManagerSwift

class GetBackPasswordController: BaseViewController,Requestable,UITextFieldDelegate {
    
    
    @IBOutlet weak var accountBgview: UIView!
    @IBOutlet weak var vertifyCodeBgview: UIView!
    @IBOutlet weak var psaawordBgview: UIView!
    @IBOutlet weak var morepsaawordBgview: UIView!
    
    @IBOutlet weak var accountText: UITextField!
    @IBOutlet weak var vertifyCodeText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var morepasswordText: UITextField!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var vertifycodeBtn: UIButton!
    
    @IBOutlet weak var sureBtn: UIButton!
    
    var isFormMine = false
    
    @IBAction func vertifycodeBtnAction(_ sender: Any) {
        
        account = accountText.text!
        
        if account.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "账号不能为空")
            return
        }
        if !(CheckoutUtils.isMobile(mobile: account)){
            DialogueUtils.showWarning(withStatus: "请输入正确的手机号")
            return
        }
        
        let pathAndParams = HomeAPI.sendFindMessagecodePathAndParams(user_login: account)
        postRequest(pathAndParams: pathAndParams,showHUD: false)
    }
    
  
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var account = ""
    var password = ""
    var code = ""
    var repassword = ""
    
  
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        if requestPath == HomeAPI.sendFindMessagecodePath{
            vertifycodeBtn.setTitle("验证码已发送", for:.normal)
            vertifycodeBtn.isEnabled = false
            vertifyCodeText.placeholder = "请输入验证码"
            vertifycodeBtn.backgroundColor = ZYJColor.Line.grey
            DialogueUtils.showSuccess(withStatus: "发送成功")
            //code = responseResult["code"].stringValue
        }else {
            
            let tipView = UIAlertController.init(title: "", message: "重置成功", preferredStyle: .alert)
            tipView.addAction(UIAlertAction.init(title: "确定", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
                UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.getNewLoginController()
 
            }))
            self.present(tipView, animated: true, completion: nil)
            //DialogueUtils.showSuccess(withStatus: "重置成功")
            
        }
        
        
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
        
    }
    
    @IBAction func sureBtnAction(_ sender: Any) {
        
        account = accountText.text!
        password = passwordText.text!
        repassword = morepasswordText.text!
        
        if account.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "账号不能为空")
            return
        }
        if !(CheckoutUtils.isMobile(mobile: account)){
            DialogueUtils.showWarning(withStatus: "请输入正确的手机号")
            return
        }
        
    
        if password != repassword{
            DialogueUtils.showError(withStatus: "两次输入密码不相同")
            return
        }

        
        code = vertifyCodeText.text!
        if code.isLengthEmpty() {
            DialogueUtils.showError(withStatus: "验证码不能为空")
            return
        }
        
        
        if password.isLengthEmpty() || repassword.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "密码不能为空")
            return
        }
        
        if !(CheckoutUtils.isPasswordNOSpecial(pwd:password)){
            showOnlyTextHUD(text: "密码应在6—16个字符之间 且不能包含特殊字符")
            return
        }
        let pathAndParams = HomeAPI.sendfindPwdCodePathAndParams(user_login: account, verification_code: code, user_pass: password)
        DialogueUtils.showWithStatus("已发送")
        postRequest(pathAndParams: pathAndParams,showHUD: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sureBtn.backgroundColor = ZYJColor.main
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        sureBtn.layer.cornerRadius = 10;
        sureBtn.layer.masksToBounds = true;
        
        vertifycodeBtn.backgroundColor = ZYJColor.main
        vertifycodeBtn.setTitle("获取验证码", for:.normal)
        vertifycodeBtn.setTitleColor(UIColor.white, for: .normal)
        vertifycodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        vertifycodeBtn.layer.cornerRadius = 15
        vertifycodeBtn.layer.masksToBounds = true
        
        if isFormMine {
            backBtn.isHidden = true
        }else{
            backBtn.isHidden = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        accountText.resignFirstResponder()
        vertifyCodeText.resignFirstResponder()
        passwordText.resignFirstResponder()
        morepasswordText.resignFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == accountText {
            if textField.text != account {
                vertifycodeBtn.backgroundColor = ZYJColor.main
                vertifycodeBtn.setTitle("获取验证码", for:.normal)
                vertifycodeBtn.isEnabled = true
                vertifyCodeText.placeholder = "请输入验证码"
            }
        }
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
