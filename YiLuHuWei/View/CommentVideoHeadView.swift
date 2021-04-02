//
//  CommentHeadView.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/07/31.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

protocol CommentVideoHeadViewDelegate: NSObjectProtocol {
    func goodBtnAction()
}


class CommentVideoHeadView: UIView {

    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var departMentlabel: UILabel!
    @IBOutlet weak var videoTitlelabel: UILabel!
   // @IBOutlet weak var goodlabel: UILabel!
   // @IBOutlet weak var goodBtn: UIButton!
    weak var delegate: CommentVideoHeadViewDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
//    @IBAction func googBtnAction(_ sender: Any) {
//        delegate?.goodBtnAction()
//    }
    
}
