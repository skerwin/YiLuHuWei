//
//  HomeSearchView.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/07/24.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

protocol HomeSearchViewDelegate: class {
    
    func searchActoin()
    func notifyClick(onV: UIView)
}


class HomeSearchView: UIView {
 
    var delegate: HomeSearchViewDelegate?
    
    @IBOutlet weak var imageSearch: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var NotifyButton: UIButton!
    
    @IBAction func SearchActoin(_ sender: Any) {
        delegate?.searchActoin()
    }
    
    @IBAction func notifyAction(_ sender: Any) {
        delegate?.notifyClick(onV: NotifyButton)
    }
    override func awakeFromNib(){
         super.awakeFromNib()
         bgView.addcornerRadius(radius: 10)
        // bgView.alpha = 0.4
        bgView.layer.borderWidth = 2
        bgView.layer.borderColor = ZYJColor.main.cgColor
          
    }
      
    /*
     
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
