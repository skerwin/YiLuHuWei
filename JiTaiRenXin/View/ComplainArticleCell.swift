//
//  ComplainArticleCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/07.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class ComplainArticleCell: UITableViewCell {
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var createLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var complainTypelabel:
    UILabel!
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
                titlelabel.text = model?.article?.title
                headImage.displayHeadImageWithURL(url: model?.article?.publisher?.avatar_url)
                createLabel.text = DateUtils.timeStampToStringDetail("\(String(describing: model!.created_at))")
                    
                complainTypelabel.text = "举报类型: " + "\(model?.categories ?? "")"
                if model?.status == 0{
                    resultLabel.text = "处理结果: 未处理"
                }else if model?.status == 1{
                    resultLabel.text = "处理结果: 已处理"
                }else {
                    resultLabel.text = "举报无效"
                }
                contentLabel.text = model?.reason
              }
     }
    
    
}
