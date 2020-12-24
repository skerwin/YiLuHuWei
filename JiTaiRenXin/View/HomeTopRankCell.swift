//
//  HomeTopRankCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/24.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class HomeTopRankCell: UITableViewCell {

    let radio:CGFloat = 3/5
    @IBOutlet weak var RankCollectIonView: UICollectionView!
    
    var parentNavigationController: UINavigationController?
 
    
    var rankArticleModelList:[ArticleModel]!
       
    var rankCaseModelList:[CaseModel]!
       
    var rankvideoModelList:[videoModel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
               //设置collectionView的代理
        self.RankCollectIonView.delegate = self

        self.RankCollectIonView.dataSource = self
        
        self.RankCollectIonView.showsHorizontalScrollIndicator = false

               // 注册CollectionViewCell

        self.RankCollectIonView!.register(UINib(nibName:"ArticleSmallCell", bundle:nil),

                                             forCellWithReuseIdentifier: "ArticleSmallCell")
        self.RankCollectIonView!.register(UINib(nibName:"ChannelSmallCell", bundle:nil),

                                                    forCellWithReuseIdentifier: "ChannelSmallCell")
        self.RankCollectIonView!.register(UINib(nibName:"ReportSmallCell", bundle:nil),

                                                    forCellWithReuseIdentifier: "ReportSmallCell")
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
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleSmallCell.nameOfClass, for: indexPath) as! ArticleSmallCell
          cell.modelList = self.rankArticleModelList
        cell.parentNavigationController = self.parentNavigationController

        return cell
    }else if row == 2{
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelSmallCell.nameOfClass, for: indexPath) as! ChannelSmallCell
         cell.modelList = self.rankvideoModelList
        cell.parentNavigationController = self.parentNavigationController
        return cell
    }else{
         let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportSmallCell.nameOfClass, for: indexPath) as! ReportSmallCell
        cell.modelList = self.rankCaseModelList
        cell.parentNavigationController = self.parentNavigationController
        return cell
    }
   
  }
 
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
  }
}
extension HomeTopRankCell:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize.init(width: screenWidth, height: 290)
        return size
    }
    
    //itme间的上下距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //itme间的左右距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    //整个itme区域上下左右的编剧
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
