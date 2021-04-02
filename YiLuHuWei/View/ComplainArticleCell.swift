//
//  ComplainArticleCell.swift
//  YiLuHuWei
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
    
    var ComplainType = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        headImage.layer.cornerRadius = 11
        headImage.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model:PerAVCModel? {
            didSet {
                
                if model?.comments?.id == 0{
                    headImage.displayHeadImageWithURL(url: model?.articles?.users?.avatar_url)
                    if ComplainType == 1{
                        titlelabel.text = model?.articles?.users?.user_nickname
                    }else if ComplainType == 3{
                        titlelabel.text = model?.videos?.users?.user_nickname
                    }else{
                        titlelabel.text = model?.cases?.users?.user_nickname
                    }
                    
                }else{
                    headImage.displayHeadImageWithURL(url: model?.comments?.users?.avatar_url)
                    titlelabel.text = model?.comments?.users?.user_nickname
                }
               
                contentLabel.text = model?.title
                createLabel.text = DateUtils.timeStampToStringDetail("\(String(describing: model!.report_time))")
                    
                complainTypelabel.text = "举报类型: " + "\(model?.categories_name ?? "")"
                if model?.status == 0{
                    resultLabel.text = "处理结果: 未处理"
                }else if model?.status == 1{
                    resultLabel.text = "处理结果: 已处理"
                }else {
                    resultLabel.text = "举报无效"
                }
                
              }
     }
    
    
}
