//
//  SchoolVideoCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/20.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit

class SchoolVideoCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var hitCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentlabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftImage.layer.cornerRadius = 3;
        leftImage.layer.masksToBounds = true;
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model:AVCModel? {
        didSet {
            
         
            contentlabel.text = model?.title
      
            timeLabel.text = model?.video_time
         
            leftImage.displayImageWithURL(url: model?.thumbnail)
 
                
            if model?.format_post_hits == ""{
                hitCountLabel.text = "\(model?.post_hits ?? 0)"
            }else{
                hitCountLabel.text = model?.format_post_hits
            }
            
            if model?.format_comment_count == ""{
                commentLabel.text = "\(model?.comment_count ?? 0)"
            }else{
                commentLabel.text = model?.format_comment_count
            }
            
            if model?.format_post_like == ""{
                likeLabel.text = "\(model?.post_like ?? 0)"
            }else{
                likeLabel.text = model?.format_post_like
            }
         }
    }
    
}
