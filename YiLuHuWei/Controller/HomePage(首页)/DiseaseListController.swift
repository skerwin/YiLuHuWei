//
//  DiseaseListController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/20.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class DiseaseListController: BaseViewController,Requestable {

    //展示列表
    var tableView: UITableView!
    
     //原始数据集
    var DiseaseList = [DiseaseListModel]()
    
    var subTypeId = ""
    var key = ""
    var titleStr = ""
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleStr
        initTableView()
        loadData()
       
        // Do any additional setup after loading the view.
    }
    
    func initTableView(){
        //创建表视图
        let tableViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width,
                                    height: self.view.frame.height - navigationHeaderAndStatusbarHeight)
        self.tableView = UITableView(frame: tableViewFrame, style:.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView.tableFooterView = UIView()
//        //创建一个重用的单元格
//        self.tableView!.register(UITableViewCell.,
//                                 forCellReuseIdentifier: "SubCell")
        
        //self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView!)
 
    }
   // 0300
    func loadData(){
        let diseasetypelist = HomeAPI.diseasesSarchlistPathAndParams(key: key, page: "", subTypeId: subTypeId, typeId: "")
        postRequest(pathAndParams: diseasetypelist,showHUD: true)
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        self.tableView.mj_header?.endRefreshing()
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        DiseaseList = getArrayFromJsonByArrayName(arrayName: "list", content:  responseResult)
        
        self.tableView.reloadData()
  
     }
 
 
}
extension DiseaseListController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: DiseaseList.count ,isdisplay: true)
        return self.DiseaseList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        //为了提供表格显示性能，已创建完成的单元需重复使用
        let identify:String = "SubCell"
 
        var cell:UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: identify)
        
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: identify)
        }
        cell?.textLabel?.text =  self.DiseaseList[indexPath.row].name
        cell?.detailTextLabel?.text = self.DiseaseList[indexPath.row].summary.html2String
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell?.accessoryType = .disclosureIndicator
        return cell!
        
    }
}

extension DiseaseListController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let controller = UIStoryboard.getDiseaseDetailController()
        controller.diseaseID = self.DiseaseList[indexPath.row].id
        self.navigationController?.pushViewController(controller, animated: true)
      }
}
