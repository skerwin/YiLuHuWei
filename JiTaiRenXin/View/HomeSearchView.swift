//
//  HomeSearchView.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/24.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

protocol HomeSearchViewDelegate: class {
    
    func searchActoin()
}


class HomeSearchView: UIView {
 
    var delegate: HomeSearchViewDelegate?
    
    @IBOutlet weak var imageSearch: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBAction func SearchActoin(_ sender: Any) {
        delegate?.searchActoin()
    }
    
    override func awakeFromNib(){
         super.awakeFromNib()
         bgView.addcornerRadius(radius: 15)
         bgView.alpha = 0.4
          
    }
      
    /*
     
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
