//
//  MineViewController.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/29.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import IQKeyboardManagerSwift
import SwiftyJSON
import ObjectMapper

class MineViewController: BaseTableController,Requestable{
    
    
    @IBOutlet weak var step3View: UIView!
    @IBOutlet weak var step2View: UIView!
    @IBOutlet weak var step1View: UIView!
    @IBOutlet weak var nameBgview: UIView!
    @IBOutlet weak var notifyImage: UIImageView!
    @IBOutlet weak var nameLbel: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var goodBgview: UIView!
    
    @IBOutlet weak var careBgview: UIView!
    
    @IBOutlet weak var complainBgview: UIView!
    
    var usermodel = UserModel()
    
    @IBAction func logoutAction(_ sender: Any) {
        
        let requestParams = HomeAPI.logoutAccountPathAndParams()
        getRequest(pathAndParams: requestParams,showHUD: false)
    }
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        step2View.alpha = 0.75
        step3View.alpha = 0.35
        nameBgview.backgroundColor = ZYJColor.main
        addGestureRecognizerToView(view: goodBgview, target: self, actionName: "goodBgviewAction")
        addGestureRecognizerToView(view: careBgview, target: self, actionName: "careBgviewAction")
        addGestureRecognizerToView(view: complainBgview, target: self, actionName: "complainBgviewAction")
        addGestureRecognizerToView(view: notifyImage, target: self, actionName: "notifyImageAction")
        addGestureRecognizerToView(view: nameLbel, target: self, actionName: "nameLbelAction")
        
        logoutBtn.backgroundColor = ZYJColor.main
        logoutBtn.layer.cornerRadius = 5;
        logoutBtn.layer.masksToBounds = true
        
        headImage.layer.cornerRadius = 29;
        headImage.layer.masksToBounds = true
        
        loadInfoData()
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh
        
        if currentIsLogin() {
            logoutBtn.isHidden = false
        }else{
            self.nameLbel.text = "登录/注册"
            logoutBtn.isHidden = true
        }
        
        let avater = stringForKey(key: Constants.avatar)
        if avater != nil && !(avater?.isLengthEmpty())!{
            headImage.displayHeadImageWithURL(url: avater)
        }
    }
    @objc func refreshList() {
        loadInfoData()
    }
    
    func loadInfoData(){
        
        guard let userId = objectForKey(key: Constants.userid) else{
            tableView.mj_header?.endRefreshing()
            return
        }
        if userId is NSNull {
            tableView.mj_header?.endRefreshing()

        }else{
            let requestParams = HomeAPI.personsCenterPathAndParams()
            getRequest(pathAndParams: requestParams,showHUD: false)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: ZYJColor.main), for: UIBarMetrics.default)
//                  self.navigationController?.navigationBar.isTranslucent = false
//                  self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: ZYJColor.main)
        self.title = "我的"
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
  
        tableView.mj_header?.endRefreshing()
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
        tableView.mj_header?.endRefreshing()
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        if requestPath == HomeAPI.logoutAccount {
            
            self.logoutAccount(account: "")
            logoutBtn.isHidden = true
            self.nameLbel.text = "登录/注册"
            self.headImage.displayHeadImageWithURL(url: "")
            tableView.reloadData()
            
           // UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.getNewLoginController()
            
            
            return
        }
        
        usermodel = Mapper<UserModel>().map(JSONObject: responseResult["user"].rawValue)
        
        setValueForKey(value: usermodel?.avatar as AnyObject, key: Constants.avatar)
        setValueForKey(value: usermodel?.avatar_url as AnyObject, key: Constants.avatar_url)
        setValueForKey(value: usermodel?.doctorModel?.check_status as AnyObject, key: Constants.isCheck)
        setValueForKey(value: usermodel?.realname as AnyObject, key: Constants.truename)
        setValueForKey(value: usermodel?.nickname as AnyObject, key: Constants.nickname)
        setValueForKey(value: usermodel?.sex as AnyObject, key: Constants.gender)
        
        let name = stringForKey(key: Constants.truename)
        let nickname = stringForKey(key: Constants.nickname)
        let phone = stringForKey(key: Constants.account)
        headImage.displayHeadImageWithURL(url: usermodel?.avatar_url)
        if nickname != nil && !(nickname?.isLengthEmpty())!{
            self.nameLbel.text = nickname
        }else if name != nil && !(name?.isLengthEmpty())!{
            self.nameLbel.text = name
        }else{
            self.nameLbel.text = phone
        }
        logoutBtn.isHidden = false
        
    }
    
    @objc override func tokenChange(note: NSNotification){
        self.logoutAccount(account: "")
        logoutBtn.isHidden = true
        self.nameLbel.text = "登录/注册"
        self.headImage.displayHeadImageWithURL(url: "")
        tableView.mj_header?.endRefreshing()
        if note.object != nil {
            if self.currentIsLogin() == true {
                self.showSingleButtonAlertDialog(message: "您的账号已在其他终端登陆，或账号已被修改，请重新登录") { (type) in
                    //self.logoutAccount(account: "")
                  
                    self.pushLoginController()
                }
            }
        }
    }
    
    
    @objc func goodBgviewAction(){
        if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
        let conroller = ChannelViewController()
        conroller.menupagetype = MenuPageType.MineGood
        self.navigationController?.pushViewController(conroller, animated: true)
        
    }
    @objc func careBgviewAction(){
        if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
        let vc = ChannelViewController()
        vc.menupagetype = MenuPageType.MineCare
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func complainBgviewAction(){
        if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
        let conroller = ComplainCommentController()
            //ComplainController()
        self.navigationController?.pushViewController(conroller, animated: true)
        
        
    }
    @objc func notifyImageAction(){
        if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
        let conroller = NotifyController()
        self.navigationController?.pushViewController(conroller, animated: true)
        
    }
    @objc func nameLbelAction(){
        
        if currentIsLogin() {
            let controller = UIStoryboard.getPersonsInfoController()
            controller.userModel = self.usermodel
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            self.pushLoginController()
        }
    }
    
    override func pushLoginController(){
        let controller = UIStoryboard.getNewLoginController()
        controller.modalPresentationStyle = .fullScreen
        
        controller.reloadLogin = {[weak self] () -> Void in
            let userId = objectForKey(key: Constants.userid)
            if userId is NSNull {
             }else{
                let name = stringForKey(key: Constants.truename)
                let nickname = stringForKey(key: Constants.nickname)
                let phone = stringForKey(key: Constants.account)
                if nickname != nil && !(nickname?.isLengthEmpty())!{
                    self?.nameLbel.text = nickname
                }else if name != nil && !(name?.isLengthEmpty())!{
                    self?.nameLbel.text = name
                }else{
                    self?.nameLbel.text = phone
                }
                let avater = stringForKey(key: Constants.avatar)
                if avater != nil && !(avater?.isLengthEmpty())!{
                    self?.headImage.displayHeadImageWithURL(url: avater)
                }
                self!.logoutBtn.isHidden = false
             }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1{
            return 4
        }
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.1
        }else{
            return 10
        }
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    } 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        if section == 1 {
            if row == 0{
                if !currentIsLogin()  {
                    self.pushLoginController()
                    return
                }
                if usermodel?.doctorModel?.check_status == 1{
                    let conroller = UIStoryboard.getAuthenController()
                    conroller.isFormMine = true
                    self.navigationController?.pushViewController(conroller, animated: true)
                }else if usermodel?.doctorModel?.check_status == 2{
            
                    DialogueUtils.showWarning(withStatus: "正在审核，请耐心等待")
                }else if usermodel?.doctorModel?.check_status == 4{
                    DialogueUtils.showWarning(withStatus: "认证已审核通过")
                }else if usermodel?.doctorModel?.check_status == 3{
                    
                    let conroller = UIStoryboard.getAuthenController()
                    conroller.isFormMine = true
                    self.navigationController?.pushViewController(conroller, animated: true)
                    //DialogueUtils.showWarning(withStatus: "审核未通过，请联系客服")
                }
               
            }else if row == 2{
                // showOnlyTextHUD(text: "nihaoha")
                if clearMyCache(){
                    DialogueUtils.showSuccess(withStatus: "清除成功")
                }else{
                    DialogueUtils.showSuccess(withStatus: "成功清除")
                }
            }else if row == 3{
                let conroller = AboutJiTaiRenXinController()
                self.navigationController?.pushViewController(conroller, animated: true)
               //AboutJiTaiRenXinController
                
            }else if row == 1{
                 let conroller = PrivateStatusViewController()
                 self.navigationController?.pushViewController(conroller, animated: true)
            }
            
        }
        
        //        let conroller = NotifyController()
        //
        
    }
    
}

