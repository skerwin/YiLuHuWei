//
//  VideoListCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/03.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class VideoListCell: UITableViewCell {
    
    var readCommentToolView:ReadCommentToolView!
    
    
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var imageLeft: UIImageView!
    
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var sourcelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        dotView.layer.cornerRadius = 5;
        dotView.layer.masksToBounds = true;
        dotView.backgroundColor = ZYJColor.main
        
        readCommentToolView = Bundle.main.loadNibNamed("ReadCommentToolView", owner: nil, options: nil)!.first as? ReadCommentToolView
        readCommentToolView?.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 35)
        
        
        self.contentView.backgroundColor = UIColor.red
        //   self.contentView.addSubview(readCommentToolView!)
        
        
        imageLeft.layer.cornerRadius = 3
        imageLeft.layer.masksToBounds = true
        
        bannerImage.layer.cornerRadius = 3
        bannerImage.layer.masksToBounds = true
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 215, width: screenWidth, height: 35))
        view.addSubview(readCommentToolView)
        self.contentView.addSubview(view)
        
        // Initialization code
    }
    
    
    var model:videoModel? {
        didSet {
            titleLable.text = model?.title
            bannerImage.displayImageWithEncodedURL(url: model?.img_url)
            readCommentToolView.headImage.displayHeadImageWithURL(url: model?.publisher?.avatar_url)
            readCommentToolView.writerLabel.text = model?.publisher?.name
            readCommentToolView.readCountLabel.text = "\(model?.hits ?? 0)"
            readCommentToolView.commentCountLabel.text = "\(model?.comments ?? 0)"
            readCommentToolView.goodeLabel.text = "\(model?.likes ?? 0)"
            sourcelabel.text = model?.source
            
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
