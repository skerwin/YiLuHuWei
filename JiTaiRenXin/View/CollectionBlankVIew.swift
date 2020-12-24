//
//  CollectionBlankVIew.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/27.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class CollectionBlankVIew: UICollectionReusableView {

       var titleButton:UIButton!
       var moreButton:UIButton!
       var indexPath:IndexPath!
    
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           initUI()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           initUI()
           fatalError("init(coder:) has not been implemented")
       }
       
       func initUI(){
           
           self.backgroundColor = UIColor.white
           let lineView = UIView.init(frame: CGRect.init(x: cureOfLineOffX, y: filterHeaderViewHeigt - cureOfLineHight, width: screenWidth - 2 * cureOfLineOffX, height: cureOfLineHight))
           lineView.backgroundColor = ZYJColor.testLine
           self.addSubview(lineView)
           
           self.titleButton = UIButton.init(type: .custom)
           self.titleButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 0)
           self.titleButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
           self.titleButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
           self.titleButton.frame = CGRect.init(x: 12, y: 0, width: titleButtonWidth, height: self.frame.size.height)
           self.titleButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
           self.titleButton.setTitleColor(UIColor.black, for: UIControl.State.selected)
           self.titleButton.setImage(UIImage.init(named: "home_btn_cosmetic"), for: .normal)
           self.titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
           
           self.titleButton.setTitleColor(UIColor.darkGray, for: .normal)
           self.titleButton.setTitleColor(UIColor.darkGray, for: .highlighted)
           
           self.titleButton.titleLabel?.textColor = UIColor.darkText
           self.titleButton.titleLabel?.textAlignment = .left
           self.addSubview(self.titleButton)
     }
     

}
