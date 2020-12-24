//
//  ChannelViewController.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/27.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

import SwiftyJSON
import ObjectMapper

enum MenuPageType: Int {
    //各个入口共用
    case Channel = 0// tabbar频道
    case ColumForDetail // tabbar栏目
    case MineGood // 我的点赞
    case MineCare // 我的收藏
    case HomeMore // 首页更多
    case Search // 搜索
    
}


//这个页面供各个页面复用

class ChannelViewController:BaseViewController ,Requestable  {
    
    var searView:HomeSearchView!
    var controllerArray : [UIViewController] = []
    var controller1:ChannelArticleController!
    var controller2:ChannelReportController!
    var controller3:ChannelVideoController!
    var pageMenuController: PMKPageMenuController? = nil
    
    var menupagetype:MenuPageType!
    
    var columForHeaderView:ColumForHeaderView!//栏目详情的头
    var toTopHeight:CGFloat = 0 //pagemenu距顶部位置
    
    var cid = 0 //栏目详情页的时候要传一个栏目详情id
    var columForModel = ColumnForModel()
    var searchWordKey = "" //搜索用的关键词
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationController?.navigationBar.topItem?.title = ""
        
        
        controller1 = ChannelArticleController()
        controller1.title = "文章"
        controller1.parentNavigationController = self.navigationController
        controller1.menupagetype = menupagetype
        controller1.cid = cid
        controller1.searchWordKey = searchWordKey
        
        controller2 = ChannelReportController()
        controller2.title = "病例"
        controller2.parentNavigationController = self.navigationController
        controller2.menupagetype = menupagetype
        controller2.cid = cid
        controller2.searchWordKey = searchWordKey
        
        controller3 = ChannelVideoController()
        controller3.title = "视频"
        controller3.parentNavigationController = self.navigationController
        controller3.menupagetype = menupagetype
        controller3.cid = cid
        controller3.searchWordKey = searchWordKey
        
        
        
        if menupagetype == MenuPageType.Channel{
            initSearchView()
            toTopHeight = 0
            initpageMenu()
        }else if menupagetype == MenuPageType.ColumForDetail{
            self.title = "栏目详情"
            toTopHeight = 172
            initpageMenu()
            loadColumDetail()
            
            initColumForDetailHeadView()
            if columForModel?.is_collect == 0{
                columForHeaderView.careBtn.titleLabel?.text = "关注"
                columForHeaderView.careBtn.setTitle("关注", for: .normal)
            }else{
                columForHeaderView.careBtn.setTitle("已关注", for: .normal)
                columForHeaderView.careBtn.titleLabel?.text = "已关注"
            }
            
        }else if menupagetype == MenuPageType.MineGood{
            self.title = "我的点赞"
            initpageMenu()
            
        }else if menupagetype == MenuPageType.MineCare{
            self.title = "我的收藏"
            initpageMenu()
            
        }else if menupagetype == MenuPageType.Search{
            self.title = "搜索结果"
            initpageMenu()
        }else{
            initpageMenu()
        }
 
        // Do any additional setup after loading the view.
    }
    
    
    func loadColumDetail(){
        let pathAndParams = HomeAPI.ColumnForDetaiPathAndParams(id: cid)
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
        
        columForHeaderView?.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 172)
        columForHeaderView.model = self.columForModel
        columForHeaderView.configModel()
        
        columForHeaderView.delegate = self
        let bgview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 172))
        bgview.addSubview(columForHeaderView)
        self.view.addSubview(bgview)
    }
    

    
    
    func careData (){
 
        if !currentIsLogin() {
            self.forLoginController()
        }else{
            let pathAndParams = HomeAPI.ColumnCollectPathAndParams(id: cid)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }

      
    }
    
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        //ischeck 是否审核  0 未审核  1  审核中  2 通过审核 3 审核为通过
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        var operate = 0
        if requestPath == HomeAPI.ColumnCollectPath {
             operate = responseResult["collect_type"].intValue
        }else {
            columForModel = Mapper<ColumnForModel>().map(JSONObject: responseResult["info"].rawValue)
            operate = columForModel!.is_collect
        }
 
        if operate == 0{
            columForHeaderView.careBtn.titleLabel?.text = "关注"
            columForHeaderView.careBtn.setTitle("关注", for: .normal)
         }else{
            columForHeaderView.careBtn.setTitle("已关注", for: .normal)
            columForHeaderView.careBtn.titleLabel?.text = "已关注"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if menupagetype == MenuPageType.Channel{
            //self.navigationController?.navigationBar.addSubview(searView)
        }else if menupagetype == MenuPageType.ColumForDetail{
//            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//            self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: ZYJColor.main), for: UIBarMetrics.default)
//            self.navigationController?.navigationBar.isTranslucent = false
//            self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: ZYJColor.main)
//            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white] //设置导航栏标题颜色
//            self.navigationController?.navigationBar.tintColor = UIColor.white   //设置导航栏按钮颜色
        }else if menupagetype == MenuPageType.MineGood{
            
        }else if menupagetype == MenuPageType.MineCare{
            
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if menupagetype == MenuPageType.Channel{
//            if (self.navigationController?.navigationBar.viewWithTag(999) == nil){
//                self.navigationController?.navigationBar.addSubview(searView)
//            }
        }else if menupagetype == MenuPageType.ColumForDetail{
            
        }else if menupagetype == MenuPageType.MineGood{
            
        }else if menupagetype == MenuPageType.MineCare{
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if menupagetype == MenuPageType.Channel{
            //searView.removeFromSuperview()
        }else if menupagetype == MenuPageType.ColumForDetail{
//            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//            self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor.white), for: UIBarMetrics.default)
//            self.navigationController?.navigationBar.isTranslucent = false
//            self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: UIColor.white)
//            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black] //设置导航栏标题颜色
//            self.navigationController?.navigationBar.tintColor = UIColor.black   //设置导航栏按钮颜色
            
        }else if menupagetype == MenuPageType.MineGood{
            
        }else if menupagetype == MenuPageType.MineCare{
            
        }
    }
    func backNavigationBarColor(){
        
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
extension ChannelViewController:HomeSearchViewDelegate{
    
    func searchActoin() {
        let controller = HomeSearchController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ChannelViewController: PMKPageMenuControllerDelegate
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

extension ChannelViewController:ColumForHeaderViewDelegate{
    func careBtnAction() {
         self.careData ()
     }
    
    
}

