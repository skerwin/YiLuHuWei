//
//  CodeShareController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/02/08.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit

class CodeShareController: BaseViewController {

    @IBOutlet weak var shareCodeBtn: UIButton!
    @IBAction func shareCodeAction(_ sender: Any) {
        self.shareView.show(withContentType: JSHAREMediaType(rawValue: 3)!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        shareCodeBtn.layer.cornerRadius = 22
        shareCodeBtn.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    
    lazy var shareView: ShareView = {
        
        let sv = ShareView.getFactoryShareView { (platform, type) in
            self.shareInfoWithPlatform(platform: platform)
            
        }
        self.view.addSubview(sv!)
        return sv!
 
    }()

    func shareInfoWithPlatform(platform:JSHAREPlatform){
        let message = JSHAREMessage.init()
       // let dateString = DateUtils.dateToDateString(Date.init(), dateFormat: "yyy-MM-dd HH:mm:ss")
        message.title = "医路护卫是一款专业打造的医疗知识学习软件，这里有着详细全面的医疗知识内容可以供用户学习"
        message.text = "https://apps.apple.com/cn/app/医路护卫/id1484444122"
 
        message.platform = platform
        message.mediaType = .link;
        message.url = "https://apps.apple.com/cn/app/%E5%8C%BB%E8%B7%AF%E6%8A%A4%E5%8D%AB/id1484444122"
        let imageLogo = UIImage.init(named: "logo")
       
        message.image = imageLogo?.pngData()
        var tipString = ""
        JSHAREService.share(message) { (state, error) in
            if state == JSHAREState.success{
                tipString = "分享成功";
            }else if state == JSHAREState.fail{
                tipString = "分享失败";
            }else if state == JSHAREState.cancel{
                tipString = "分享取消";
            } else if state == JSHAREState.unknown{
                tipString = "Unknown";
            }else{
                tipString = "Unknown";
            }
             DispatchQueue.main.async(execute: {
                
                let tipView = UIAlertController.init(title: "", message: tipString, preferredStyle: .alert)
                tipView.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
     
                }))
                self.present(tipView, animated: true, completion: nil)

            })
        }
 
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
