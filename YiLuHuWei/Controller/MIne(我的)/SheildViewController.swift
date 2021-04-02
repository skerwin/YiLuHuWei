//
//  SheildViewController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/02/08.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import SDCycleScrollView

class SheildViewController: BaseViewController ,Requestable  {
    
    var tableView:UITableView!
    
    var shieldModelList = [ShieldModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        self.title = "屏蔽内容"
        loadData()
        
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        let requestParams = HomeAPI.shieldListPathAndParams(pageSize: pagenum, page: page)
        postRequest(pathAndParams: requestParams,showHUD: true)
        
    }
    
    func commentRecallAction(cmodel: CommentModel){
        let requestlParams = HomeAPI.shieldPathAndParams(id: cmodel.id )
        postRequest(pathAndParams: requestlParams,showHUD: false)
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
        
        
        if requestPath == HomeAPI.shieldPath {
            showOnlyTextHUD(text: "撤回成功")
            pullRefreshList() 
        }else{
            let list:[ShieldModel]  = getArrayFromJsonByArrayName(arrayName: "list", content:  responseResult)
            shieldModelList.append(contentsOf: list)
            if list.count < 10 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
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
        tableView.registerNibWithTableViewCellName(name: shieldViewCell.nameOfClass)
        
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
        shieldModelList.removeAll()
        page = 1
        self.loadData()
    }
  
    var autoCellHeight: CGFloat = 0
    
}//实现tableview的代理方法
extension SheildViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: shieldModelList.count ,isdisplay: true)

        return shieldModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "shieldViewCell", for: indexPath) as! shieldViewCell
        cell.selectionStyle = .none
        cell.model = shieldModelList[indexPath.row]
        cell.delegate = self
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 136
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension SheildViewController:shieldViewCelllDelegate {
    func recallAction(model: ShieldModel) {
        commentRecallAction(cmodel: model.comments!)
    }
    
    
}
