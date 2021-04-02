//
//  SchoolViewController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/12.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper


let SCHOOLHEADHEIGHT:CGFloat = 210

class SchoolViewController: BaseViewController,Requestable {
    
    let recommandList = ["全部","推荐","最新","热门"]
    
    var departmentList = [DepartmentModel]()
    
    //let departmentList = ["最新","有","无"]
    
    var dropView:DOPDropDownMenu!
    
    var schoolHeadView:SchoolHeadView!
    
    var dateModelList = [AVCModel]()
    
    var orderby = 0
    
    var departmentid = 0
   
    
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = ""
        self.view.backgroundColor = ZYJColor.tableViewBg
        loadCache()
        initSearchView()
        initDropView()
        initTableView()
        loadData()
        addblankBtn()
     }
    
    
    
    func loadCache(){
        let result = XHNetworkCache.check(withURL: HomeAPI.departmenListPath)
        if result {
             let dict = XHNetworkCache.cacheJson(withURL: HomeAPI.departmenListPath)
            let responseJson = JSON(dict)
            print("缓存读取")
            departmentList = getArrayFromJson(content: responseJson["data"])
            var modelall = DepartmentModel()
            modelall?.name = "全部"
            modelall?.id = 0
            departmentList.insert(modelall!, at: 0)
         }
    }
    func loadData(){
       
        let requestParams = HomeAPI.cloudVideoListPathAndParams(page: page, limit: limit, order_type: orderby, department_id: departmentid)
        postRequest(pathAndParams: requestParams,showHUD: false)
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor.clear), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: UIColor.clear)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.clear   //设置导航栏按钮颜色
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        super.viewWillDisappear(animated)
        
    }
    func initTableView(){
        tableView = UITableView(frame: CGRect(x: 10, y: SCHOOLHEADHEIGHT + 44 - navigationHeaderAndStatusbarHeight, width: screenWidth - 20, height: screenHeight - bottomNavigationHeight - SCHOOLHEADHEIGHT - 44), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNibWithTableViewCellName(name: SchoolVideoCell.nameOfClass)
        self.tableView?.layer.cornerRadius = 20;
        self.tableView?.layer.masksToBounds = true
        
        tableView.backgroundColor = ZYJColor.tableViewBg
        
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
    
    func initSearchView(){
        schoolHeadView = Bundle.main.loadNibNamed("SchoolHeadView", owner: nil, options: nil)!.first as? SchoolHeadView
        schoolHeadView.frame = CGRect.init(x: 0, y: -navigationHeaderAndStatusbarHeight, width: screenWidth, height: CGFloat(SCHOOLHEADHEIGHT))
        schoolHeadView.textBgview.layer.cornerRadius = 20;
        schoolHeadView.textBgview.layer.masksToBounds = true
        schoolHeadView.delegeta = self
        schoolHeadView.tag = 998
        self.view.addSubview(schoolHeadView)
        
        //addGestureRecognizerToView(view: schoolHeadView.textBgview, target: self, actionName: "schoolHeadViewAction")
    }
    
 
   
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        
        
        let list:[AVCModel]  = getArrayFromJson(content: responseResult)
        
        dateModelList.append(contentsOf: list)
         if list.count < 10 {
              self.tableView.mj_footer?.endRefreshingWithNoMoreData()
          }
        self.tableView.reloadData()
        
        
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
        
    }
    
    
    func initDropView(){
       
        dropView = DOPDropDownMenu.init(origin: CGPoint.init(x: 0, y: SCHOOLHEADHEIGHT - navigationHeaderAndStatusbarHeight ), andHeight: 44)
        dropView.backgroundColor = UIColor.red
        dropView.indicatorColor = UIColor.darkGray
        dropView.fontSize = 14
        dropView.textColor = UIColor.darkGray
        dropView.delegate = self
        dropView.dataSource = self
        self.view.addSubview(dropView)
    }
    
    func addblankBtn(){
        let addblankBtn = UIButton(frame: CGRect(x: 0, y:  SCHOOLHEADHEIGHT - navigationHeaderAndStatusbarHeight - 44, width: screenWidth, height: 44))
        //addblankBtn.backgroundColor = UIColor.red
        addblankBtn.addTarget(self, action: #selector(addblankBtnAction(_:)), for: .touchUpInside)
        self.view.addSubview(addblankBtn)
    }
    
    @objc func addblankBtnAction(_ btn: UIButton){
      
        let controller = HomeSearchController()
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}

//实现tableview的代理方法
extension SchoolViewController:UITableViewDataSource,UITableViewDelegate {
    
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
//实现dropView的代理方法
extension SchoolViewController: DOPDropDownMenuDataSource,DOPDropDownMenuDelegate {
    
    func numberOfColumns(in menu: DOPDropDownMenu!) -> Int {
        return 2
    }
    func menu(_ menu: DOPDropDownMenu!, numberOfRowsInColumn column: Int) -> Int {
        switch column {
        case 0:
            return recommandList.count
        case 1:
            return departmentList.count
            
        default:
            return 0
        }
    }
    
    func menu(_ menu: DOPDropDownMenu!, titleForRowAt indexPath: DOPIndexPath!) -> String! {
        switch indexPath.column {
        case 0:
            return recommandList[indexPath.row]
        case 1:
            return departmentList[indexPath.row].name
            
        default:
            return ""
        }
    }

    
    func menu(_ menu: DOPDropDownMenu!, didSelectRowAt indexPath: DOPIndexPath!) {
        
        let colum = indexPath.column
        let row = indexPath.row
        if colum == 0{
            orderby = row
        }else{
            departmentid = departmentList[row].id
        }
        refreshList()
        print(colum,row)
        
    }
    func menu(_ menu: DOPDropDownMenu!, confirmBtnClick indexPathList: NSMutableDictionary!) {
                
    }
    func menu(_ menu: DOPDropDownMenu!, cancelBtnClick indexPathList: NSMutableDictionary!) {
    }
}
extension SchoolViewController:SchoolHeadViewDelegate{
    func searchAction() {
        let controller = HomeSearchController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

// 二级的时候用
//     func menu(_ menu: DOPDropDownMenu!, numberOfItemsInRow row: Int, column: Int) -> Int {
//
//        if column == 2{
//            if row == 0{
//                return self.educationList.count
//            }else if row == 1{
//                return self.experienceList.count
//            }else if row == 2{
//               return self.salaryMonthList.count
//            }else if row == 3{
//                return self.statusList.count
//            }
//        }
//        return 0
//    }
//    func menu(_ menu: DOPDropDownMenu!, titleForItemsInRowAt indexPath: DOPIndexPath!) -> String! {
//        if indexPath.column == 2{
//            if indexPath.row == 0{
//                return self.educationList[indexPath.item].label
//            }else if indexPath.row == 1{
//                return self.experienceList[indexPath.item].label
//            }else if indexPath.row == 2{
//                return self.salaryMonthList[indexPath.item].label
//            }else if indexPath.row == 3{
//                return self.statusList[indexPath.item].label
//            }
//        }
//        return ""
//    }
