//
//  RecommendOtherCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/27.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class RecommendOtherCell: UITableViewCell {
    
    @IBOutlet weak var imageLeft: UIImageView!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var sourcelabel: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var writer: UILabel!
    @IBOutlet weak var readCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        headImage.layer.cornerRadius = 7.5;
        headImage.layer.masksToBounds = true;
        
        imageLeft.layer.cornerRadius = 7;
        imageLeft.layer.masksToBounds = true
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var model:ArticleModel? {
        didSet {
            content.text = model?.title
            imageLeft.displayImageWithURL(url: model?.img_url)
            readCount.text = "\(model?.hits ?? 0)"
            commentCount.text = "\(model?.comments ?? 0)"
            headImage.displayHeadImageWithURL(url: model?.publisher?.avatar_url)
            writer.text = model?.publisher?.name
            sourcelabel.text = model?.source
        }
    }
    
}
