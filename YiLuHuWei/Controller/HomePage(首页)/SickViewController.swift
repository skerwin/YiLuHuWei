//
//  SickViewController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/12.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class SickViewController: BaseViewController ,Requestable {
    
    //展示列表
    var tableView: UITableView!
    
    //搜索控制器
    var sickSearchController = UISearchController()
    
    //原始数据集
    var diseaseTypeModelList = [DiseaseCourse]()
    
    var searchModelList = [DiseaseSubCourse]()
 
    
    var searchResultList:[DiseaseSubCourse] = [DiseaseSubCourse](){
        didSet  {self.tableView.reloadData()}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black] //设置导航栏标题颜色
        self.navigationController!.navigationBar.tintColor = UIColor.black   //设置导航栏按钮颜色
        self.title = "发现"
        self.definesPresentationContext = true
        //self.automaticallyAdjustsScrollViewInsets = false;
        initTableView()
        loadData()
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
                                 forCellReuseIdentifier: "TypeCell")
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView!)
        
        //配置搜索控制器
        sickSearchController = UISearchController(searchResultsController: nil)
        sickSearchController.searchResultsUpdater = self
        //sickSearchController.definesPresentationContext = true
     
        sickSearchController.searchBar.delegate = self  //两个样例使用不同的代理
        sickSearchController.hidesNavigationBarDuringPresentation = true
        sickSearchController.dimsBackgroundDuringPresentation = false
        sickSearchController.searchBar.searchBarStyle = .minimal
        sickSearchController.searchBar.sizeToFit()
        let headview:UIView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: sickSearchController.searchBar.frame.size.height))
        headview.addSubview(sickSearchController.searchBar)
           
        self.tableView.tableHeaderView = headview
        sickSearchController.searchBar.showsCancelButton = true
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        //let frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)
//        if self.sickSearchController.isActive {
//            self.tableView.frame = CGRect(x: 0, y: navigationHeaderAndStatusbarHeight, width: self.view.frame.width,
//                                          height: self.view.frame.height - navigationHeaderAndStatusbarHeight)
//        }else{
//            self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width,
//                                          height: self.view.frame.height - navigationHeaderAndStatusbarHeight)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func loadData(){
        let diseasetypelist = HomeAPI.diseasetypelistPathAndParams()
        getRequest(pathAndParams: diseasetypelist,showHUD: true)
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        self.tableView.mj_header?.endRefreshing()
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        diseaseTypeModelList = getArrayFromJson(content:  responseResult)
        for model in diseaseTypeModelList{
            for subModel in model.subList {
                searchModelList.append(subModel)
            }
        }
        self.tableView.reloadData()
  
     }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension SickViewController: UISearchResultsUpdating
{
    //实时进行搜索
    func updateSearchResults(for searchController: UISearchController) {
        self.searchResultList = self.searchModelList.filter { (diseaseSubCourse) -> Bool in
            return diseaseSubCourse.subName.contains(searchController.searchBar.text!)
        }
    }
}
extension SickViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.sickSearchController.isActive {
            return self.searchResultList.count
        } else {
            return self.diseaseTypeModelList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        //为了提供表格显示性能，已创建完成的单元需重复使用
        let identify:String = "TypeCell"
        //同一形式的单元格重复使用，在声明时已注册
        let cell = tableView.dequeueReusableCell(withIdentifier: identify,
                                                 for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        if self.sickSearchController.isActive {
            cell.textLabel?.text = self.searchResultList[indexPath.row].subName
            return cell
        } else {
            cell.textLabel?.text = self.diseaseTypeModelList[indexPath.row].typeName
            return cell
        }
    }
}

extension SickViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = SickSubViewController()
        controller.titleStr =  self.diseaseTypeModelList[indexPath.row].typeName
        controller.subTypeModelList = self.diseaseTypeModelList[indexPath.row].subList
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension SickViewController: UISearchBarDelegate {
    //点击搜索按钮
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let key = searchBar.text!
        let controller = DiseaseListController()
        controller.titleStr = key
        controller.key = key
        self.navigationController?.pushViewController(controller, animated: true)
        self.searchResultList = self.searchModelList.filter { (diseaseSubCourse) -> Bool in
            return diseaseSubCourse.subName.contains(key)
        }
    }
    
    //点击取消按钮
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchResultList = self.searchModelList
    }
}

//自定义取消按钮
////----
//searchController.delegate = self;
//
//// --searchbar的代理方法
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    // --取消按钮
//    searchBar.showsCancelButton = YES;
//    UIButton *btn = [searchBar valueForKey:@"_cancelButton"];
//    [btn setTitle:@"取消" forState:UIControlStateNormal];
//    return YES;
//}
