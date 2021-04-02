//
//  NotifyController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/08/06.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import SDCycleScrollView

class NotifyController: BaseViewController ,Requestable  {
    
    
    var tableView:UITableView!
    
    var notifyModelList = [NotifyModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        self.title = "消息通知"
        loadData()
        
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        let requestParams = HomeAPI.messageloadPathAndParams(pageSize: pagenum, page: page)
        postRequest(pathAndParams: requestParams,showHUD: true)
        
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
              tableView.mj_header?.endRefreshing()
              tableView.mj_footer?.endRefreshing()
         self.tableView.mj_footer?.endRefreshingWithNoMoreData()
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        
        let list:[NotifyModel]  = getArrayFromJson(content: responseResult)
           // getArrayFromJsonByArrayName(arrayName: "list", content:  responseResult)
      
        
        notifyModelList.append(contentsOf: list)
        if list.count < 10 {
            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
        }
        self.tableView.reloadData()
    }
    
    func initTableView(){
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navigationHeaderAndStatusbarHeight), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 240;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNibWithTableViewCellName(name: NotifyCell.nameOfClass)
        
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh
        
        let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
        tableView.mj_footer = footerRefresh
        
        view.addSubview(tableView)
        
        tableView.tableFooterView = UIView()
      
    }
    
    @objc func pullRefreshList() {
        page = page + 1
        self.loadData()
    }
    
    @objc func refreshList() {
        self.tableView.mj_footer?.resetNoMoreData()
        notifyModelList.removeAll()
        page = 1
        self.loadData()
    }
    
    
    
    
    var autoCellHeight: CGFloat = 0
    
}//实现tableview的代理方法
extension NotifyController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: notifyModelList.count ,isdisplay: true)

        return notifyModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotifyCell", for: indexPath) as! NotifyCell
        cell.selectionStyle = .none
        cell.model = notifyModelList[indexPath.row]
        //cell.delegeta = self
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 74
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let controller = UIStoryboard.getNotifyDetailController()
            //NewNotifyDetailController()
        controller.model = notifyModelList[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
        
    
        
    }
}
