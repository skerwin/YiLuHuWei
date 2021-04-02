//
//  HomeTopRankCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/07/24.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class HomeTopRankCell: UITableViewCell {

    let radio:CGFloat = 3/5
    @IBOutlet weak var RankCollectIonView: UICollectionView!
    
    var parentNavigationController: UINavigationController?
 
    
    var rankArticleModelList:[AVCModel]!
       
    var rankCaseModelList:[AVCModel]!
       
    var rankvideoModelList:[AVCModel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
               //设置collectionView的代理
        self.backgroundColor = ZYJColor.tableViewBg
        self.RankCollectIonView.backgroundColor = ZYJColor.tableViewBg
        self.RankCollectIonView.delegate = self

        self.RankCollectIonView.dataSource = self
        
        self.RankCollectIonView.showsHorizontalScrollIndicator = false

        // 注册CollectionViewCell

        self.RankCollectIonView!.register(UINib(nibName:"RankSmallCell", bundle:nil),

                                             forCellWithReuseIdentifier: "RankSmallCell")
        
        
        self.RankCollectIonView!.register(UINib(nibName:"RankSmallCell1", bundle:nil),

                                             forCellWithReuseIdentifier: "RankSmallCell1")
        
        
        self.RankCollectIonView!.register(UINib(nibName:"RankSmallCell2", bundle:nil),

                                             forCellWithReuseIdentifier: "RankSmallCell2")
      }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension HomeTopRankCell:UICollectionViewDataSource,UICollectionViewDelegate {
  

  
  func numberOfSections(in collectionView:UICollectionView) ->Int{
      //return self.dataSources.count
      return 1
  }
  
  func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int {
      return 3
      
  }
  
  func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
      
    let row = indexPath.row
   
    if row == 0{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankSmallCell.nameOfClass, for: indexPath) as! RankSmallCell
        cell.type = 1
        cell.modelList = self.rankArticleModelList
        cell.imageTitle.image = UIImage.init(named: "wenzhangpaihang")
        cell.parentNavigationController = self.parentNavigationController

        return cell
    }else if row == 1{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankSmallCell1.nameOfClass, for: indexPath) as! RankSmallCell1
        cell.type = 2
        cell.imageTitle.image = UIImage.init(named: "binglipaihang")
        cell.modelList = self.rankCaseModelList
        cell.parentNavigationController = self.parentNavigationController

        return cell
    }else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankSmallCell2.nameOfClass, for: indexPath) as! RankSmallCell2
        cell.type = 3
        cell.imageTitle.image = UIImage.init(named: "shipinpaihang")
        cell.modelList = self.rankvideoModelList
        cell.parentNavigationController = self.parentNavigationController

        return cell
    }
    

  
 
  }
 
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
  }
}
extension HomeTopRankCell:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize.init(width: screenWidth - 20, height: 200)
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
    
    //整个itme区域上下左右的编剧
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
