//
//  HomeViewController.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/24.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import SDCycleScrollView




enum MenuType: Int {
    case Articel = 0// 文章
    case Video  // 视频
    case Report // 病例
}

enum menuCellType: Int{
    case Rank = 0
    case Recommend
}

class HomeViewController: BaseViewController ,Requestable{
    
    
    var tableView:UITableView!
    
    var AdvertisementView:SDCycleScrollView!
    var searView:HomeSearchView!
    
    
    var rankArticleModelList = [ArticleModel]()
    
    var rankCaseModelList = [CaseModel]()
    
    var rankvideoModelList = [videoModel]()
    
    var recommendArticleModelList = [ArticleModel]()
    
    var recommendTopModelList = [ArticleModel]()
    
    var adverModelList = [adverModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.topItem?.title = ""
        
        initUI()
        loadData()
        loadCommonData()
    }
    
    func initUI(){
        initSearchView()
        initTableView()
    }
    
    func loadCommonData(){
        let CommonDataParams = HomeAPI.CommonDataPathPathAndParams()
        getRequest(pathAndParams: CommonDataParams,showHUD: true)
     }
    
    func loadData(){
        let HomeAllResumeParams = HomeAPI.HomeAllPathAndParams(pageSize: self.pagenum, page: self.page)
        postRequest(pathAndParams: HomeAllResumeParams,showHUD: true)
        
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
        if requestPath == HomeAPI.CommonDataPath{
            setIntValueForKey(value: responseResult["article_slide"].intValue as Int, key: "article_slide")
            setIntValueForKey(value: responseResult["case_slide"].intValue as Int, key: "case_slide")
            setIntValueForKey(value: responseResult["video_slide"].intValue as Int, key: "video_slide")
            
            setStringValueForKey(value: responseResult["privacy_url"].stringValue as String, key: "privacy_url")
            setStringValueForKey(value: responseResult["about_url"].stringValue as String, key: "about_url")
            return
        }
        
        if requestPath == HomeAPI.AllListPath {
            let list:[ArticleModel] = getArrayFromJsonByArrayName(arrayName: "list", content:  responseResult)
            
            recommendArticleModelList.append(contentsOf: list)
            if list.count < 10 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        }else if requestPath == HomeAPI.HomeAllPath{
            
            rankArticleModelList = getArrayFromJsonByArrayName(arrayName: "article_rank", content:  responseResult)
            
            rankCaseModelList = getArrayFromJsonByArrayName(arrayName: "case_rank", content: responseResult)
            rankvideoModelList = getArrayFromJsonByArrayName(arrayName: "video_rank", content: responseResult)

            adverModelList = getArrayFromJsonByArrayName(arrayName: "index_banner", content:  responseResult)
            
            let list:[ArticleModel] = getArrayFromJsonByArrayName(arrayName: "article_recommend", content:  responseResult)
            recommendArticleModelList.append(contentsOf: list)
            if list.count < 10 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            
            if list.count > 0{
                recommendTopModelList.append(list.first!)
                recommendArticleModelList.remove(at: 0)
            }
        }
     
        tableView.reloadData()
        tableView.tableHeaderView = getAdvertisementView(imageArr: adverModelList)
        
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
        bannerView.backgroundColor = UIColor.white
        bannerView.addSubview(advertisementView)
        return bannerView
    }
    
    func initSearchView(){
//        searView = Bundle.main.loadNibNamed("HomeSearchView", owner: nil, options: nil)!.first as? HomeSearchView
//        searView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 44)
//        searView.delegate = self
//        searView.tag = 999
//        self.navigationController?.navigationBar.addSubview(searView)
        
           self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "sousuo"), style: .plain, target: self, action: #selector(rightNavBtnClick))
    }
    
    @objc func rightNavBtnClick(){
            let controller = HomeSearchController()
           self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func initTableView(){
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - bottomNavigationHeight - navigationHeaderAndStatusbarHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNibWithTableViewCellName(name: HomeTopRankCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: RecommendFirstCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: RecommendOtherCell.nameOfClass)
        
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh
        //tableView.mj_header?.beginRefreshing()
        
        let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
        tableView.mj_footer = footerRefresh
        
        view.addSubview(tableView)
        
        tableView.tableFooterView = UIView()
    }
    
    @objc func pullRefreshList() {
        page = page + 1
        self.pullLoadData()
    }
    
    func pullLoadData(){
        let articleParams = HomeAPI.AllListPathAndParams(page: page, pageSize: 10, obj_type: 1, is_recommended: 1, group_id: 0, keyword: "")
        postRequest(pathAndParams: articleParams,showHUD: false)
    }
    
    @objc func refreshList() {
        recommendArticleModelList.removeAll()
        rankArticleModelList.removeAll()
        rankCaseModelList.removeAll()
        rankvideoModelList.removeAll()
        recommendTopModelList.removeAll()
        adverModelList.removeAll()
        
        self.tableView.mj_footer?.resetNoMoreData()
        page = 1
        self.loadData()
    }
    
    
    func getMenuCellType(index:Int) ->menuCellType{
        return menuCellType.init(rawValue: index)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.navigationController?.navigationBar.addSubview(searView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if (self.navigationController?.navigationBar.viewWithTag(999) == nil){
//            self.navigationController?.navigationBar.addSubview(searView)
//        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //searView.removeFromSuperview()
    }
    
}

extension HomeViewController:SDCycleScrollViewDelegate{
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        let controller = AdverController()
        controller.urlString = adverModelList[index].url
        self.navigationController?.pushViewController(controller, animated: true)
        print(index)
    }
    
}
//实现tableview的代理方法
extension HomeViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch getMenuCellType(index: section){
        case .Rank:
            return 1
        case .Recommend:
            tableView.tableViewDisplayWithMsg(message: "暂无内容", rowCount: recommendArticleModelList.count ,isdisplay: true)
            if recommendTopModelList.count == 0{
                return recommendArticleModelList.count
            }
            return recommendArticleModelList.count  + 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = indexPath.section
        let row = indexPath.row
        switch getMenuCellType(index: section){
        case .Rank:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeTopRankCell.nameOfClass) as! HomeTopRankCell
            //cell.delegeta = self
            cell.selectionStyle = .none
            cell.rankArticleModelList = self.rankArticleModelList
            
            cell.rankCaseModelList = self.rankCaseModelList
            
            cell.rankvideoModelList = self.rankvideoModelList
            cell.parentNavigationController = self.navigationController
            cell.RankCollectIonView.reloadData()
            return cell
        case .Recommend:
            
            if recommendTopModelList.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: RecommendOtherCell.nameOfClass) as! RecommendOtherCell
                cell.model = recommendArticleModelList[row]
                cell.selectionStyle = .none
                return cell
            }else{
                if row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: RecommendFirstCell.nameOfClass) as! RecommendFirstCell
                    cell.model = recommendTopModelList.first
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: RecommendOtherCell.nameOfClass) as! RecommendOtherCell
                    cell.model = recommendArticleModelList[row - 1]
                    cell.selectionStyle = .none
                    return cell
                }
            }
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        switch getMenuCellType(index: section){
        case .Rank:
            return 290
        case .Recommend:
            if recommendTopModelList.count == 0{
                return 108
            }else{
                if row == 0{
                    return 220
                }else{
                    return 108
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = Bundle.main.loadNibNamed("HomeRankHeaderView", owner: nil, options: nil)!.first as! HomeRankHeaderView
        sectionView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 44)
        sectionView.dotView.backgroundColor = ZYJColor.main
        sectionView.dotView.layer.cornerRadius = 5;
        sectionView.dotView.layer.masksToBounds = true;
        switch getMenuCellType(index: section){
            
        case .Rank:
            sectionView.name.text = "本周排行"
            return sectionView
        case .Recommend:
            sectionView.name.text = "好文推荐"
            //sectionView.moreBtn.setTitle("更多", for: .normal)
            return sectionView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch getMenuCellType(index: section){
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let row = indexPath.row
        switch getMenuCellType(index: section){
        case .Rank:
            break
        case .Recommend:
            
            if recommendTopModelList.count == 0 {
                let controller = ArcticleDetailController()
                controller.fid = recommendArticleModelList[row].id
                controller.menytype = MenuType.Articel
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                if row == 0{
                    
                    let controller = ArcticleDetailController()
                    controller.fid = recommendTopModelList.first?.id
                    controller.menytype = MenuType.Articel
                    self.navigationController?.pushViewController(controller, animated: true)
                }else{
                    let controller = ArcticleDetailController()
                    controller.fid = recommendArticleModelList[row - 1].id
                    controller.menytype = MenuType.Articel
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
}
//搜索代理
extension HomeViewController:HomeSearchViewDelegate{
    
    func searchActoin() {
        let controller = HomeSearchController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
