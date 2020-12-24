//
//  ImageOnlyCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/28.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class ImageOnlyCell: UITableViewCell {
    
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var iamge1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var goodLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dotVIew.layer.cornerRadius = 5;
        dotVIew.layer.masksToBounds = true;
        dotVIew.backgroundColor = ZYJColor.main
        
        headImage.layer.cornerRadius = 7.5;
        headImage.layer.masksToBounds = true
        // Initialization code
    }

    
    var model:ArticleModel? {
            didSet {
                titlelabel.text = model?.title
                iamge1.displayImageWithURL(url: model?.image_list.first?.url)
                image2.displayImageWithURL(url: model?.image_list[1].url)
                image3.displayImageWithURL(url: model?.image_list[2].url)
                readCountLabel.text = "\(model?.hits ?? 0)"
                commentLabel.text = "\(model?.comments ?? 0)"
                goodLabel.text = "\(model?.likes ?? 0)"
                headImage.displayHeadImageWithURL(url: model?.publisher?.avatar_url)
                writerLabel.text = model?.publisher?.name
             }
     }
    
    var modelCase:CaseModel? {
            didSet {
                titlelabel.text = modelCase?.title
                iamge1.displayImageWithURL(url: modelCase?.image_list.first?.url)
                image2.displayImageWithURL(url: modelCase?.image_list[1].url)
                image3.displayImageWithURL(url: modelCase?.image_list[2].url)
                readCountLabel.text = "\(modelCase?.hits ?? 0)"
                commentLabel.text = "\(modelCase?.comments ?? 0)"
                goodLabel.text = "\(modelCase?.likes ?? 0)"
                headImage.displayHeadImageWithURL(url: modelCase?.publisher?.avatar_url)
                writerLabel.text = modelCase?.publisher?.name
             }
     }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var dotVIew: UIView!
}
