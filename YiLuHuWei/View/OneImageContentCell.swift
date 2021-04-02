//
//  RecommendOtherCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/07/27.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class OneImageContentCell: UITableViewCell {
    
    @IBOutlet weak var imageLeft: UIImageView!
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var writer: UILabel!
    @IBOutlet weak var readCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        headImage.layer.cornerRadius = 7.5;
        headImage.layer.masksToBounds = true;
        
        imageLeft.layer.cornerRadius = 7;
        imageLeft.layer.masksToBounds = true
        
        
  
        groupLabel.layer.cornerRadius = 10;
        groupLabel.layer.masksToBounds = true
        groupLabel.backgroundColor = colorWithHexString(hex: "#F2FBF6")
        groupLabel.textColor = ZYJColor.main
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var model:AVCModel? {
        didSet {
            content.text = model?.post_title
            imageLeft.displayImageWithURL(url: model?.thumbnail)
            headImage.displayHeadImageWithURL(url: model?.avatar_url)
            writer.text = model?.user_nickname
            groupLabel.text = model?.group_name
            
 
            if model?.format_post_hits == ""{
                readCount.text = "\(model?.post_hits ?? 0)"
            }else{
                readCount.text = model?.format_post_hits
            }
            
            if model?.format_comment_count == ""{
                commentCount.text = "\(model?.comment_count ?? 0)"
            }else{
                commentCount.text = model?.format_comment_count
            }
            
            if model?.format_post_like == ""{
                likeCount.text = "\(model?.post_like ?? 0)"
            }else{
                likeCount.text = model?.format_post_like
            }
        }
    }
    
}
