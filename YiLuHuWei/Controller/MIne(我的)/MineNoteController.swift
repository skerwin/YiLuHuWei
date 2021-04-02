//
//  MineNoteController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/02/01.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class MineNoteController: BaseViewController,Requestable {
    
    var tableView:UITableView!
    
    
    var dateModelList = [NoteModel]()
    
 
    var menupagetype:MenuPageType!
    var groupID = 0
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        self.title = "我的笔记"
        loadData()
        
    }
    
   
    
    
    func loadData(){
       
        let requestParams = HomeAPI.noteListPathAndParams(page: page, limit: limit)
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
        
        let list:[NoteModel]  = getArrayFromJsonByArrayName(arrayName: "list", content:  responseResult)
 
        dateModelList.append(contentsOf: list)
         if list.count < 10 {
              self.tableView.mj_footer?.endRefreshingWithNoMoreData()
          }
        self.tableView.reloadData()
    }
    
    func initTableView(){
        
        if menupagetype == MenuPageType.Channel {
         
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
 
        tableView.registerNibWithTableViewCellName(name: NoteViewCell.nameOfClass)
        
        
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
extension MineNoteController:UITableViewDataSource,UITableViewDelegate {
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteViewCell.nameOfClass) as! NoteViewCell
        cell.model =  dateModelList[row]
        cell.selectionStyle = .none
      
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let controller = UIStoryboard.getNoteViewController()
            controller.noteModel = dateModelList[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
     }
}
