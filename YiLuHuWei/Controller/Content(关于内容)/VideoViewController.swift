//
//  VideoViewController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/26.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class VideoViewController: BaseViewController,Requestable {
    
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
            
            let pathAndParams = HomeAPI.groupShowListPathAndParams(page: page, limit: limit, id: groupID, list_type: 3)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }
        
        else if menupagetype == MenuPageType.MineGood{
            self.title = "我的点赞"
            let pathAndParams = HomeAPI.personsLikeListPathAndParams(page: page, limit: limit, table_name: "video_manage")
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }
        else if menupagetype == MenuPageType.MineCare{
            self.title = "我的收藏"
            let pathAndParams = HomeAPI.favoriteListPathAndParams(page: page, limit: limit, table_name: "video_manage")
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }
        
        else if menupagetype == MenuPageType.Search{
            self.title = searchKey
            let pathAndParams = HomeAPI.HomeSearchPathAndParams(keyword:searchKey,page: page, limit: limit, list_type: 3)
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
        
        var list:[AVCModel]  = getArrayFromJson(content: responseResult)
        
        if HomeAPI.personsLikeList == requestPath || HomeAPI.favoriteList == requestPath {
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
 
        tableView.registerNibWithTableViewCellName(name: SchoolVideoCell.nameOfClass)
    
        
        
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
    
        floatingView.removeFromSuperview()
        floatingView.isHidden = true
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
extension VideoViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplayWithMsg(message: "暂无内容", rowCount: dateModelList.count ,isdisplay: true)
        return dateModelList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SchoolVideoCell.nameOfClass) as! SchoolVideoCell
        //cell.delegeta = self
        cell.model = dateModelList[indexPath.row]
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 114
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = VideoContentController()
        controller.fid = dateModelList[indexPath.row].id
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
