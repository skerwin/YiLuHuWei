//
//  ReadCommentTitleView.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/28.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class ReadCommentTitleView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak var dotview: UIView!
    @IBOutlet weak var titleLable: UILabel!
    
    override func awakeFromNib(){
    
 
        dotview.layer.cornerRadius = 5;
        dotview.layer.masksToBounds = true;
        dotview.backgroundColor = ZYJColor.main
            
      }
}
