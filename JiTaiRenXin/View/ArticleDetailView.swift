//
//  ArticleDetailView.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/12/31.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import Foundation


protocol ArticleDetailViewDelegate: NSObjectProtocol {
    func sourceAction()
}

class ArticleDetailView: UIView {

 
    //@IBOutlet weak var DetailView: UITextView!
    
    
    var parentNavigationController: UINavigationController?
    weak var delegate: ArticleDetailViewDelegate?
    @IBOutlet weak var DetailwebView: UIWebView!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lileLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var comentLabel: UILabel!
    @IBOutlet weak var sourceBtn: UIButton!
    
    var urlString = ""
    
    @IBAction func sourceAction(_ sender: Any) {
       // delegate?.sourceAction()
        print("123")
        let controller = NewNotifyDetailController()
        controller.urlString = urlString
        self.parentNavigationController?.pushViewController(controller, animated: true)
    }
    
    @IBOutlet weak var createlabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
 
}
