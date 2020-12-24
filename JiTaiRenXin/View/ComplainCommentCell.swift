//
//  ComplainCommentCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/07.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class ComplainCommentCell: UITableViewCell {

    @IBOutlet weak var arcTitleLabel: UILabel!
    @IBOutlet weak var createTIme: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    var model:ComplainModel? {
            didSet {
                arcTitleLabel.text = model?.article?.title
                headImage.displayHeadImageWithURL(url: model?.publisher?.avatar_url)
                createTIme.text = DateUtils.timeStampToStringDetail("\(String(describing: model!.created_at))")
                typeLabel.text = "举报类型: " + "\(model?.categories ?? "")"
                if model?.status == 0{
                    resultLabel.text = "处理结果: 未处理"
                }else if model?.status == 1{
                    resultLabel.text = "处理结果: 已处理"
                }else {
                    resultLabel.text = "举报无效"
                }
                commentLabel.text = model?.publisher?.title
            }
     }
}
