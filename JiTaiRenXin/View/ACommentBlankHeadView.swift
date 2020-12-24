//
//  ACommentBlankHeadView.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/13.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

protocol ACommentBlankHeadViewDelegate: NSObjectProtocol {
    func goodLBtnAction()
}

class ACommentBlankHeadView: UIView {

    
     weak var delegate: ACommentBlankHeadViewDelegate?
    @IBOutlet weak var goodbtn: UIButton!
    @IBOutlet weak var goodLabel: UILabel!
    @IBAction func goodBtnAction(_ sender: Any) {
         delegate?.goodLBtnAction()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
