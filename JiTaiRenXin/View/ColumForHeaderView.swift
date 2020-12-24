//
//  ColumForHeaderView.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/06.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
protocol ColumForHeaderViewDelegate: NSObjectProtocol {
    func careBtnAction()
}
class ColumForHeaderView: UIView {

    weak var delegate: ColumForHeaderViewDelegate?
    var model = ColumnForModel()
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var careBtn: UIButton!
    
 
    @IBOutlet weak var descTeceView: UITextView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func careAction(_ sender: Any) {
         delegate?.careBtnAction()
    }
    

    
    func configModel(){
        headImage.displayHeadImageWithURL(url: model?.img_url)
        titleLabel.text = model?.name
        descTeceView.text = model?.desc
    }
    
    override func awakeFromNib(){
        bgView.backgroundColor = ZYJColor.main
        //descTeceView.backgroundColor = UIColor.yellow
        careBtn.layer.cornerRadius = 5;
        careBtn.layer.masksToBounds = true;
        careBtn.titleLabel?.textColor = ZYJColor.main
        addGestureRecognizerToView(view: titleLabel, target: self, actionName: "headImageAction")
        descTeceView.isEditable = false
    }
    
    
    @objc func headImageAction(){
      
    }
}
