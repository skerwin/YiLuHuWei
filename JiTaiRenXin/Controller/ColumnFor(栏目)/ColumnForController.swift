//
//  ColumnForController.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/28.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

let COLUMN_BJ = "http://jimin.lnyouran.com/uploads/default/background.png";
//let COLUMN_BJ = "http://jmcdn.lnyouran.com/20201027/images/17fe537a7c93ff8edc2a12447235d3c2.jpg";

class ColumnForController: BaseViewController ,Requestable {

    
    var collectionView:UICollectionView!  //collectView
    var adView:UIView!
    var adImageview:UIImageView!
    
    var ColumnForModelList = [ColumnForModel]()
    var advModel = adverModel()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        initAdView()
        initCollectView()
        loadData()
       

        // Do any additional setup after loading the view.
     }
    
    
    func initAdView(){
        adView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenWidth * 0.4))
        adImageview = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenWidth * 0.4))
        adView.addSubview(adImageview)
        
        self.view.addSubview(adView)
    }
    
    func loadData(){
        
        let ColumnForPathParams = HomeAPI.ColumnForPathAndParams()
        getRequest(pathAndParams: ColumnForPathParams,showHUD: true)
        
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        collectionView.mj_header?.endRefreshing()
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        collectionView.mj_header?.endRefreshing()
        ColumnForModelList = getArrayFromJsonByArrayName(arrayName: "group_list", content:  responseResult)
        advModel = Mapper<adverModel>().map(JSONObject: responseResult["slide_info"].rawValue)
        // ColumnForModelList.removeAll(where: { $0.isshow == 0})
        adImageview.displayImageWithURL(url: advModel?.image_url)
       
        collectionView.reloadData()
  
     }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
            self.title = "栏目"
      }
    
      func initCollectView(){
          let collectionViewFrame = CGRect.init(x: 0, y: screenWidth * 0.4 + 15, width: screenWidth, height: screenHeight - navigationHeaderAndStatusbarHeight - bottomNavigationHeight - screenWidth * 0.4 - 15)
           let layout = UICollectionViewFlowLayout.init()
          
          self.collectionView = UICollectionView.init(frame: collectionViewFrame, collectionViewLayout: layout)
          self.collectionView?.dataSource = self
          self.collectionView?.delegate = self
          self.collectionView?.backgroundColor = UIColor.white
          self.collectionView?.allowsMultipleSelection = true
          self.collectionView?.showsVerticalScrollIndicator = false
          self.collectionView?.showsHorizontalScrollIndicator = false
          self.collectionView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0 )
          self.collectionView!.register(UINib(nibName:"ColumnForCell", bundle:nil),
                                                     forCellWithReuseIdentifier: "ColumnForCell")
        
         let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
         self.collectionView?.mj_header = addressHeadRefresh
        
        // tableView.mj_header?.beginRefreshing()
 
        self.view.addSubview(self.collectionView)
        
    }
    
     @objc func refreshList() {
           self.loadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ColumnForController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize.init(width: screenWidth/4, height: screenWidth/4 + 10)
        return size
    }
    
    //itme间的上下距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //itme间的左右距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
//    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, referenceSizeForHeaderInSection section:Int) -> CGSize {
//        return CGSize.init(width: screenWidth - 50, height: 15)
//    }
    //整个itme区域上下左右的编剧
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
    }
}
extension ColumnForController:UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    
    func numberOfSections(in collectionView:UICollectionView) ->Int{
        //return self.dataSources.count
        return 1
    }
    
    func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int {
        return ColumnForModelList.count
         
    }
    
    func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColumnForCell.nameOfClass, for: indexPath) as! ColumnForCell
        cell.model = ColumnForModelList[indexPath.row]
        return cell
        
     }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ChannelViewController()
        vc.menupagetype = MenuPageType.ColumForDetail
        vc.cid = ColumnForModelList[indexPath.row].id
        vc.columForModel = ColumnForModelList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
