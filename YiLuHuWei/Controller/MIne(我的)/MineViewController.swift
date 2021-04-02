//
//  MineViewController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/07/29.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import IQKeyboardManagerSwift
import SwiftyJSON
import ObjectMapper
import SDCycleScrollView

class MineViewController: BaseTableController,Requestable{
    
    
    @IBOutlet weak var section1View: UIView!
    @IBOutlet weak var section2View: UIView!
    @IBOutlet weak var nameBgview: UIView!
    @IBOutlet weak var nameLbel: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var headBgview: UIView!
    
    
    @IBOutlet weak var identiImage: UIImageView!
    
    
    @IBOutlet weak var perinfoBtn: UIButton!
  
    @IBOutlet weak var publishBgView: UIView!
    @IBOutlet weak var noteBgView: UIView!
    
    @IBOutlet weak var careBgview: UIView!
    @IBOutlet weak var goodBgview: UIView!
    
    @IBOutlet weak var columnForCareBgview: UIView!
    
    @IBOutlet weak var identifyDoctorBgview: UIView!
    //@IBOutlet weak var settingBgview: UIView!
    @IBOutlet weak var attentionBgview: UIView!
    
    @IBOutlet weak var feedbackBgview: UIView!
    @IBOutlet weak var codeShareBgview: UIView!
    @IBOutlet weak var shieldBgview: UIView!
    
   
    @IBOutlet weak var adverView: UIView!
    @IBOutlet weak var cycleView: SDCycleScrollView!
    
    
    var navBarRightNotifyBtn:UIButton!
    var navBarRightSettingBtn:UIButton!
    
    var isChangeBarColor = false
   // var navBarLeftJobBtn:UIButton!
    
    var usermodel = UserModel()
    
    var adverModelList = [AdverModel]()
    var site_slide_user = ""

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        cycleView.delegate = self
        
        cycleView.layer.cornerRadius = 15;
        cycleView.layer.masksToBounds = true;
        cycleView.imageURLStringsGroup = [];
        

        adverView.layer.cornerRadius = 15;
        adverView.layer.masksToBounds = true;
        
        addGestureRecognizerToView(view: goodBgview, target: self, actionName: "goodBgviewAction")
        addGestureRecognizerToView(view: careBgview, target: self, actionName: "careBgviewAction")
        
        addGestureRecognizerToView(view: publishBgView, target: self, actionName: "publishBgViewAction")
        addGestureRecognizerToView(view: noteBgView, target: self, actionName: "noteBgViewAction")
        addGestureRecognizerToView(view: columnForCareBgview, target: self, actionName: "columnForCareBgviewAction")
        
        addGestureRecognizerToView(view: identifyDoctorBgview, target: self, actionName: "identifyDoctorBgviewAction")
        //addGestureRecognizerToView(view: settingBgview, target: self, actionName: "settingBgviewAction")
        addGestureRecognizerToView(view: attentionBgview, target: self, actionName: "attentionBgviewAction")
        
        addGestureRecognizerToView(view: feedbackBgview, target: self, actionName: "feedbackBgviewAction")
        addGestureRecognizerToView(view: codeShareBgview, target: self, actionName: "codeShareBgviewAction")
        addGestureRecognizerToView(view: shieldBgview, target: self, actionName: "shieldBgviewAction")
        
        addGestureRecognizerToView(view: headImage, target: self, actionName: "nameLbelAction")
        addGestureRecognizerToView(view: nameLbel, target: self, actionName: "nameLbelAction")
        
        
        headBgview.layer.cornerRadius = 15;
        headBgview.layer.masksToBounds = true

        headImage.layer.cornerRadius = 29;
        headImage.layer.masksToBounds = true

        section1View.layer.cornerRadius = 15;
        section1View.layer.masksToBounds = true
        section2View.layer.cornerRadius = 15;
        section2View.layer.masksToBounds = true
        
        headImage.image =  UIImage.init(named: "wodetouxiang")
        initNavigationBar()
        
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        
        tableView.mj_header = addressHeadRefresh
        if (stringForKey(key: Constants.token) != nil && stringForKey(key: Constants.token) != "") {
            loadInfoData()
        } 
        tableView.separatorStyle = .none
        loadSiteInfo ()
        
        
        
        identiImage.image = UIImage.init(named: "")
 
        //loadSlideInfo (slide_id: "4")
    }
    
    
    func loadSiteInfo (){
        let requestParams = HomeAPI.siteInfoCenterPathAndParams()
        postRequest(pathAndParams: requestParams,showHUD: false)
    }
    
    func initNavigationBar(){
        let rightButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 76, height: 44))
        
        navBarRightNotifyBtn = UIButton(frame: CGRect(x: 38, y: 0, width: 38, height: 44))
            
        navBarRightSettingBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 44))
        
        navBarRightNotifyBtn.setImage(UIImage.init(named: "xiaoxi"), for: .normal)
        
        navBarRightSettingBtn.setImage(UIImage.init(named: "shezhi1"), for: .normal)
        
        navBarRightNotifyBtn.addTarget(self, action: #selector(notifyBtnClick(_:)), for: .touchUpInside)
        
        navBarRightSettingBtn.addTarget(self, action: #selector(settingBtnClick(_:)), for: .touchUpInside)
        
        let lineView = UIView(frame: CGRect(x: 52, y: 11, width: 0.5, height: 22))
        lineView.backgroundColor = UIColor.groupTableViewBackground
       // rightButtonView.addSubview(lineView)
        rightButtonView.addSubview(navBarRightSettingBtn)
        rightButtonView.addSubview(navBarRightNotifyBtn)
        let rightBarItems = UIBarButtonItem.init(customView: rightButtonView)
        self.navigationItem.rightBarButtonItem = rightBarItems
 
     }
    
    @objc func notifyBtnClick(_ btn: UIButton){
        if !currentIsLogin()  {
           self.pushLoginController()
           return
       }
        
        let conroller = NotifyController()
        self.navigationController?.pushViewController(conroller, animated: true)
        
    }
    
    @objc func settingBtnClick(_ btn: UIButton){
        if !currentIsLogin()  {
           self.pushLoginController()
           return
       }
       
       let conroller = UIStoryboard.getSettingViewController()
       self.navigationController?.pushViewController(conroller, animated: true)
    }
    
    //屏蔽
    @objc func shieldBgviewAction(){
        
         if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
        let conroller = SheildViewController()
        self.navigationController?.pushViewController(conroller, animated: true)
        
    }
    //二维码分享
    @objc func codeShareBgviewAction(){
        
         if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
        let conroller = UIStoryboard.getCodeShareController()
        self.navigationController?.pushViewController(conroller, animated: true)
        
    }
    //意见反馈
    @objc func feedbackBgviewAction(){
        
         if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
        let conroller = UIStoryboard.getFeedBackController()
        self.navigationController?.pushViewController(conroller, animated: true)
        
    }
    //举报
    @objc func attentionBgviewAction(){
        
        if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
        let conroller = ComplainController()
        //conroller.menupagetype = MenuPageType.MineGood
        self.navigationController?.pushViewController(conroller, animated: true)
        
    }
    
    //设置
    @objc func settingBgviewAction(){
        
        
        
    }
    //医师认证
    @objc func identifyDoctorBgviewAction(){
        
        if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
        if usermodel?.check_status == 1{
            let conroller = UIStoryboard.getAuthenController()
            conroller.isFormMine = true
            self.navigationController?.pushViewController(conroller, animated: true)
        }else if usermodel?.check_status == 2{
            showOnlyTextHUD(text: "正在审核，请耐心等待")
            //showAlertDialog(delegate: self, titles: "正在审核，请耐心等待")
            //DialogueUtils.showWarning(withStatus: "正在审核，请耐心等待")
        }else if usermodel?.check_status == 4{
            DialogueUtils.showWarning(withStatus: "认证已审核通过")
        }else if usermodel?.check_status == 3{
            let conroller = UIStoryboard.getAuthenController()
            conroller.isFormMine = true
            self.navigationController?.pushViewController(conroller, animated: true)
        }
        
    }
    //订阅
    @objc func columnForCareBgviewAction(){
        
         if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
        let conroller = CompaniesFrontiersController()
        conroller.isCareGroup = true
        self.navigationController?.pushViewController(conroller, animated: true)
        
    }
    //笔记
    @objc func noteBgViewAction(){
        
         if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
        let conroller = MineNoteController()
        self.navigationController?.pushViewController(conroller, animated: true)
        
    }
    //发布
    @objc func publishBgViewAction(){
        
        
         if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
        let conroller = ChannelViewController()
        conroller.menupagetype = MenuPageType.MinePublish
        self.navigationController?.pushViewController(conroller, animated: true)
        
    }
    //点赞
    @objc func goodBgviewAction(){
        
         if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
        let conroller = ChannelViewController()
        conroller.menupagetype = MenuPageType.MineGood
        self.navigationController?.pushViewController(conroller, animated: true)
        
    }
    //收藏
    @objc func careBgviewAction(){
        if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
        let vc = ChannelViewController()
        vc.menupagetype = MenuPageType.MineCare
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
   
    
    @objc func refreshList() {
        
        
        if (stringForKey(key: Constants.token) != nil && stringForKey(key: Constants.token) != "") {
             loadInfoData()
        }else{
        }
        
        if site_slide_user == ""{
            loadSiteInfo ()
        }else{
            self.loadSlideInfo(slide_id: site_slide_user)
        }
       
    }
    
    @IBAction func perInfoAction(_ sender: Any) {
         if currentIsLogin() {
            let controller = UIStoryboard.getPersonsInfoController()
            controller.userModel = self.usermodel
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            self.pushLoginController()
        }
    }
    
    func loadInfoData(){
 
        let requestParams = HomeAPI.personsCenterPathAndParams()
        getRequest(pathAndParams: requestParams,showHUD: false)
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage (named: "MineNavbar" ), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: ZYJColor.main)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.title = "我的"

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isChangeBarColor{
            
        }else{
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: ZYJColor.tableViewBg), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: ZYJColor.tableViewBg)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black] //设置导航栏标题颜色
            self.navigationController?.navigationBar.tintColor = UIColor.black   //设置导航栏按钮颜色
        }
    }
    
    func loadSlideInfo (slide_id: String){
        let requestParams = HomeAPI.slidesInfoPathAndParams(slide_id: slide_id)
        postRequest(pathAndParams: requestParams,showHUD: false)
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
  
        tableView.mj_header?.endRefreshing()
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
        tableView.mj_header?.endRefreshing()
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
 
        
        if requestPath == HomeAPI.site_infoCenter{
            site_slide_user = responseResult["site_slide_user"].stringValue
            self.loadSlideInfo(slide_id: site_slide_user)
            
        }else if requestPath == HomeAPI.slides_info {
            adverModelList = getArrayFromJson(content: responseResult)
            var imageArrTemp = [String]()
            if adverModelList.count == 0{
                return
            }else{
                for model in adverModelList {
                    imageArrTemp.append(model.image)
                }
            }
            self.cycleView.imageURLStringsGroup = imageArrTemp
            self.tableView.reloadData()
        }else{
            usermodel = Mapper<UserModel>().map(JSONObject: responseResult.rawValue)
            setValueForKey(value: usermodel?.avatar as AnyObject, key: Constants.avatar)
            setValueForKey(value: usermodel?.avatar_url as AnyObject, key: Constants.avatar_url)
            //setValueForKey(value: usermodel?.doctorModel?.check_status as AnyObject, key: Constants.isCheck)
            setValueForKey(value: usermodel?.user_realname as AnyObject, key: Constants.truename)
            setValueForKey(value: usermodel?.user_nickname as AnyObject, key: Constants.nickname)
            setValueForKey(value: usermodel?.sex as AnyObject, key: Constants.gender)
            setValueForKey(value: usermodel?.mobile as AnyObject, key: Constants.account)
            if usermodel?.mobile == ""{
                setValueForKey(value: usermodel?.user_login as AnyObject, key: Constants.account)
            }
 
            if usermodel?.check_status == 4 {
                identiImage.image = UIImage.init(named: "yirenzheng")
            }else if usermodel?.check_status == 2{
                identiImage.image = UIImage.init(named: "daishenhe")
            }else if usermodel?.check_status == 3{
                identiImage.image = UIImage.init(named: "Authentication failed")
            }
            else{
                identiImage.image = UIImage.init(named: "weirenzheng")
            }
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
        }
        
        
    }
    
    @objc override func tokenChange(note: NSNotification){
        self.logoutAccount(account: "")
        self.nameLbel.text = "登录/注册"
        self.headImage.displayHeadImageWithURL(url: "")
        tableView.mj_header?.endRefreshing()
        if note.object != nil {
            if self.currentIsLogin() == true {
                self.showSingleButtonAlertDialog(message: "您的账号已在其他终端登陆，或账号已退出，请重新登录") { (type) in
                    self.logoutAccount(account: "")
                    if (stringForKey(key: Constants.token) != nil && stringForKey(key: Constants.token) != "") {
                        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(self.refreshList))
                        self.tableView.mj_header = addressHeadRefresh
                    }else{
                        self.tableView.mj_header = nil
                    }
                }
            }
        }
    }
    
    
    func judgeToPush() {
        if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
    }
   
    //消息
    @objc func notifyImageAction(){
        if !currentIsLogin()  {
            self.pushLoginController()
            return
        }
        let conroller = NotifyController()
        self.navigationController?.pushViewController(conroller, animated: true)
        
    }
    
    //个人信息
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

        isChangeBarColor = true
        let controller = UIStoryboard.getNewLoginController()
        controller.modalPresentationStyle = .fullScreen
        controller.isFromMine = true
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
                if (stringForKey(key: Constants.token) != nil && stringForKey(key: Constants.token) != "") {
                    let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self!, refreshingAction: #selector(self?.refreshList))
                    self?.tableView.mj_header = addressHeadRefresh
                }else{
                    self?.tableView.mj_header = nil
                }
                self?.isChangeBarColor = false
                self?.refreshList()
             }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if adverModelList.count == 0{
            return 2
        }
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return 1
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        if section == 1 {
            if row == 0{

            }else if row == 2{
                // showOnlyTextHUD(text: "nihaoha")
                if clearMyCache(){
                    DialogueUtils.showSuccess(withStatus: "清除成功")
                }else{
                    DialogueUtils.showSuccess(withStatus: "成功清除")
                }
            }else if row == 3{
                let conroller = AboutYiLuHuWeiController()
                self.navigationController?.pushViewController(conroller, animated: true)
 
            }else if row == 1{
                 let conroller = PrivateStatusViewController()
                 self.navigationController?.pushViewController(conroller, animated: true)
            }else if row == 4{
                
                if !currentIsLogin()  {
                    self.pushLoginController()
                    return
                }
                let conroller = UIStoryboard.getFeedBackController()
                self.navigationController?.pushViewController(conroller, animated: true)
           }
            
        }
     }
    
}

extension MineViewController:SDCycleScrollViewDelegate{
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
 
        let controller = AdverController()
        if adverModelList[index].url == ""{
            return
        }
        controller.urlString = adverModelList[index].url
        self.navigationController?.pushViewController(controller, animated: true)
        print(index)
    }
    
}
