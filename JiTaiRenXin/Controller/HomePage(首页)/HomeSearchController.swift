//
//  HomeSearchController.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/08/03.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import ObjectMapper
import SwiftyJSON
import MJRefresh


class HomeSearchController: BaseViewController ,Requestable {
    
    
    
    
    let ZCollectionViewCellsHorizonMargin:CGFloat          = 8;
    let ZCollectionViewCellHeight:CGFloat                  = 30;
    let ZCollectionViewItemButtonImageToTextMargin:CGFloat = 5;
    
    let ZCollectionViewToLeftMargin:CGFloat                = 15;
    let ZCollectionViewToTopMargin:CGFloat                 = 12;
    let ZCollectionViewToRightMargin:CGFloat               = 15;
    let ZCollectionViewToBottomtMargin:CGFloat             = 10;
    let ZCellBtnCenterToBorderMargin:CGFloat               = 12;
    let searchViewHeight: CGFloat = 50
    var searchBarView: SearchBarView?
    
    var collectionView:UICollectionView!  //collectView
    
    var recentSearchKeywordArray = [String]() //历史词
    
    var hotWordList = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        initSearchBarView()
        initUIView()
        
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        let requestParams = HomeAPI.HotSearchPathPathAndParams()
        getRequest(pathAndParams: requestParams,showHUD: true)
        
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
       
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
         
        
//        let jsonData:Data = jsonString.data(using: .utf8)!
//
//        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        
        hotWordList  = responseResult.rawValue as! [String]
 
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        if let tempHistrityArr:[String] = objectForKey(key: Constants.historyWord + (stringForKey(key: Constants.userid) ?? "")) as? [String]{
            recentSearchKeywordArray = tempHistrityArr
            if tempHistrityArr.count > 10 {
                for index in 10 ... tempHistrityArr.count - 1 {
                    recentSearchKeywordArray.remove(at: index)
                }
            }
            collectionView.reloadData()
        }
       // recentSearchKeywordArray.removeAll()
      // collectionView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBarView?.searchTextField?.resignFirstResponder()
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func initSearchBarView() {
        searchBarView = SearchBarView(frame: CGRect(x: 0, y: statubarHeight, width: screenWidth, height: searchViewHeight), searchTypeButtonWidth: 40)
        if let _ = searchBarView {
            searchBarView?.delegate = self
            // searchBarView?.secarchType = self.searchType
            searchBarView?.setPlaceHolder(holderText: "请输入您要搜索的内容")
            view.addSubview(searchBarView!)
        }
        self.navigationItem.titleView = searchBarView
    }
    
    func initUIView(){
        let collectionViewFrame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight - navigationHeaderAndStatusbarHeight)
        let layout = UICollectionViewLeftAlignedLayout.init()
        
        self.collectionView = UICollectionView.init(frame: collectionViewFrame, collectionViewLayout: layout)
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.allowsMultipleSelection = true
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.contentInset = UIEdgeInsets.init(top: 12, left: 0, bottom: 0, right: 0 )
        self.collectionView?.register(CollectionDropCell.self, forCellWithReuseIdentifier: CollectionDropCell.nameOfClass)
        self.collectionView?.register(CollectionDropSectionVIew.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionDropSectionVIew.nameOfClass)
        self.view.addSubview(self.collectionView)
    }
    
    func calculateItemWidth(text:String) ->CGFloat{
        let size = text.getStringSize(width: screenWidth - ZCollectionViewToLeftMargin * 2, fontSize: 16)
        let itemWidth:CGFloat = CGFloat(ceilf(Float(size.width))) + ZCellBtnCenterToBorderMargin
        return itemWidth
    }
    
}

extension HomeSearchController:SearchBarViewDelegate{
    func searchAction(searchText: String) {
        
        let keyword = searchText
        
        if keyword.isLengthEmpty() {
            showOnlyTextHUD(text: "请输入查询关键字")
            return
        }
        
        if let tempHistrityArr:[String] = objectForKey(key: Constants.historyWord + (stringForKey(key: Constants.userid) ?? "")) as? [String]{
            var keywordExisted = false
            for index in 0 ... tempHistrityArr.count - 1 {
                if keyword == tempHistrityArr[index] {
                    keywordExisted = true
                }
            }
            if !keywordExisted {
                if !keyword.isEmptyStr() {
                    recentSearchKeywordArray.insert(keyword, at: 0)
                    setValueForKey(value: recentSearchKeywordArray as AnyObject, key: Constants.historyWord + (stringForKey(key: Constants.userid) ?? ""))
                }
            }
        }else{
            if !keyword.isEmptyStr() {
                recentSearchKeywordArray.insert(keyword, at: 0)
                setValueForKey(value: recentSearchKeywordArray as AnyObject, key: Constants.historyWord + (stringForKey(key: Constants.userid) ?? ""))
            }
        }
        
        let controller = ChannelViewController()
        controller.menupagetype = MenuPageType.Search
        controller.searchWordKey = searchText
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
   
}
extension HomeSearchController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var text = ""
        
        if recentSearchKeywordArray.count == 0{
              text = self.hotWordList[indexPath.row]
        }else{
            if indexPath.section == 0{
                text = self.recentSearchKeywordArray[indexPath.row]
            }else{
                text = self.hotWordList[indexPath.row]
            }
        }
        
 
        let size = CGSize.init(width: self.calculateItemWidth(text: text), height: ZCollectionViewCellHeight)
        return size
    }
    
    //itme间的上下距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ZCollectionViewCellsHorizonMargin
    }
    //itme间的左右距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return ZCollectionViewCellsHorizonMargin
    }
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, referenceSizeForHeaderInSection section:Int) -> CGSize {
        return CGSize.init(width: screenWidth - 50, height: 35)
    }
    //整个itme区域上下左右的编剧
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: ZCollectionViewToTopMargin, left: ZCollectionViewToLeftMargin, bottom: ZCollectionViewToBottomtMargin, right: ZCollectionViewToRightMargin)
    }
    
}

extension HomeSearchController:UICollectionViewDataSource,UICollectionViewDelegate {
    
    func itemClick(sender:UIButton){
        
    }
    
    func numberOfSections(in collectionView:UICollectionView) ->Int{
        
        if recentSearchKeywordArray.count == 0{
            return 1
        }
        return 2
    }
    
    func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int {
        
        if recentSearchKeywordArray.count == 0{
                return self.hotWordList.count
        }else{
            if section == 0{
                return recentSearchKeywordArray.count
                    
            }else{
                return self.hotWordList.count
            }
        }
 
    }
    
    func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionDropCell.nameOfClass, for: indexPath) as! CollectionDropCell
        cell.textLab.frame = CGRect.init(x: 0, y: 0, width: cell.frame.size.width, height:  cell.frame.size.height)
       
        if recentSearchKeywordArray.count == 0{
            let model = self.hotWordList[indexPath.row]
            cell.text = model
        }else{
            if indexPath.section == 0{
                let text = self.recentSearchKeywordArray[indexPath.row] //swift是深拷贝
                cell.text = text;
                      
            }else{
                let model = self.hotWordList[indexPath.row]
                cell.text = model
            }
        }
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var keyword = ""
        
        if recentSearchKeywordArray.count == 0{
               let model = self.hotWordList[indexPath.row]
                keyword = model
        }else{
            if indexPath.section == 0{
                let text = self.recentSearchKeywordArray[indexPath.row] //swift是深拷贝
                keyword = text;
 
                
            }else{
               let model = self.hotWordList[indexPath.row]
               keyword = model
                
                if let tempHistrityArr:[String] = objectForKey(key: Constants.historyWord + (stringForKey(key: Constants.userid) ?? "")) as? [String]{
                    var keywordExisted = false
                    for index in 0 ... tempHistrityArr.count - 1 {
                        if keyword == tempHistrityArr[index] {
                            keywordExisted = true
                        }
                    }
                    if !keywordExisted {
                        if !keyword.isEmptyStr() {
                            recentSearchKeywordArray.insert(keyword, at: 0)
                            setValueForKey(value: recentSearchKeywordArray as AnyObject, key: Constants.historyWord + (stringForKey(key: Constants.userid) ?? ""))
                        }
                    }
                }else{
                    if !keyword.isEmptyStr() {
                        recentSearchKeywordArray.insert(keyword, at: 0)
                        setValueForKey(value: recentSearchKeywordArray as AnyObject, key: Constants.historyWord + (stringForKey(key: Constants.userid) ?? ""))
                    }
                }
            }
        }
        

        
        let controller = ChannelViewController()
        controller.menupagetype = MenuPageType.Search
        controller.searchWordKey = keyword
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
 
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        
        if kind == UICollectionView.elementKindSectionHeader {
            let filerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:CollectionDropSectionVIew.nameOfClass, for: indexPath) as! CollectionDropSectionVIew
            filerView.indexPath = indexPath
            
            if recentSearchKeywordArray.count == 0{
                filerView.titleButton.setTitle("热门搜索", for: .normal)
            }else{
                if indexPath.section == 0{
                    filerView.titleButton.setTitle("历史搜索", for: .normal)
                }else{
                    filerView.titleButton.setTitle("热门搜索", for: .normal)
                }
            }
             return filerView
        }else{
            return UICollectionReusableView()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBarView?.searchTextField?.resignFirstResponder()
    }
    
}
