//
//  OnlyContentCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/25.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit

class OnlyContentCell: UITableViewCell {

    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var groupLabel: UILabel!
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var writer: UILabel!
    @IBOutlet weak var readCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        groupLabel.layer.cornerRadius = 10;
        groupLabel.layer.masksToBounds = true
        groupLabel.backgroundColor = colorWithHexString(hex: "#F2FBF6")
        groupLabel.textColor = ZYJColor.main
        
        
        headImage.layer.cornerRadius = 7.5;
        headImage.layer.masksToBounds = true;
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model:AVCModel? {
        didSet {
            
            if model?.post_excerpt == "" {
                
                contentLabel.text = model?.content.removeHeadAndTailSpacePro.html2String
            }else {
                contentLabel.text = model?.post_excerpt.html2String
            }
            
            if model?.post_title == "" {
                titlelabel.text = model?.title
            }else {
                titlelabel.text = model?.post_title
            }
           
           
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
            
          
           
            headImage.displayHeadImageWithURL(url: model?.avatar_url)
            writer.text = model?.user_nickname
            
                
            groupLabel.text = model?.group_name
        }
    }
    
}
