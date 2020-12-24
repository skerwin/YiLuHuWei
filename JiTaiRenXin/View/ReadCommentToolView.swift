//
//  ReadCommentToolView.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/28.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class ReadCommentToolView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var goodeLabel: UILabel!
    
    
    
    override func awakeFromNib(){
         super.awakeFromNib()
        headImage.layer.cornerRadius = 7.5;
        headImage.layer.masksToBounds = true
    }
}
