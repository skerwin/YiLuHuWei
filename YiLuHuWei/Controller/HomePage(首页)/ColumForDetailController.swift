////
////  ColumForDetailController.swift
////  YiLuHuWei
////
////  Created by zhaoyuanjing on 2020/08/06.
////  Copyright © 2020 gansukanglin. All rights reserved.
////
//


import SwiftyJSON
import ObjectMapper

var toTopHeight:CGFloat = 183 //pagemenu距顶部位置
//这个页面供各个页面复用

class ColumForDetailController:BaseViewController ,Requestable  {
    
    var searView:HomeSearchView!
    var controllerArray : [UIViewController] = []
    var controller1:ArticleViewController!
    var controller2:CaseViewController!
    var controller3:VideoViewController!
    var pageMenuController: PMKPageMenuController? = nil
    
    var menupagetype:MenuPageType!
    
    var columForHeaderView:ColumForHeaderView!//栏目详情的头
    
    
    var groupID = 0 //栏目详情页的时候要传一个栏目详情id
    var columForModel = SubscribeModel()
    var searchWordKey = "" //搜索用的关键词
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationController?.navigationBar.topItem?.title = ""
        
        groupID = columForModel!.id
        controller1 = ArticleViewController()
        controller1.title = "文章"
        controller1.parentNavigationController = self.navigationController
        controller1.menupagetype = MenuPageType.GroupType
        controller1.groupID = self.groupID
        
        controller2 = CaseViewController()
        controller2.title = "病例"
        controller2.parentNavigationController = self.navigationController
        controller2.menupagetype = MenuPageType.GroupType
        controller2.groupID =  self.groupID

        controller3 = VideoViewController()
        controller3.title = "视频"
        controller3.parentNavigationController = self.navigationController
        controller3.menupagetype = MenuPageType.GroupType
        controller3.groupID =  self.groupID
        
        
        self.title = "栏目详情"
        toTopHeight = 183
        initpageMenu()
        
        initColumForDetailHeadView()
        if columForModel?.is_collect == 0{
            columForHeaderView.careBtn.titleLabel?.text = "订阅"
            columForHeaderView.careBtn.setTitle("订阅", for: .normal)
            columForHeaderView.careBtn.backgroundColor = ZYJColor.main
        }else{
            columForHeaderView.careBtn.setTitle("已订阅", for: .normal)
            columForHeaderView.careBtn.titleLabel?.text = "已订阅"
            columForHeaderView.careBtn.backgroundColor = UIColor.lightGray
        }
    }
 
    func loadColumDetail(){
        let pathAndParams = HomeAPI.groupShowListPathAndParams(page: page, limit: limit, id: 0, list_type: 0)
        postRequest(pathAndParams: pathAndParams,showHUD: false)
    }
    
    func initpageMenu(){
        
        controllerArray.append(controller1)
        controllerArray.append(controller2)
        controllerArray.append(controller3)
        
        pageMenuController = PMKPageMenuController(controllers: controllerArray, menuStyle: .plain, menuColors:[ZYJColor.main], startIndex: 1, topBarHeight: toTopHeight)
        pageMenuController?.delegate = self
        self.addChild(pageMenuController!)
        self.view.addSubview(pageMenuController!.view)
        pageMenuController?.didMove(toParent: self)
        
    }
    
    func initColumForDetailHeadView(){
        columForHeaderView = Bundle.main.loadNibNamed("ColumForHeaderView", owner: nil, options: nil)!.first as? ColumForHeaderView
        
        columForHeaderView?.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: toTopHeight)
        columForHeaderView.model = self.columForModel
        columForHeaderView.configModel()
        
        columForHeaderView.delegate = self
        let bgview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: toTopHeight))
        bgview.addSubview(columForHeaderView)
        self.view.addSubview(bgview)
    }
    
    
    func careData (){
        
        if !currentIsLogin() {
            self.forLoginController()
        }else{
            let pathAndParams = HomeAPI.ColumnCollectPathAndParams(id: groupID)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }
    }
    
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        //ischeck 是否审核  0 未审核  1  审核中  2 通过审核 3 审核为通过
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        var operate = 0
        if requestPath == HomeAPI.ColumnCollectPath {
            let operate = responseResult["hand_status"].intValue
            if operate == 0{
                showOnlyTextHUD(text: "取消订阅成功")
                columForHeaderView.careBtn.titleLabel?.text = "订阅"
                columForHeaderView.careBtn.setTitle("订阅", for: .normal)
                columForHeaderView.careBtn.backgroundColor = ZYJColor.main
              }else{
                columForHeaderView.careBtn.setTitle("已订阅", for: .normal)
                columForHeaderView.careBtn.titleLabel?.text = "已订阅"
                showOnlyTextHUD(text: "订阅成功")
                columForHeaderView.careBtn.backgroundColor = UIColor.lightGray
                
              }
        }else {
            columForModel = Mapper<SubscribeModel>().map(JSONObject: responseResult["info"].rawValue)
            operate = columForModel!.is_collect
        }
        
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
        
    }
    
    func initSearchView(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "sousuo"), style: .plain, target: self, action: #selector(rightNavBtnClick))
        
    }
    
    @objc func rightNavBtnClick(){
        let controller = HomeSearchController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if menupagetype == MenuPageType.Channel{
        
        }else if menupagetype == MenuPageType.ColumForDetail{
            
        }else if menupagetype == MenuPageType.MineGood{
            
        }else if menupagetype == MenuPageType.MineCare{
            
        }
        
    }

    func backNavigationBarColor(){
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if menupagetype == MenuPageType.MineGood || menupagetype == MenuPageType.MineCare{
          
        }else{
            
            let hidePublish = stringForKey(key: Constants.hidePublish)
            if hidePublish != "" && currentIsLogin(){
                self.view.addSubview(floatingView)
                floatingView.isHidden = false
            }else{
                floatingView.removeFromSuperview()
                floatingView.isHidden = true
            }
            
          
        }
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        floatingView.removeFromSuperview()
        floatingView.isHidden = true
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
//搜索代理
extension ColumForDetailController:HomeSearchViewDelegate{
    func notifyClick(onV: UIView) {
        
    }
    
    
    func searchActoin() {
        let controller = HomeSearchController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ColumForDetailController: PMKPageMenuControllerDelegate
{
    func pageMenuController(_ pageMenuController: PMKPageMenuController, willMoveTo viewController: UIViewController, at menuIndex: Int) {
    }
    
    func pageMenuController(_ pageMenuController: PMKPageMenuController, didMoveTo viewController: UIViewController, at menuIndex: Int) {
    }
    
    func pageMenuController(_ pageMenuController: PMKPageMenuController, didPrepare menuItems: [PMKPageMenuItem]) {
        // XXX: For .hacka style
        var i: Int = 1
        for item: PMKPageMenuItem in menuItems {
            item.badgeValue = String(format: "%zd", i)
            i += 1
        }
    }
    
    func pageMenuController(_ pageMenuController: PMKPageMenuController, didSelect menuItem: PMKPageMenuItem, at menuIndex: Int) {
        menuItem.badgeValue = nil // XXX: For .hacka style
    }
}

extension ColumForDetailController:ColumForHeaderViewDelegate{
    func careBtnAction() {
        self.careData ()
    }
    
    
}
