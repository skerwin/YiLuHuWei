//
//  NotifyDetailController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/08/26.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import WebKit

class NotifyDetailController: BaseViewController {

 
    var model = NotifyModel()

    
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headimage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息详情"

        headimage.layer.cornerRadius = 30;
        headimage.layer.masksToBounds = true
        
        headimage.displayheadNotifyImageWithURL(url: "")
        titleLabel.text = model?.title
        timeLabel.text = DateUtils.timeStampToStringDetail("\(String(describing: model!.publish_time))")
        contentView.text = model?.content
        // Do any additional setup after loading the view.
    }
    
    
}
