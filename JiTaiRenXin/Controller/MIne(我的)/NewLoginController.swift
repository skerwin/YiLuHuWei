//
//  NewLoginController.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/10/19.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import ObjectMapper

class NewLoginController: BaseViewController, UITableViewDelegate, UITableViewDataSource,Requestable {
    
    @IBOutlet weak var forgetBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    var isLogin = true
    
    @IBOutlet weak var loginSlider: UIView!
    @IBOutlet weak var registeSlider: UIView!
    
    var leftLineShape = CAShapeLayer()
    var rightLineShape = CAShapeLayer()
    
    
    @IBOutlet weak var loginTitleBtn: UIButton!
    @IBOutlet weak var registerTitleBtn: UIButton!
    
    
    var reloadLogin:(() -> Void)?
    
    var correctCode = ""
    var verCode = ""
    var account = ""
    var password = ""
    
    var usermodel = UserModel()
    
    @IBOutlet var InputTableVIew: UITableView!
    
    @IBAction func loginTitleBtnAction(_ sender: Any) {
 
        isLogin = true
        changeUI(login: isLogin)
        
        let accountCell = InputTableVIew.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! LoginAcctountCell
        accountCell.accountTextField.text = ""
        
        let codeCell = InputTableVIew.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! LoginCodeCell
        codeCell.codeTextView.text = ""
        
        let pwdCell = InputTableVIew.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! LoginPwdCell
        pwdCell.pwdTextField.text = ""
         
        InputTableVIew.reloadData()
        self.leftBorder(view: InputTableVIew, width: 0.5, borderColor:ZYJColor.main, height: InputTableVIew.frame.size.height - 60)
        self.rightBorder(view: InputTableVIew, width: 0.5, borderColor:ZYJColor.main, height: InputTableVIew.frame.size.height - 60)
        
    }
    
    @IBAction func registerTitleBtnAction(_ sender: Any) {
        isLogin = false
        changeUI(login: isLogin)
        
        let accountCell = InputTableVIew.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! LoginAcctountCell
        accountCell.accountTextField.text = ""
        
 
        let pwdCell = InputTableVIew.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! LoginPwdCell
        pwdCell.pwdTextField.text = ""
        
 
        InputTableVIew.reloadData()
        self.leftBorder(view: InputTableVIew, width: 0.5, borderColor:ZYJColor.main, height: InputTableVIew.frame.size.height)
        self.rightBorder(view: InputTableVIew, width: 0.5, borderColor:ZYJColor.main, height: InputTableVIew.frame.size.height)
        
        let codeCell = InputTableVIew.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! LoginCodeCell
        codeCell.codeTextView.text = ""
        codeCell.codeBtn.setTitle("获取验证码", for:.normal)

    }
    
    func changeUI(login:Bool)
    {
        if login {
            loginBtn.setTitle("登录", for: .normal)
            loginBtn.titleLabel?.text = "登录"
            loginSlider.backgroundColor = ZYJColor.main
            registeSlider.backgroundColor = UIColor.white
            loginTitleBtn.setTitleColor(ZYJColor.main, for: .normal)
            registerTitleBtn.setTitleColor(UIColor.black, for: .normal)
            forgetBtn.isHidden = false
        }else{
            loginBtn.setTitle("注册", for: .normal)
            loginBtn.titleLabel?.text = "注册"
            loginSlider.backgroundColor =  UIColor.white
            registerTitleBtn.setTitleColor(ZYJColor.main, for: .normal)
            loginTitleBtn.setTitleColor(UIColor.black, for: .normal)
            registeSlider.backgroundColor = ZYJColor.main
            forgetBtn.isHidden = true
        }
    }
    
//    @IBAction func backAction(_ sender: Any) {
//        self.reloadLogin!()
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func forgetPwdAction(_ sender: Any) {
        let controller = UIStoryboard.getGetBackPasswordController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func privateAgreement(_ sender: Any) {
        let conroller = PrivateStatusViewController()
        self.present(conroller, animated: true, completion: nil)
    }
    
    //设置右边框
    public func rightBorder(view:UIView,width:CGFloat,borderColor:UIColor,height:CGFloat){
        let rect = CGRect(x: view.frame.size.width - width, y: 0, width: width, height: height)
        
        let line = UIBezierPath(rect: rect)
        rightLineShape.path = line.cgPath
        rightLineShape.fillColor = borderColor.cgColor
        view.layer.addSublayer(rightLineShape)
    }
    //设置左边框
    public func leftBorder(view:UIView,width:CGFloat,borderColor:UIColor,height:CGFloat){
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let line = UIBezierPath(rect: rect)
        leftLineShape.path = line.cgPath
        leftLineShape.fillColor = borderColor.cgColor
        view.layer.addSublayer(leftLineShape)
        // drawBorder(view: view, rect: rect, color: borderColor)
    }
 
    
    func loadCommonData(){
        let CommonDataParams = HomeAPI.CommonDataPathPathAndParams()
        getRequest(pathAndParams: CommonDataParams,showHUD: true)
     }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        
        
        
        if account.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "账号不能为空")
            return
        }
        if password.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "密码不能为空")
            return
        }
        if !(CheckoutUtils.isMobile(mobile: account)){
            DialogueUtils.showWarning(withStatus: "请输入正确的手机号")
            return
        }
        if isLogin {
            
            let pathAndParams = HomeAPI.LoginPathAndParams(mobile: account, password: password)
              DialogueUtils.showWithStatus("正在登录")
              postRequest(pathAndParams: pathAndParams,showHUD: false)
        }else{
            if verCode.isLengthEmpty() {
                DialogueUtils.showError(withStatus: "验证码不能为空")
                return
            }

            
            if !(CheckoutUtils.isPasswordNOSpecial(pwd:password)){
                showOnlyTextHUD(text: "密码应在6—16个字符之间 且不能包含特殊字符")
                return
            }
            
            let pathAndParams = HomeAPI.sendRegisterPathAndParams(mobile: account, sms_code: verCode, password: password)
            DialogueUtils.showWithStatus("正在注册")
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }
    }
    
    func getVertifycodeBtnAction(){
        if account.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "账号不能为空")
            return
        }
        if !(CheckoutUtils.isMobile(mobile: account)){
            DialogueUtils.showWarning(withStatus: "请输入正确的手机号")
            return
        }
        let pathAndParams = HomeAPI.sendRegisterMessagecodePathAndParams(mobile: account)
        postRequest(pathAndParams: pathAndParams,showHUD: false)
    }
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        //ischeck 是否审核  0 未审核  1  审核中  2 通过审核 3 审核为通过
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)

        if requestPath == HomeAPI.sendRegisterMessagecodePath{
            
            DialogueUtils.showSuccess(withStatus: "发送成功")
            let codeCell = InputTableVIew.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! LoginCodeCell
            codeCell.codeBtn.setTitle("验证码已发送", for:.normal)
            codeCell.codeBtn.isEnabled = false
            codeCell.codeTextView.placeholder = "请在5分钟内输入"
            codeCell.codeBtn.backgroundColor = ZYJColor.Line.grey
            
            correctCode = responseResult["code"].stringValue
        } else if requestPath == HomeAPI.LoginPath{
            
            usermodel = Mapper<UserModel>().map(JSONObject: responseResult["user"].rawValue)
            let token = responseResult["token"].stringValue
            let adzoneId = usermodel?.id
            let phone = usermodel?.mobile
            
            setValueForKey(value: usermodel?.avatar_url as AnyObject, key: Constants.avatar)
            setValueForKey(value: usermodel?.doctorModel?.check_status as AnyObject, key: Constants.isCheck)
            setValueForKey(value: usermodel?.realname as AnyObject, key: Constants.truename)
            setValueForKey(value: usermodel?.nickname as AnyObject, key: Constants.nickname)
            setValueForKey(value: usermodel?.sex as AnyObject, key: Constants.gender)
            saveAccountAndPassword(account: phone!, password: password, token: token, userid: adzoneId!)
            
            
            JPUSHService.setAlias("\(adzoneId!)", completion: { (iResCode, iAlias, seq) in
                                    print("iResCode---\(iResCode)")
                                    print("iAlias---\(iAlias ?? "")")
                                    print("seq---\(seq)")
                                }, seq: 10000)
            
            //DialogueUtils.showSuccess(withStatus: "登陆成功")
            UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
            
        }  else if requestPath == HomeAPI.CommonDataPath{
            setIntValueForKey(value: responseResult["article_slide"].intValue as Int, key: "article_slide")
            setIntValueForKey(value: responseResult["case_slide"].intValue as Int, key: "case_slide")
            setIntValueForKey(value: responseResult["video_slide"].intValue as Int, key: "video_slide")
            
            setStringValueForKey(value: responseResult["privacy_url"].stringValue as String, key: "privacy_url")
            setStringValueForKey(value: responseResult["about_url"].stringValue as String, key: "about_url")
            return
        }else {
//            DialogueUtils.showSuccess(withStatus: "注册成功")
//            self.loginTitleBtnAction(UIButton())
//            //self.reloadLogin!()
//            //self.dismiss(animated: true, completion: nil)
            
            
            
            let account = responseResult["mobile"].stringValue
            let password = responseResult["password"].stringValue
            setValueForKey(value: account as AnyObject, key: Constants.account)
            setValueForKey(value: password as AnyObject, key: Constants.password)
            
            let controller = UIStoryboard.getAuthenController()
            let navController = MainNavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
            
        }
        
        
       
 
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCommonData()
        forgetBtn.isHidden = false
        loginSlider.backgroundColor = ZYJColor.main
        registeSlider.backgroundColor = UIColor.white
        loginTitleBtn.setTitleColor(ZYJColor.main, for: .normal)
        registerTitleBtn.setTitleColor(UIColor.black, for: .normal)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.titleLabel?.text = "登录"
        
        InputTableVIew.delegate = self
        InputTableVIew.dataSource = self
        InputTableVIew.bounces = false
        InputTableVIew.separatorStyle = .none
        InputTableVIew.showsVerticalScrollIndicator = false
        
        InputTableVIew.layer.cornerRadius = 6;
        InputTableVIew.layer.masksToBounds = true;
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: loginBtn.frame.width, height: loginBtn.frame.height), byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue), cornerRadii: CGSize(width: 7, height: 7)).cgPath
        
        loginBtn.layer.mask = shapeLayer
        
        self.leftBorder(view: InputTableVIew, width: 0.5, borderColor:ZYJColor.main, height: InputTableVIew.frame.size.height - 60)
        self.rightBorder(view: InputTableVIew, width: 0.5, borderColor:ZYJColor.main, height: InputTableVIew.frame.size.height - 60)
        
        
        InputTableVIew.registerNibWithTableViewCellName(name: LoginAcctountCell.nameOfClass)
        InputTableVIew.registerNibWithTableViewCellName(name: LoginCodeCell.nameOfClass)
        InputTableVIew.registerNibWithTableViewCellName(name: LoginPwdCell.nameOfClass)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        InputTableVIew.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: LoginAcctountCell.nameOfClass) as! LoginAcctountCell
            cell.selectionStyle = .none
            cell.delegate = self
            
            return cell
            
        }else if indexPath.row == 1{
            if isLogin {
                let  cellID = "blankCell";
                var  cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellID)
                if (cell==nil) {
                    cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellID);
                }
                cell.textLabel?.text = ""
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: LoginCodeCell.nameOfClass) as! LoginCodeCell
                cell.selectionStyle = .none
                cell.delegate = self
               
                return cell
            }
            
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: LoginPwdCell.nameOfClass) as! LoginPwdCell
            cell.selectionStyle = .none
            cell.delegate = self
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            if isLogin {
                return 10
            }
            return 60
        }
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        cell?.isSelected = false
    }
    
}
extension NewLoginController:LoginAcctountCellDelegate {
    func saveToAccount(text:String){
        account = text
    }
    
}
extension NewLoginController:LoginPwdCellDelegate {
    func saveToPwd(text:String){
        password = text
    }
    
}
extension NewLoginController:LoginCodeCellDelegate {
    func saveToCode(text: String) {
        verCode = text
        
    }
    
    func sendCode() {
        getVertifycodeBtnAction()
    }
    
    
}
