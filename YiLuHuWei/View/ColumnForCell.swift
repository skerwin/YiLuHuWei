//
//  ColumnForCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/25.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit

protocol ColumnForCellDelegate: NSObjectProtocol {
    func careBtnAction(groupid:Int)
}

class ColumnForCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var careBtn: UIButton!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    
    weak var delegate: ColumnForCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 10;
 
        bgView.layer.shadowColor = ZYJColor.main.cgColor
        bgView.layer.shadowOffset = CGSize(width: 1, height: 2)
        bgView.layer.shadowRadius = 1
        bgView.layer.shadowOpacity = 0.2
        
        careBtn.layer.cornerRadius = 10;
        careBtn.layer.masksToBounds = true;
        
        leftImage.layer.cornerRadius = 3;
        leftImage.layer.masksToBounds = true;
        // Initialization code
    }

    @IBAction func careBtnAction(_ sender: Any) {
        delegate?.careBtnAction(groupid: model!.id)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    var model:SubscribeModel? {
        didSet {
            contentLabel.text = model?.post_content
            namelabel.text = model?.name
            leftImage.displayHeadImageWithURL(url: model?.cover)
            
            if model?.is_collect == 0{
                careBtn.backgroundColor = ZYJColor.main
                careBtn.setTitle("订阅", for: .normal)
             }else{
                careBtn.setTitle("已订阅", for: .normal)
                
                careBtn.backgroundColor = UIColor.lightGray
            }
           
        }
    }
}
