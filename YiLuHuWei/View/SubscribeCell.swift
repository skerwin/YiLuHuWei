//
//  SubscribeCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/15.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit

class SubscribeCell: UICollectionViewCell {

    
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var deseLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //bgView.layer.borderWidth = 0.5;
        bgView.layer.cornerRadius = 10;
        //bgView.layer.borderColor = ZYJColor.main.cgColor
        
        bgView.layer.shadowColor = ZYJColor.main.cgColor
        bgView.layer.shadowOffset = CGSize(width: 1, height: 2)
        bgView.layer.shadowRadius = 1
        bgView.layer.shadowOpacity = 0.2
        
        leftImage.layer.cornerRadius = 5;
        leftImage.layer.masksToBounds = true
    }

    
    
    var model:SubscribeModel? {
            didSet {
              
                leftImage.displayImageWithURL(url: model!.cover)
 
                deseLabel.text = model?.name
                contentLabel.text = model?.post_content
                             }
     }
}
