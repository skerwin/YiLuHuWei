//
//  GuideInletCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/08.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit

class GuideInletCell: UITableViewCell {

    var GuideInletlList = [SubscribeModel]()
    var collectionView:UICollectionView!  //collectView
    var parentNavigationController: UINavigationController?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        //initCollectView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
    func initCollectView(){
        let collectionViewFrame = CGRect.init(x: 0, y:4, width: screenWidth - 20, height: 144)
         let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView.init(frame: collectionViewFrame, collectionViewLayout: layout)
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.collectionView?.backgroundColor = UIColor.white
        //self.collectionView?.allowsMultipleSelection = true
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0 )
        self.collectionView!.register(UINib(nibName:"GuideCell", bundle:nil),
                                                   forCellWithReuseIdentifier: "GuideCell")
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.layer.cornerRadius = 20;
        self.collectionView?.layer.masksToBounds = true
        self.addSubview(self.collectionView)
    }
   
    
}
extension GuideInletCell:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize.init(width: (screenWidth - 20)/4, height: 375/4 - 28)
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
        return UIEdgeInsets.init(top: 5, left: 0, bottom: 5, right: 0)
    }
}
extension GuideInletCell:UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    
    func numberOfSections(in collectionView:UICollectionView) ->Int{
        //return self.dataSources.count
        return 1
    }
    
    func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int {
        return GuideInletlList.count
         
    }
    
    func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuideCell.nameOfClass, for: indexPath) as! GuideCell
        cell.model = GuideInletlList[indexPath.row]
        return cell
        
     }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let row = indexPath.row
        print(indexPath.section)
        print(indexPath.row)
        
        if row == 0{
            let controller = NewArticleController()
            controller.isNew = true
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }else if row == 1{
            let controller = NewArticleController()
            controller.isNew = false
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }else if row == 2{
            let controller = CaseViewController()
             self.parentNavigationController?.pushViewController(controller, animated: true)
            
        }else if row == 3{
            
            if (stringForKey(key: Constants.token) != nil && stringForKey(key: Constants.token) != ""){
                
                let controller = UIStoryboard.getNoteViewController()
                self.parentNavigationController?.pushViewController(controller, animated: true)
        
            }else{
                let controller = UIStoryboard.getNewLoginController()
                 controller.modalPresentationStyle = .fullScreen
                 controller.reloadLogin = {[weak self] () -> Void in
                 }
                 self.parentNavigationController?.present(controller, animated: true, completion: nil)
            }
            
       
      
        }else if row == 4{
 
            let controller = SickViewController()
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }else if row == 5{
            
            let controller = CompaniesFrontiersController()
            controller.isCompany = false
            self.parentNavigationController?.pushViewController(controller, animated: true)
 
        }else if row == 6{
            let controller = ClumnForController()
            self.parentNavigationController?.pushViewController(controller, animated: true)
 
        }else if row == 7{
            let controller = CompaniesFrontiersController()
            controller.isCompany = true
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }
      
        
    }

}
