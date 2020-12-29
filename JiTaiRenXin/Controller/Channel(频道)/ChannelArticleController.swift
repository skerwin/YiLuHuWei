//
//  ChannelArticleController.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/27.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import SDCycleScrollView



class ChannelArticleController: BaseViewController ,Requestable {
    
    
    var parentNavigationController: UINavigationController?
    var tableView:UITableView!
    
    var AdvertisementView:SDCycleScrollView!
    
    var menupagetype:MenuPageType!
    
    
    var rankArticleModelList = [ArticleModel]()
    
    var adverModelList = [adverModel]()
      
    var cid = 0 //栏目详情页的时候要传一个栏目详情id
    var columForModel = ColumnForModel()
    
   var searchWordKey = "" //搜索用的关键词
    
    
    var isMineViewAppear = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if menupagetype == MenuPageType.Channel {
            
        }else if menupagetype == MenuPageType.ColumForDetail{
            
        }else if menupagetype == MenuPageType.HomeMore{
            self.title = "文章排行"
        }else{
            
        }
        initUI()
        loadData()
    }
    
    func initUI(){
        initTableView()
    }
    
    func loadData(){
         if menupagetype == MenuPageType.Channel {
            let ChnnelParams =  HomeAPI.AllListPathAndParams(page: page, pageSize: 10, obj_type: 1, is_recommended: 0, group_id: 0, keyword: "")
            
            postRequest(pathAndParams: ChnnelParams,showHUD: true)
            
            let article_slide = intForKey(key: "article_slide") ?? 0
            let SlideParams =  HomeAPI.SlideListPathPathAndParams(id: article_slide)
            
            postRequest(pathAndParams: SlideParams,showHUD: false)
            
        }else if menupagetype == MenuPageType.ColumForDetail{
            
            let ChnnelParams = HomeAPI.AllListPathAndParams(page: page, pageSize: 10, obj_type: 1, is_recommended: 0, group_id: cid, keyword: "")
            postRequest(pathAndParams: ChnnelParams,showHUD: false)
        }else if menupagetype == MenuPageType.HomeMore{
            
            let HomeMoreParams = HomeAPI.AllListPathAndParams(page: 1, pageSize: 10, obj_type: 1, is_recommended: 0, group_id: 0, keyword: "")
            postRequest(pathAndParams: HomeMoreParams,showHUD: false)
            
        }else if menupagetype == MenuPageType.Search{
            
            let requestParams = HomeAPI.AllListPathAndParams(page: page, pageSize: 10, obj_type: 1, is_recommended: 0, group_id: 0, keyword: searchWordKey)
            
            postRequest(pathAndParams: requestParams,showHUD: false)
        }else if menupagetype == MenuPageType.MineCare{
            isMineViewAppear = true
            let requestParams = HomeAPI.mineCollectPathAndParams(obj_type: 1, pageSize: pagenum, page: page)
            postRequest(pathAndParams: requestParams,showHUD: true)
        }else if menupagetype == MenuPageType.MineGood{
             isMineViewAppear = true
            let requestParams = HomeAPI.mineGoodListPathAndParams(obj_type: 1, pageSize: pagenum ,page: page)
            postRequest(pathAndParams: requestParams,showHUD: true)
        }
        else{
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          if isMineViewAppear == false{
              if menupagetype == MenuPageType.MineCare{
                   refreshList()
              }else if menupagetype == MenuPageType.MineGood{
                  refreshList()
              }
          }
          
      }
      override func viewDidDisappear(_ animated: Bool) {
          super.viewDidDisappear(animated)
          isMineViewAppear = false
      }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
        tableView.mj_header?.endRefreshing()
             tableView.mj_footer?.endRefreshing()
        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
     
        
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        var list:[ArticleModel]!
        
        if requestPath == HomeAPI.SlideListPath{
            adverModelList = getArrayFromJson(content: responseResult)
            tableView.tableHeaderView = getAdvertisementView(imageArr: adverModelList)
            tableView.reloadData()
            return
        }
        
        if requestPath == HomeAPI.mineCollectPath || requestPath == HomeAPI.mineGoodListPath {
            
            let MineList:[MimeTypeModel] = getArrayFromJsonByArrayName(arrayName: "list", content:  responseResult)
            if MineList.count < 10 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            for model in MineList {
                rankArticleModelList.append(model.article!)
            }
            
         }else{
            
            list = getArrayFromJsonByArrayName(arrayName: "list", content:  responseResult)
            rankArticleModelList.append(contentsOf: list)
            if list.count < 10 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        }
        
        tableView.reloadData()
    }
    
    func getAdvertisementView(imageArr:[adverModel]) -> UIView {
        
        var imageArrTemp = [String]()
        if imageArr.count == 0{
            return UIView()
        }else{
            for model in imageArr {
                imageArrTemp.append(model.image_url)
            }
        }
        
        guard let advertisementView = SDCycleScrollView.init(frame: CGRect.init(x: 8, y: 8 , width: screenWidth - 16, height: topAdvertisementViewHeight), imageURLStringsGroup:imageArrTemp)
            else{
                return UIView() as! SDCycleScrollView
                
        }
        advertisementView.delegate = self
        
        advertisementView.layer.cornerRadius = 16;
        advertisementView.layer.masksToBounds = true;
        
        let bannerView:UIView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: topAdvertisementViewHeight + 16))
        bannerView.addSubview(advertisementView)
        return bannerView
    }
    
    func initTableView(){
        
        
        
        if menupagetype == MenuPageType.Channel {
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navigationHeaderAndStatusbarHeight - bottomNavigationHeight - pageMenuHeight), style: .plain)
        }
        else if menupagetype == MenuPageType.ColumForDetail{
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navigationHeaderAndStatusbarHeight - bottomNavigationHeight - 172), style: .plain)
        }
        else if menupagetype == MenuPageType.HomeMore{
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navigationHeaderAndStatusbarHeight), style: .plain)
        }
        else if menupagetype == MenuPageType.Search{
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navigationHeaderAndStatusbarHeight - pageMenuHeight), style: .plain)
        }
        else{
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navigationHeaderAndStatusbarHeight - pageMenuHeight), style: .plain)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 240;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNibWithTableViewCellName(name: ImageAndContentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: ImageOnlyCell.nameOfClass)
        tableView.register(testTableViewCell.classForCoder(), forCellReuseIdentifier: "testTableViewCell")
        
        if menupagetype != MenuPageType.HomeMore{
            let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
            tableView.mj_header = addressHeadRefresh
            
            let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
            tableView.mj_footer = footerRefresh
        }
 
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        tableView.tableFooterView = UIView()
    }
    
    @objc func pullRefreshList() {
        page = page + 1
        self.loadData()
    }
    
    @objc func refreshList() {
        rankArticleModelList.removeAll()
        self.tableView.mj_footer?.resetNoMoreData()
        page = 1
        self.loadData()
    }
    
    
    var autoCellHeight: CGFloat = 0
    
}//实现tableview的代理方法

extension ChannelArticleController:SDCycleScrollViewDelegate{
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        let controller = AdverController()
        controller.urlString = adverModelList[index].url
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
extension ChannelArticleController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: rankArticleModelList.count ,isdisplay: true)
        if rankArticleModelList.count == 0{
            return 0
        }
        return rankArticleModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let row = indexPath.row
        let model = rankArticleModelList[row]
        if  model.show_type == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "testTableViewCell", for: indexPath) as! testTableViewCell
            
            cell.contentHeight = autoCellHeight
            cell.model = rankArticleModelList[row]
            cell.selectionStyle = .none
            return cell
        }else if model.show_type == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageOnlyCell", for: indexPath) as! ImageOnlyCell
            cell.selectionStyle = .none
            //cell.delegeta = self
            cell.model = rankArticleModelList[row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageAndContentCell", for: indexPath) as! ImageAndContentCell
            cell.selectionStyle = .none
            cell.model = rankArticleModelList[row]
            //cell.delegeta = self
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row = indexPath.row
        let model = rankArticleModelList[row]
        if  model.show_type == 0{
            let text = model.desc
            let rect:CGSize = text.getStringSize(width: screenWidth, fontSize: 16)
            autoCellHeight = rect.height
            return rect.height + 76;
        }else if model.show_type == 3{
            return 150
        }else{
            return 140
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = ArcticleDetailController()
        controller.fid = rankArticleModelList[indexPath.row].id
        controller.menytype = MenuType.Articel
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}
