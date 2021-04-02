//
//  SchoolHeadView.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/19.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit


protocol SchoolHeadViewDelegate: NSObjectProtocol {
    func searchAction()
}

class SchoolHeadView: UIView {

    var delegeta:SchoolHeadViewDelegate?
    
    
    @IBAction func blackBtnACtion(_ sender: Any) {
     }
    
    @IBOutlet weak var textBtn: UIButton!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var textBgview: UIView!
    
    
    
    @IBAction func textBtnAction(_ sender: Any) {
     }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
