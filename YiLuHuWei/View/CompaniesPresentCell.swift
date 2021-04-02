//
//  CompaniesPresentCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/21.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit

protocol CompaniesPresentCellDelegate: NSObjectProtocol {
    func careBtnAction(groupid:Int)
}

class CompaniesPresentCell: UITableViewCell {

    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var careBtn: UIButton!
    
    
    weak var delegate: CompaniesPresentCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        careBtn.layer.cornerRadius = 8;
        careBtn.layer.masksToBounds = true;
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
