//
//  ChannelViewController.swift
//  YiLuHuWei
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
    case MinePublish //我的发布
    case MineNote //我的笔记
    case MineSubscribe //我的订阅
    case Search // 搜索
    case GroupType // 小组
    
}



//这个页面供各个页面复用

class ChannelViewController:BaseViewController ,Requestable  {
    
    var searView:HomeSearchView!
    var controllerArray : [UIViewController] = []
    var controller1:ArticleViewController!
    var controller2:CaseViewController!
    var controller3:VideoViewController!
    
    var keyWord = ""
    
    var pageMenuController: PMKPageMenuController? = nil
    
    var menupagetype:MenuPageType!
    
    var toTopHeight:CGFloat = 0 //pagemenu距顶部位置
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationController?.navigationBar.topItem?.title = ""
        
        
        controller1 = ArticleViewController()
        controller1.title = "文章"
        controller1.parentNavigationController = self.navigationController
        controller1.menupagetype = menupagetype
        controller1.searchKey = self.keyWord
 
        controller2 = CaseViewController()
        controller2.title = "病例"
        controller2.parentNavigationController = self.navigationController
        controller2.menupagetype = menupagetype
        controller2.searchKey = self.keyWord
        
        
        if menupagetype != MenuPageType.MinePublish{
            controller3 = VideoViewController()
            controller3.searchKey = self.keyWord
            controller3.title = "视频"
            controller3.parentNavigationController = self.navigationController
            controller3.menupagetype = menupagetype
        }
        
        toTopHeight = 0
        if menupagetype == MenuPageType.Channel{
            
        }else if menupagetype == MenuPageType.ColumForDetail{
            
        }else if menupagetype == MenuPageType.MineGood{
            self.title = "我的点赞"
            
        }
        else if menupagetype == MenuPageType.MineCare{
            self.title = "我的收藏"
            
        }
        else if menupagetype == MenuPageType.MineSubscribe{
            self.title = "我的订阅"
            
        }
        else if menupagetype == MenuPageType.MinePublish{
            self.title = "我的发布"
            
        }
        else if menupagetype == MenuPageType.Search{
            self.title = keyWord
        }else{
        }
        
        initpageMenu()
    }
    
    
    func initpageMenu(){
        
        controllerArray.append(controller1)
        controllerArray.append(controller2)
        if menupagetype != MenuPageType.MinePublish {
            controllerArray.append(controller3)
        }
        
        pageMenuController = PMKPageMenuController(controllers: controllerArray, menuStyle: .plain, menuColors:[ZYJColor.main], startIndex: 1, topBarHeight: toTopHeight)
        pageMenuController?.delegate = self
        self.addChild(pageMenuController!)
        self.view.addSubview(pageMenuController!.view)
        pageMenuController?.didMove(toParent: self)
        
        
    }

    
    
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        //ischeck 是否审核  0 未审核  1  审核中  2 通过审核 3 审核为通过
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
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
        
        if menupagetype == MenuPageType.MineGood || menupagetype == MenuPageType.MineCare || menupagetype == MenuPageType.MinePublish || menupagetype == MenuPageType.Search{
            floatingView.removeFromSuperview()
            floatingView.isHidden = true
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
    func notifyClick(onV: UIView) {
        
    }
    
    
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


