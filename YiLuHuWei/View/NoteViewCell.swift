//
//  NoteViewCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/02/01.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit

class NoteViewCell: UITableViewCell {
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var groupLabel: UILabel!
    
    @IBOutlet weak var writer: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    var model:NoteModel? {
        didSet {
            
            
            contentLabel.text = model?.content
            
            titlelabel.text = model?.title
         
           
            writer.text = DateUtils.timeStampToStringDetail("\(String(describing: model!.create_time))")
            
                
            groupLabel.text = model?.group_name
        }
    }
    
}
