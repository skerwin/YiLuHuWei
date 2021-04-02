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




class ClumnForController:BaseViewController ,Requestable  {
    
    
    var tableView:UITableView!
    var columForHeaderView:ColumForHeaderView!//栏目的头
    
    var columForModelList = [SubscribeModel]()
    
    var adView:UIView!
    var adImageview:UIImageView!
    
    var groupid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "科室栏目"
        initAdView()
        initTableView()
        loadColumData()
    }
    
    
    
    func loadColumData(){
        let pathAndParams = HomeAPI.groupListPathAndParams(group_type: 1)
        postRequest(pathAndParams: pathAndParams,showHUD: false)
    }
    

    
    
    
    func initTableView(){
        
        tableView = UITableView(frame: CGRect(x: 0,y: 0, width: screenWidth, height: screenHeight - navigationHeaderAndStatusbarHeight ), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 240;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh
        
        tableView.registerNibWithTableViewCellName(name: ColumnForCell.nameOfClass)
        tableView.backgroundColor = ZYJColor.tableViewBg
        
        view.addSubview(tableView)
        self.tableView.tableHeaderView = adView
        
        tableView.tableFooterView = UIView()
    }
    
    @objc func refreshList() {
        
        self.loadColumData()
    }
    
    
    func initAdView(){
        adView = UIView.init(frame: CGRect.init(x: 0, y: 0 , width: screenWidth, height: screenWidth * 0.4 + 8))
        adView.backgroundColor = ZYJColor.tableViewBg
        
        adImageview = UIImageView.init(frame: CGRect.init(x: 0, y: 0 , width: screenWidth, height: screenWidth * 0.4))
        adImageview.image = UIImage.init(named: "lanmuSlide")
        adImageview.contentMode = .scaleToFill
        
        //self.adImageview?.layer.cornerRadius = 10;
        //self.adImageview?.layer.masksToBounds = true
        
        adView.addSubview(adImageview)
        
        self.view.addSubview(adView)
    }
 
 
    override func pushLoginController(){
        let controller = UIStoryboard.getNewLoginController()
        controller.modalPresentationStyle = .fullScreen
        controller.reloadLogin = {[weak self] () -> Void in
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func careData (){
        
        if !currentIsLogin() {
            self.pushLoginController()
        }else{
 
            let pathAndParams = HomeAPI.ColumnCollectPathAndParams(id: groupid)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }
        
        
    }
    
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        if requestPath == HomeAPI.ColumnCollectPath{
            loadColumData()
            let operate = responseResult["hand_status"].intValue
            if operate == 0{
                showOnlyTextHUD(text: "取消订阅成功")
              }else{
                showOnlyTextHUD(text: "订阅成功")
             }
        }else{
            columForModelList = getArrayFromJson(content: responseResult)
        }
        
       
        self.tableView.reloadData()
        
        
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
  
    
    
    
}

extension ClumnForController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return columForModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ColumnForCell.nameOfClass) as! ColumnForCell
        cell.model =  columForModelList[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 111
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ColumForDetailController()
        controller.columForModel = columForModelList[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
}
extension ClumnForController:ColumnForCellDelegate {
    func careBtnAction(groupid: Int) {
        self.groupid = groupid
        self.careData()
    }
    
    
}
