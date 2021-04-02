//
//  shieldViewCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/02/08.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit

protocol shieldViewCelllDelegate: NSObjectProtocol {
    func recallAction(model:ShieldModel)
}


class shieldViewCell: UITableViewCell {

    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var recallBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    weak var delegate: shieldViewCelllDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recallBtn.layer.cornerRadius = 5
        recallBtn.layer.masksToBounds = true
        headImage.layer.cornerRadius = 16
        headImage.layer.masksToBounds = true
        // Initialization code
    }

    @IBAction func recallAction(_ sender: Any) {
        delegate?.recallAction(model: model!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model:ShieldModel? {
        didSet {
            nameLabel.text = model?.comments?.users?.user_nickname
            contentLabel.text = model?.comments?.content
            headImage.displayHeadImageWithURL(url: model?.comments?.users?.avatar_url)
            timeLabel.text = DateUtils.timeStampToStringDetail("\(String(describing: model!.create_time))")
        }
    }

    
}
