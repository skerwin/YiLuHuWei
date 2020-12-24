//
//  ColumnForCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/28.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class ColumnForCell: UICollectionViewCell {
    @IBOutlet weak var bgview: UIView!
    
    @IBOutlet weak var columiamge: UIImageView!
    @IBOutlet weak var iscollect: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var columnView: UIImageView!
    
    var model:ColumnForModel? {
            didSet {
                
                if model?.is_collect == 0{
                   iscollect.image = UIImage.init(named: "")
                }else{
                    iscollect.image = UIImage.init(named: "isCollect")
                }
                columiamge.displayImageWithURL(url: model?.img_url)
                
                name.text = model?.name
                
             }
     }
}
