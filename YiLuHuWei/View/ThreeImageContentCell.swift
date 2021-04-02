//
//  ImageOnlyCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/07/28.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class ThreeImageContentCell: UITableViewCell {
    
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var iamge1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var goodLabel: UILabel!
    
    @IBOutlet weak var groupLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headImage.layer.cornerRadius = 7.5;
        headImage.layer.masksToBounds = true
        
        iamge1.layer.cornerRadius = 5;
        iamge1.layer.masksToBounds = true
        
        image2.layer.cornerRadius = 5;
        image2.layer.masksToBounds = true
        
        image3.layer.cornerRadius = 5;
        image3.layer.masksToBounds = true
        
 
        groupLabel.layer.cornerRadius = 10;
        groupLabel.layer.masksToBounds = true
        groupLabel.backgroundColor = colorWithHexString(hex: "#F2FBF6")
        groupLabel.textColor = ZYJColor.main
        
        
        
        // Initialization code
    }

    
    var model:AVCModel? {
            didSet {
                titlelabel.text = model?.post_title
                iamge1.displayImageWithURL(url: model?.more?.photos[0].url)
                image2.displayImageWithURL(url: model?.more?.photos[1].url)
                image3.displayImageWithURL(url: model?.more?.photos[2].url)
                
                
                if model?.format_post_hits == ""{
                    readCountLabel.text = "\(model?.post_hits ?? 0)"
                }else{
                    readCountLabel.text = model?.format_post_hits
                }
                
                if model?.format_comment_count == ""{
                    commentLabel.text = "\(model?.comment_count ?? 0)"
                }else{
                    commentLabel.text = model?.format_comment_count
                }
                
                if model?.format_post_like == ""{
                    goodLabel.text = "\(model?.post_like ?? 0)"
                }else{
                    goodLabel.text = model?.format_post_like
                }
                
                
                headImage.displayHeadImageWithURL(url: model?.avatar_url)
                writerLabel.text = model?.user_nickname
                groupLabel.text = model?.group_name
             }
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var dotVIew: UIView!
}
