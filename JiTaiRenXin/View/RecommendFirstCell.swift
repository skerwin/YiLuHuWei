//
//  RecommendFirstCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/27.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class RecommendFirstCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var adimage: UIImageView!
    @IBOutlet weak var readCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        adimage.layer.cornerRadius = 16;
        adimage.layer.masksToBounds = true;
        // Initialization code
    }

    @IBOutlet weak var sourcebel: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var writer: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model:ArticleModel? {
             didSet {
                title.text = model?.title
                adimage.displayImageWithURL(url: model?.img_url)
                readCount.text = "\(model?.hits ?? 0)"
                commentCount.text = "\(model?.comments ?? 0)"
                headImage.displayHeadImageWithURL(url: model?.publisher?.avatar_url)
                writer.text = model?.publisher?.name
                sourcebel.text = model?.source
                
        }
    }
}
