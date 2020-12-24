//
//  NotifyCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/06.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class NotifyCell: UITableViewCell {
    
    @IBOutlet weak var contentlabel: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var headimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model:NotifyModel? {
        didSet {
            contentlabel.text = model?.title
                //model?.content
 
            headimage.displayheadNotifyImageWithURL(url: model?.admin?.avatar_url)
            titlelabel.text = model?.admin?.name
                //model?.title
            timeLable.text = DateUtils.timeStampToStringDetail("\(String(describing: model!.published_at))")
         }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
