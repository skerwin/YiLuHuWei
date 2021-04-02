//
//  HomeViewController.swift
//  YiLuHuWei
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
    case GuideInlet = 0
    case Rank
    case SubscribeCell
    case Recommend
   
    
   
    
    
}

class HomeViewController: BaseViewController ,Requestable{
    
    var tableView:UITableView!
    var AdvertisementView:SDCycleScrollView!
    var searView:HomeSearchView!
    
    var rankArticleModelList = [AVCModel]()
    
    var rankCaseModelList = [AVCModel]()
    
    var rankvideoModelList = [AVCModel]()
    
    var recommendArticleModelList = [AVCModel]()
    
    var adverModelList = [AdverModel]()
    
    var recommendGroupList = [SubscribeModel]()
    
    var imageArr = ["zuixin","remeng","bingli","biji","faxian","yixueqianyan","lanmu","yaoqichengguo"]
    var imageStr = ["最新","热门","病例","随手笔记","发现","医学前沿","科室栏目","药企成果"]
    
    var ColumnForModelList = [SubscribeModel]() //首页八个入口
 
    var autoCellHeight: CGFloat = 200
    
    var isToLogin = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.logoutAccount(account: "")
        self.navigationController?.navigationBar.topItem?.title = ""
        self.view.backgroundColor = ZYJColor.tableViewBg
        initUI()
        loadData()
        loadCommonData()
    }
    
    func initUI(){
        initSearchView()
        initTableView()
    }
    
    func loadCommonData(){
//        let CommonDataParams = HomeAPI.CommonDataPathPathAndParams()
//        getRequest(pathAndParams: CommonDataParams,showHUD: true)
        
        
        let requestParamsP = HomeAPI.privacyStatementAndParam()
        getRequest(pathAndParams: requestParamsP,showHUD: false)
        
        let requestParamsA = HomeAPI.aboutUsPathAndParam()
        getRequest(pathAndParams: requestParamsA,showHUD: false)
        
        let pathAndParams = HomeAPI.departmenListPathAndParams()
        postRequest(pathAndParams: pathAndParams,showHUD: false)
        
        let groupPathAndParams = HomeAPI.groupAllListPathAndParams()
        postRequest(pathAndParams: groupPathAndParams,showHUD: false)
     }
    
    func loadData(){
        let HomeParams = HomeAPI.HomeAllPathAndParams(limit: self.pagenum, page: self.page)
        postRequest(pathAndParams: HomeParams,showHUD: false)
    }
    
    func loadGuideData(){
        let ColumnForPathParams = HomeAPI.ColumnForPathAndParams()
        getRequest(pathAndParams: ColumnForPathParams,showHUD: false)
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
        if requestPath == HomeAPI.privacyStatement{
             setStringValueForKey(value: responseResult["url"].stringValue as String, key: "privacy_url")
             return
        }
        if requestPath == HomeAPI.aboutUsPath{
             setStringValueForKey(value: responseResult["url"].stringValue as String, key: "about_url")
             return
        }
        if requestPath == HomeAPI.ArticleRecommendPath{
            let list:[AVCModel] = getArrayFromJsonByArrayName(arrayName: "article_list", content:  responseResult)
            
            recommendArticleModelList.append(contentsOf: list)
            if list.count < 10 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            tableView.reloadData()
        }else if requestPath == HomeAPI.HomePath{
            
            adverModelList = getArrayFromJsonByArrayName(arrayName: "slide_list", content:  responseResult)
            recommendGroupList = getArrayFromJsonByArrayName(arrayName: "group_list", content: responseResult)
            
            
            rankArticleModelList = getArrayFromJsonByArrayName(arrayName: "article_top", content:  responseResult)
            rankCaseModelList = getArrayFromJsonByArrayName(arrayName: "case_top", content: responseResult)
            rankvideoModelList = getArrayFromJsonByArrayName(arrayName: "video_top", content: responseResult)
            
            
            if rankArticleModelList.count == 0{
                rankArticleModelList.append(AVCModel()!)
                rankArticleModelList.append(AVCModel()!)
            }
            if rankArticleModelList.count == 1{
                rankArticleModelList.append(AVCModel()!)
            }
            if rankCaseModelList.count == 0{
                rankCaseModelList.append(AVCModel()!)
                rankCaseModelList.append(AVCModel()!)
            }
            if rankCaseModelList.count == 1{
                rankCaseModelList.append(AVCModel()!)
            }
            if rankvideoModelList.count == 0{
                rankvideoModelList.append(AVCModel()!)
                rankvideoModelList.append(AVCModel()!)
            }
            if rankvideoModelList.count == 1{
                rankvideoModelList.append(AVCModel()!)
            }
            
            
            let list:[AVCModel] = getArrayFromJsonByArrayName(arrayName: "article_recommend_list", content:  responseResult)
            recommendArticleModelList.append(contentsOf: list)
            
            if list.count < 10 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            
            if list.count > 2{
                recommendArticleModelList.remove(at: 0)
                recommendArticleModelList.remove(at: 0)
            }
          

            ColumnForModelList.removeAll()
 
            for index in 0 ..< 8{
                var model = SubscribeModel()
                model?.cover = imageArr[index]
                model?.name = imageStr[index]
                ColumnForModelList.append(model!)
            }
        }
        tableView.tableHeaderView = getAdvertisementView(imageArr: adverModelList)
        tableView.reloadData()
    }
    
    func getAdvertisementView(imageArr:[AdverModel]) -> UIView {
        
        var imageArrTemp = [String]()
        if imageArr.count == 0{
            return UIView()
        }else{
            for model in imageArr {
                imageArrTemp.append(model.image)
            }
        }
        
        SDCycleScrollView.clearImagesCache()
        guard let advertisementView = SDCycleScrollView.init(frame: CGRect.init(x: 0, y: 8 , width: screenWidth - 20, height: topAdvertisementViewHeight), imageURLStringsGroup:imageArrTemp)
            else{
                return UIView() as! SDCycleScrollView
        }
        advertisementView.pageControlAliment = SDCycleScrollViewPageContolAliment(rawValue: 1)
        advertisementView.pageControlStyle = SDCycleScrollViewPageContolStyle(rawValue: 1)
        //pageControlBottomOffset
        advertisementView.delegate = self
        
        advertisementView.layer.cornerRadius = 15;
        advertisementView.layer.masksToBounds = true;
        
        let bannerView:UIView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth - 20, height: topAdvertisementViewHeight + 16))
        bannerView.addSubview(advertisementView)
        return bannerView
    }
    
    func initSearchView(){
        searView = Bundle.main.loadNibNamed("HomeSearchView", owner: nil, options: nil)!.first as? HomeSearchView
        searView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 44)
        searView.delegate = self
        searView.tag = 999
        self.navigationController?.navigationBar.addSubview(searView)
 
    }
    
    @objc func rightNavBtnClick(){
            let controller = HomeSearchController()
           self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func initTableView(){
        tableView = UITableView(frame: CGRect(x: 10, y: 0, width: screenWidth - 20, height: screenHeight - bottomNavigationHeight - navigationHeaderAndStatusbarHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNibWithTableViewCellName(name: HomeTopRankCell.nameOfClass)
        
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        
        tableView.registerNibWithTableViewCellName(name: OnlyContentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: OneImageContentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: TwoImageContentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: ThreeImageContentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: GuideInletCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: HomeSubscribeCell.nameOfClass)
        
        
        tableView.backgroundColor = ZYJColor.tableViewBg
 
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        addressHeadRefresh.backgroundColor = ZYJColor.tableViewBg
        tableView.mj_header = addressHeadRefresh

       let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
       footerRefresh.backgroundColor = ZYJColor.tableViewBg
       tableView.mj_footer = footerRefresh
//        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        let footV = UIView()
        footV.backgroundColor = ZYJColor.tableViewBg
        tableView.tableFooterView = footV
    }
    
    @objc func pullRefreshList() {
        page = page + 1
        self.pullLoadData()
    }
    
    func pullLoadData(){

        
        
        let articleParams = HomeAPI.ArticleRecommendPathAndParams(page: page, pageSize: 10)
        postRequest(pathAndParams: articleParams,showHUD: false)
    }
    
    @objc func refreshList() {
        recommendArticleModelList.removeAll()
        rankArticleModelList.removeAll()
        rankCaseModelList.removeAll()
        rankvideoModelList.removeAll()
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
        if (self.navigationController?.navigationBar.viewWithTag(999) == nil){
            self.navigationController?.navigationBar.addSubview(searView)
        }
       // self.navigationController?.navigationBar.addSubview(searView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (self.navigationController?.navigationBar.viewWithTag(999) == nil){
            self.navigationController?.navigationBar.addSubview(searView)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isToLogin{
        }else{
          searView.removeFromSuperview()
        }
    }
    
    override func pushLoginController(){
        let controller = UIStoryboard.getNewLoginController()
        controller.modalPresentationStyle = .fullScreen
        self.isToLogin = true
        controller.reloadLogin = {[weak self] () -> Void in
            self!.isToLogin = false
        }
        self.present(controller, animated: true, completion: nil)
    }
    
}

extension HomeViewController:SDCycleScrollViewDelegate{
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        
        if adverModelList[index].url == ""{
            return
        }
        let controller = AdverController()
        controller.urlString = adverModelList[index].url
        self.navigationController?.pushViewController(controller, animated: true)
        print(index)
    }
    
}
//实现tableview的代理方法
extension HomeViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if recommendGroupList.count == 0{
             return 3
        }
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch getMenuCellType(index: section){
        case .GuideInlet:
            return 1
        case .Rank:
            return 1
        case .Recommend:
            return recommendArticleModelList.count
        case .SubscribeCell:
            if recommendGroupList.count == 0{
                return recommendArticleModelList.count
            }
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = indexPath.section
        let row = indexPath.row
        switch getMenuCellType(index: section){
        case .GuideInlet:
            let cell = tableView.dequeueReusableCell(withIdentifier: GuideInletCell.nameOfClass) as! GuideInletCell
            //cell.delegeta = self
            cell.selectionStyle = .none
            cell.initCollectView()
            cell.GuideInletlList = self.ColumnForModelList
            cell.parentNavigationController = self.navigationController
            
            return cell
        case .Rank:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeTopRankCell.nameOfClass) as! HomeTopRankCell
            //cell.delegeta = self
            cell.selectionStyle = .none
            cell.rankArticleModelList = self.rankArticleModelList
            
            cell.rankCaseModelList = self.rankCaseModelList
            
            cell.rankvideoModelList = self.rankvideoModelList
            cell.parentNavigationController = self.navigationController
            cell.RankCollectIonView.reloadData()
            cell.backgroundColor = ZYJColor.tableViewBg
            return cell
        case .Recommend:
            
            let model = recommendArticleModelList[row]
            
            if model.show_type == 0{
     
                let cell = tableView.dequeueReusableCell(withIdentifier: OnlyContentCell.nameOfClass) as! OnlyContentCell
                cell.model =  recommendArticleModelList[row]
                cell.selectionStyle = .none
                return cell
            }else if model.show_type == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: OneImageContentCell.nameOfClass) as! OneImageContentCell
                cell.model = recommendArticleModelList[row]
                cell.selectionStyle = .none
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ThreeImageContentCell.nameOfClass) as! ThreeImageContentCell
                cell.model = recommendArticleModelList[row]
                cell.selectionStyle = .none
                return cell
            }
            
        case .SubscribeCell:
            if recommendGroupList.count == 0{
                let model = recommendArticleModelList[row]
                
                if model.show_type == 0{
         
                    let cell = tableView.dequeueReusableCell(withIdentifier: OnlyContentCell.nameOfClass) as! OnlyContentCell
                    cell.model =  recommendArticleModelList[row]
                    cell.selectionStyle = .none
                    return cell
                }else if model.show_type == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: OneImageContentCell.nameOfClass) as! OneImageContentCell
                    cell.model = recommendArticleModelList[row]
                    cell.selectionStyle = .none
                    return cell
                }else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ThreeImageContentCell.nameOfClass) as! ThreeImageContentCell
                    cell.model = recommendArticleModelList[row]
                    cell.selectionStyle = .none
                    return cell
                }
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeSubscribeCell.nameOfClass) as! HomeSubscribeCell
            //cell.delegeta = self
            cell.selectionStyle = .none
            cell.parentNavigationController = self.navigationController
            cell.initCollectView()
            cell.recommendList = self.recommendGroupList
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch getMenuCellType(index: section){
        case .Rank:
            return 200
        case .Recommend:
            let model = recommendArticleModelList[indexPath.row]
            if model.show_type == 0{
 
                return 109
            }else if model.show_type == 1{
                return 115
            }else {
                return 147
            }
        case .GuideInlet:
            return 155
        case .SubscribeCell:
            if recommendGroupList.count == 0{
                let model = recommendArticleModelList[indexPath.row]
                if model.show_type == 0{
     
                    return 109
                }else if model.show_type == 1{
                    return 115
                }else {
                    return 147
                }
            }
            return 153
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = Bundle.main.loadNibNamed("HomeRankHeaderView", owner: nil, options: nil)!.first as! HomeRankHeaderView
        sectionView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 44)
        
        sectionView.bgView.layer.cornerRadius = 10;
        sectionView.bgView.layer.masksToBounds = true
        switch getMenuCellType(index: section){
            
        case .Rank:
            return UIView()
        case .Recommend:
            sectionView.name.text = "好文推荐"
            //sectionView.moreBtn.setTitle("更多", for: .normal)
            return sectionView
        case .GuideInlet:
            return UIView()
        case .SubscribeCell:
            if recommendGroupList.count == 0{
                sectionView.name.text = "好文推荐"
                //sectionView.moreBtn.setTitle("更多", for: .normal)
                return sectionView
            }
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch getMenuCellType(index: section){
        case .Rank:
            return 0
        case .Recommend:
            return 44
        case .GuideInlet:
            return 0
        case .SubscribeCell:
            if recommendGroupList.count == 0{
                return 44
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        let section = indexPath.section
        let row = indexPath.row
        switch getMenuCellType(index: section){
        case .Rank:
            break
        case .Recommend:
            let controller = ArcticleDetailController()
            controller.fid = recommendArticleModelList[row].id
            self.navigationController?.pushViewController(controller, animated: true)

        case .GuideInlet:
            print("GuideInlet")
        case .SubscribeCell:
            if recommendGroupList.count == 0{
                let controller = ArcticleDetailController()
                controller.fid = recommendArticleModelList[row].id
                self.navigationController?.pushViewController(controller, animated: true)
            }
            print("SubscribeCell")
        }
    }
 
}
//搜索代理
extension HomeViewController:HomeSearchViewDelegate{
    
    func searchActoin() {
        let controller = HomeSearchController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func notifyClick(onV: UIView){
        if !currentIsLogin()  {
           self.pushLoginController()
           return
       }
        let conroller = NotifyController()
        self.navigationController?.pushViewController(conroller, animated: true)
    }
}
extension HomeViewController:YBPopupMenuDelegate{
    func ybPopupMenuDidSelected(at index: Int, ybPopupMenu: YBPopupMenu!) {
        print(index);
    }
    
 
}
