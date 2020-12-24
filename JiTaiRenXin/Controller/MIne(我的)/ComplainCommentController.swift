//
//  ComplainArticleController.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/07.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class ComplainCommentController: BaseViewController,Requestable{
    
    var tableView:UITableView!
    
    var ComplainModelList = [ComplainModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        self.title = "举报的评论"
        loadData()
        // Do any additional setup after loading the view.
    }
 
    func loadData(){
        let requestParams = HomeAPI.mineComplainPathAndParams()
        postRequest(pathAndParams: requestParams,showHUD: true)
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
        
        let list:[ComplainModel]  = getArrayFromJsonByArrayName(arrayName: "list", content:  responseResult)
        
        ComplainModelList.append(contentsOf: list)
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
        tableView.registerNibWithTableViewCellName(name: ComplainCommentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: ComplainType2Cell.nameOfClass)
        
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
        ComplainModelList.removeAll()
        self.tableView.mj_footer?.resetNoMoreData()
        page = 1
        self.loadData()
    }
    
    
    
    var autoCellHeight: CGFloat = 0
    
}//实现tableview的代理方法
extension ComplainCommentController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: ComplainModelList.count ,isdisplay: true)
         return ComplainModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplainCommentCell", for: indexPath) as! ComplainCommentCell
            cell.selectionStyle = .none
           cell.model = ComplainModelList[indexPath.row]
            //cell.delegeta = self
            return cell
        
        
//        else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplainType2Cell", for: indexPath) as! ComplainType2Cell
//            cell.selectionStyle = .none
//            //cell.delegeta = self
//            return cell
//        }
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 112
        
//        else{
//            return 172
//        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
        
    }
}
