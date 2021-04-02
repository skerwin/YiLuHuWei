//
//  GuideCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/14.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit

class GuideCell: UICollectionViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model:SubscribeModel? {
            didSet {
              
                imageIcon.image = UIImage.init(named: model!.cover)
                
                nameLabel.text = model?.name
                
             }
     }

}
