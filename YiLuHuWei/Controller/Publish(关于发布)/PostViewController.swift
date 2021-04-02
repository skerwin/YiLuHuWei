//
//  PostViewController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/29.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit

class PostViewController: BaseViewController {

    @IBOutlet weak var publishCases: UIButton!
    @IBOutlet weak var pubLishArticle: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布"
        
        publishCases!.layer.cornerRadius = 12
        publishCases!.layer.masksToBounds = true
        pubLishArticle!.layer.cornerRadius = 12
        pubLishArticle!.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
