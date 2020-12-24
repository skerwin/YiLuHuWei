//
//  CommentBlankHeadView.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/13.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

protocol CommentBlankHeadViewDelegate: NSObjectProtocol {
    func goodBtnAction()
}

class CommentBlankHeadView: UIView {

    
     weak var delegate: CommentBlankHeadViewDelegate?
    @IBOutlet weak var goodBtn: UIButton!
    @IBAction func goodBtnACtion(_ sender: Any) {
        delegate?.goodBtnAction()
    }
    @IBOutlet weak var goodCountlabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
