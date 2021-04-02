//
//  CompaniesPresentController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/21.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import SDCycleScrollView

class CompaniesFrontiersController: BaseViewController ,Requestable {

    var tableView:UITableView!
    
    var dataModelList = [SubscribeModel]()
    
    var adImageview:UIImageView!
    var adView:UIView!
    
    var isCompany = true
    var groupType = 2
    
    var groupid = 0
    
    var isCareGroup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        if isCareGroup == true{
        }else{
            initAdView()
        }
        
       
        if isCareGroup == true{
            self.title = "我的订阅"
        }else{
            if isCompany {
                groupType = 2
                self.title = "药企成果"
            }else{
                groupType = 3
                self.title = "医学前沿"
            }
            
        }
        self.view.backgroundColor = ZYJColor.tableViewBg
        loadData()
        
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        
        if isCareGroup == true{
            let MinepathAndParams = HomeAPI.myGroupListPathAndParams()
            postRequest(pathAndParams: MinepathAndParams,showHUD: false)
        }else{
            let pathAndParams = HomeAPI.groupListPathAndParams(group_type: groupType)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }
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
    
    @objc func refreshList() {
        
        self.loadData()
    }
    
    
    func initAdView(){
        adView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenWidth * 0.4))
        adImageview = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenWidth * 0.4))
        
        if isCompany {
            adImageview.image = UIImage.init(named: "yaoqichengguos")
        }else{
            adImageview.image = UIImage.init(named: "yixueqianyans")
        }
        
        
        adView.addSubview(adImageview)
        
        self.view.addSubview(adView)
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
 
        if requestPath == HomeAPI.ColumnCollectPath{
            loadData()
            let operate = responseResult["hand_status"].intValue
            if operate == 0{
                showOnlyTextHUD(text: "取消订阅成功")
              }else{
                showOnlyTextHUD(text: "订阅成功")
             }
        }else{
            dataModelList = getArrayFromJson(content: responseResult)
        }
 
        self.tableView.reloadData()
    }
    
    func initTableView(){
        
        if isCareGroup == true{
            tableView = UITableView(frame: CGRect(x: 10, y: 0, width: screenWidth - 20, height: screenHeight - navigationHeaderAndStatusbarHeight), style: .plain)
        }else{
            tableView = UITableView(frame: CGRect(x: 10, y: screenWidth * 0.4 + 8, width: screenWidth - 20, height: screenHeight - navigationHeaderAndStatusbarHeight - screenWidth * 0.4), style: .plain)
        }
        
      
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 240;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNibWithTableViewCellName(name: CompaniesPresentCell.nameOfClass)
        self.tableView?.layer.cornerRadius = 20;
        self.tableView?.layer.masksToBounds = true
        self.tableView?.backgroundColor = ZYJColor.tableViewBg
        
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh
        
        view.addSubview(tableView)
        
        tableView.tableFooterView = UIView()
      
    }
 
    
    var autoCellHeight: CGFloat = 0
    
}//实现tableview的代理方法
extension CompaniesFrontiersController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: dataModelList.count ,isdisplay: true)

        return dataModelList.count
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "CompaniesPresentCell", for: indexPath) as! CompaniesPresentCell
        cell.selectionStyle = .none
        cell.model = dataModelList[indexPath.row]
        cell.delegate = self
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 83
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = ColumForDetailController()
        controller.columForModel = dataModelList[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
 
    }
}
extension CompaniesFrontiersController:CompaniesPresentCellDelegate {
    func careBtnAction(groupid: Int) {
        self.groupid = groupid
        self.careData()
    }
    
    
}
