//
//  SickSubViewController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/20.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class SickSubViewController: BaseViewController,Requestable {
    
    //展示列表
    var tableView: UITableView!
    //原始数据集
    var subTypeModelList = [DiseaseSubCourse]()
    var titleStr = ""
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.title = titleStr
        initTableView()
        // Do any additional setup after loading the view.
    }
    
    func initTableView(){
        //创建表视图
        let tableViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width,
                                    height: self.view.frame.height - navigationHeaderAndStatusbarHeight)
        self.tableView = UITableView(frame: tableViewFrame, style:.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,
                                 forCellReuseIdentifier: "SubCell")
        //self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView!)
        self.tableView.tableFooterView = UIView()
 
    }
 
}
extension SickSubViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: subTypeModelList.count ,isdisplay: true)
        return self.subTypeModelList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        //为了提供表格显示性能，已创建完成的单元需重复使用
        let identify:String = "SubCell"
        //同一形式的单元格重复使用，在声明时已注册
        let cell = tableView.dequeueReusableCell(withIdentifier: identify,
                                                 for: indexPath)
        
        cell.textLabel?.text = self.subTypeModelList[indexPath.row].subName
        cell.accessoryType = .disclosureIndicator
        //cell.textLabel?.textAlignment = .center
        return cell
        
    }
}

extension SickSubViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = DiseaseListController()
        controller.subTypeId = self.subTypeModelList[indexPath.row].subId
        controller.titleStr = self.subTypeModelList[indexPath.row].subName
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
