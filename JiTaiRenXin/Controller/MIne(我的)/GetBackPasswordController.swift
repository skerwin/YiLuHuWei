//
//  GetBackPasswordController.swift
//  JiTaiRenXin
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
    
    
    
    @IBOutlet weak var vertifycodeBtn: UIButton!
    
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
        
        let pathAndParams = HomeAPI.sendFindMessagecodePathAndParams(mobile: account)
        postRequest(pathAndParams: pathAndParams,showHUD: false)
    }
    
    @IBOutlet weak var sureBtn: UIButton!
    
    
    
    var account = ""
    var password = ""
    var code = ""
    var repassword = ""
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        if requestPath == HomeAPI.sendFindMessagecodePath{
            vertifycodeBtn.setTitle("验证码已发送", for:.normal)
            vertifycodeBtn.isEnabled = false
            vertifyCodeText.placeholder = "请在5分钟内输入验证码"
            vertifycodeBtn.backgroundColor = ZYJColor.Line.grey
            DialogueUtils.showSuccess(withStatus: "发送成功")
            code = responseResult["code"].stringValue
        }else {
            DialogueUtils.showSuccess(withStatus: "重置成功")
            self.dismiss(animated: true, completion: nil)
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
        
        if code != vertifyCodeText.text {
            DialogueUtils.showError(withStatus: "验证码不正确")
            return
        }
        
        var tempcode = ""
        tempcode = vertifyCodeText.text!
        if tempcode.isLengthEmpty() {
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
        let pathAndParams = HomeAPI.sendfindPwdCodePathAndParams(mobile: account, sms_code: tempcode, password: password)
        DialogueUtils.showWithStatus("已发送")
        postRequest(pathAndParams: pathAndParams,showHUD: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        accountBgview.layer.cornerRadius = 5;
//        accountBgview.layer.masksToBounds = true;
//        accountBgview.layer.borderWidth = 1
//        accountBgview.layer.borderColor = ZYJColor.testLine.cgColor
//        
//        vertifyCodeBgview.layer.cornerRadius = 5;
//        vertifyCodeBgview.layer.masksToBounds = true;
//        vertifyCodeBgview.layer.borderWidth = 1
//        vertifyCodeBgview.layer.borderColor = ZYJColor.testLine.cgColor
//        
//        psaawordBgview.layer.cornerRadius = 5;
//        psaawordBgview.layer.masksToBounds = true;
//        psaawordBgview.layer.borderWidth = 1
//        psaawordBgview.layer.borderColor = ZYJColor.testLine.cgColor
//        
//        
//        morepsaawordBgview.layer.cornerRadius = 5;
//        morepsaawordBgview.layer.masksToBounds = true;
//        morepsaawordBgview.layer.borderWidth = 1
//        morepsaawordBgview.layer.borderColor = ZYJColor.testLine.cgColor
        
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
