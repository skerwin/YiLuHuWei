//
//  ImageAndContentCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/28.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class ImageAndContentCell: UITableViewCell {
    
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var contentLable: UILabel!
    @IBOutlet weak var readcountLable: UILabel!
    @IBOutlet weak var commentCountLable: UILabel!

    @IBOutlet weak var headImage: UIImageView!
    
    
    @IBOutlet weak var writerLabel: UILabel!
    
    @IBOutlet weak var goodLabel: UILabel!
    @IBOutlet weak var imageLeft: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
 
        headImage.layer.cornerRadius = 7.5;
        headImage.layer.masksToBounds = true
        
        
        imageLeft.layer.cornerRadius = 5;
        imageLeft.layer.masksToBounds = true
 
        dotView.layer.cornerRadius = 5;
        dotView.layer.masksToBounds = true;
        dotView.backgroundColor = ZYJColor.main
         // Initialization code
    }

   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    var model:ArticleModel? {
            didSet {
                titleLable.text = model?.title
                contentLable.text = model?.desc
                imageLeft.displayImageWithURL(url: model?.img_url)
                readcountLable.text = "\(model?.hits ?? 0)"
                commentCountLable.text = "\(model?.comments ?? 0)"
                goodLabel.text = "\(model?.likes ?? 0)"
                headImage.displayHeadImageWithURL(url: model?.publisher?.avatar_url)
                writerLabel.text = model?.publisher?.name
                   
                    
            }
     }
    var modelCase:CaseModel? {
            didSet {
                titleLable.text = modelCase?.title
                contentLable.text = modelCase?.desc
                imageLeft.displayImageWithURL(url: modelCase?.img_url)
                readcountLable.text = "\(modelCase?.hits ?? 0)"
                commentCountLable.text = "\(modelCase?.comments ?? 0)"
                goodLabel.text = "\(modelCase?.likes ?? 0)"
                headImage.displayHeadImageWithURL(url: modelCase?.publisher?.avatar_url)
                writerLabel.text = modelCase?.publisher?.name
                    
            }
     }
}
