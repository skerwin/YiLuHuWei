//
//  CollectionDropSectionVIew.swift
//  BossJob
//
//  Created by zhaoyuanjing on 2018/04/13.
//  Copyright © 2018年 zhaoyuanjing. All rights reserved.
//

import UIKit

let titleButtonWidth:CGFloat = 250.0;
let moreButtonWidth:CGFloat  = 36 * 2;
let cureOfLineHight:CGFloat  = 0.5;
let cureOfLineOffX:CGFloat   = 16;
let filterHeaderViewHeigt:CGFloat = 35;
 

class CollectionDropSectionVIew: UICollectionReusableView {
    
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
