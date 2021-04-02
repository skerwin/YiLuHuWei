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




protocol CollectionDropSectionVIewDelegate {
    func clearAction()
}


class CollectionDropSectionVIew: UICollectionReusableView {
    
    var titleButton:UIButton!
    var moreButton:UIButton!
    var indexPath:IndexPath!
    var cancleButton:UIButton!
    
    
    var delegate: CollectionDropSectionVIewDelegate!
    
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
        
        
        
        
        self.cancleButton = UIButton.init(type: .custom)
        self.cancleButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 0)
        self.cancleButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.cancleButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        self.cancleButton.frame = CGRect.init(x: screenWidth - 50 - 5, y: 2, width: 50, height: self.frame.size.height)
        self.cancleButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        self.cancleButton.setTitleColor(UIColor.black, for: UIControl.State.selected)
        self.cancleButton.setImage(UIImage.init(named: "wodehuancunqingli"), for: .normal)
        self.cancleButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        self.cancleButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.cancleButton.setTitleColor(UIColor.darkGray, for: .highlighted)
        
        self.cancleButton.titleLabel?.textColor = UIColor.darkText
        self.cancleButton.titleLabel?.textAlignment = .right
        
        self.addSubview(self.cancleButton)
        self.addSubview(self.titleButton)
        cancleButton.addTarget(self, action: #selector(clearAction(_:)), for: .touchUpInside)
        
    }
    
 
    @objc func clearAction(_ btn: UIButton){
        delegate.clearAction()
        
    }
    
    
    
}
