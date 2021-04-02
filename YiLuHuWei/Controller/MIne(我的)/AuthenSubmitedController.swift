//
//  AuthenSubmitedController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/08/07.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class AuthenSubmitedController: BaseViewController {

    var isFormMine = false
    
    @IBOutlet weak var backbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // if isFormMine {
            self.title = "审核中"
            self.backbtn.setTitle("返回", for: .normal)
//        }else{
//            self.title = "注册成功"
//            self.backbtn.setTitle("去登录", for: .normal)
//        }
//
        backbtn.layer.cornerRadius = 5
        backbtn.layer.masksToBounds = true;

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: Any) {
//        if isFormMine {
            self.navigationController?.popToRootViewController(animated: true)
//        }else
//        {
//            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.getNewLoginController()
//        }
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
