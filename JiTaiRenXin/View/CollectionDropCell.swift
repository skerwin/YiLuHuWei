//
//  CollectionDropCell.swift
//  BossJob
//
//  Created by zhaoyuanjing on 2018/04/13.
//  Copyright © 2018年 zhaoyuanjing. All rights reserved.
//

import UIKit


class CustomButton: UIButton {
    var section:Int?
    var row:Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CollectionDropCell: UICollectionViewCell {
    
    var bgBUtton:CustomButton!
    
    var textLab:UILabel!
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
        fatalError("init(coder:) has not been implemented")
    }
    var text:String? {
        didSet {
            changeText()
        }
    }
    func changeText() {
 
           self.textLab.text = text
    }
  
    
    func initUI(){
 
         self.textLab = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        self.textLab.layer.borderWidth = 1
        self.textLab.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.textLab.layer.masksToBounds = true
        self.textLab.textColor = UIColor.darkGray
        self.textLab.textAlignment = .center
        self.textLab.font = UIFont.systemFont(ofSize: 13)
        self.textLab.layer.cornerRadius = 10
        self.contentView.addSubview(self.textLab)
 
        
    }
   
    
}
