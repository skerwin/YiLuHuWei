//
//  ArticleViewController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/26.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class ArticleViewController: BaseViewController,Requestable {
    
    var tableView:UITableView!
    
    var dateModelList = [AVCModel]()
    var mineDateModelList = [PerAVCModel]()
    
    
    
    
    var menupagetype:MenuPageType!
    var groupID = 0
    var parentNavigationController: UINavigationController?
    
    var searchKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        loadData()
        
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        
        if menupagetype == MenuPageType.Channel {
          
        }
        
        else if menupagetype == MenuPageType.GroupType{
            
            let pathAndParams = HomeAPI.groupShowListPathAndParams(page: page, limit: limit, id: groupID, list_type: 1)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }
        
        else if menupagetype == MenuPageType.MineGood{
            self.title = "我的点赞"
            let pathAndParams = HomeAPI.personsLikeListPathAndParams(page: page, limit: limit, table_name: "portal_post")
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }
        
        else if menupagetype == MenuPageType.MineCare{
            self.title = "我的收藏"
            let pathAndParams = HomeAPI.favoriteListPathAndParams(page: page, limit: limit, table_name: "portal_post")
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }
        
        else if menupagetype == MenuPageType.MinePublish{
            self.title = "我的发布"
            let pathAndParams = HomeAPI.myPublishPathAndParams(page: page, limit: limit, list_type: 1)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }
        
        else if menupagetype == MenuPageType.Search{
            self.title = searchKey
            let pathAndParams = HomeAPI.HomeSearchPathAndParams(keyword:searchKey,page: page, limit: limit, list_type: 1)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }
        
        else{
    
        }
       
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        
        var list:[AVCModel]!
        list = getArrayFromJson(content: responseResult)
    
        if HomeAPI.personsLikeList == requestPath || HomeAPI.favoriteList == requestPath{
            list.removeAll()
            mineDateModelList = getArrayFromJson(content: responseResult)
            for model in mineDateModelList {
                list.append(model.articles!)
            }
        }
        
        dateModelList.append(contentsOf: list)
         if list.count < 10 {
              self.tableView.mj_footer?.endRefreshingWithNoMoreData()
          }
        self.tableView.reloadData()
    }
    
    func initTableView(){
        
    
        if menupagetype == MenuPageType.Channel {
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navigationHeaderAndStatusbarHeight - bottomNavigationHeight - pageMenuHeight), style: .plain)
        }
        else if menupagetype == MenuPageType.GroupType{
            tableView = UITableView(frame: CGRect(x: 10, y: 0, width: screenWidth - 20, height: screenHeight - navigationHeaderAndStatusbarHeight - toTopHeight), style: .plain)
        }
        else{
            tableView = UITableView(frame: CGRect(x: 10, y: 0, width: screenWidth - 20, height: screenHeight - navigationHeaderAndStatusbarHeight), style: .plain)
        }
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 240;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
 
        tableView.registerNibWithTableViewCellName(name: OnlyContentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: OneImageContentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: TwoImageContentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: ThreeImageContentCell.nameOfClass)
        
        
        self.tableView?.layer.cornerRadius = 20;
        self.tableView?.layer.masksToBounds = true
        self.tableView.backgroundColor = ZYJColor.tableViewBg
        
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh
        
        
        let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
        tableView.mj_footer = footerRefresh
        
        view.addSubview(tableView)
        
        tableView.tableFooterView = UIView()
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
    
    @objc func pullRefreshList() {
        page = page + 1
        self.loadData()
    }
    
    @objc func refreshList() {
        dateModelList.removeAll()
        self.tableView.mj_footer?.resetNoMoreData()
        page = 1
        self.loadData()
    }
    
    
    
    var autoCellHeight: CGFloat = 0
    
}//实现tableview的代理方法
extension ArticleViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: dateModelList.count ,isdisplay: true)
        return dateModelList.count

     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let row = indexPath.row
        let model = dateModelList[row]
        
        if model.show_type == 0{
 
            let cell = tableView.dequeueReusableCell(withIdentifier: OnlyContentCell.nameOfClass) as! OnlyContentCell
            cell.model =  dateModelList[row]
            cell.selectionStyle = .none
            if row == 0{
                cell.lineView.backgroundColor = UIColor.white
            }
            return cell
        }else if model.show_type == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: OneImageContentCell.nameOfClass) as! OneImageContentCell
            cell.model = dateModelList[row]
            cell.selectionStyle = .none
            if row == 0{
                cell.lineView.backgroundColor = UIColor.white
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ThreeImageContentCell.nameOfClass) as! ThreeImageContentCell
            cell.model = dateModelList[row]
            cell.selectionStyle = .none
            if row == 0{
                cell.lineView.backgroundColor = UIColor.white
            }
            return cell
        }
  
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = dateModelList[indexPath.row]
        
        if model.show_type == 0{
             return 109
        }else if model.show_type == 1{
            return 115
        }else {
            return 147
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menupagetype != MenuPageType.MinePublish {
            let controller = ArcticleDetailController()
            controller.fid = dateModelList[indexPath.row].id
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            let model = dateModelList[indexPath.row]
            if model.post_status == 0{
                return
            }
            let controller = ArcticleDetailController()
            controller.fid = dateModelList[indexPath.row].id
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
 
    }
}
