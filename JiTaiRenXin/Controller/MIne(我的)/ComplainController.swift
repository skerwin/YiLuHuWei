//
//  ColumForDetailController.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/06.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit


//废弃
class ComplainController: BaseViewController ,Requestable {

 
    var controllerArray : [UIViewController] = []
    var controller1:ComplainArticleController!
    var controller2:ComplainCommentController!
    var pageMenuController: PMKPageMenuController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的举报"
        
        controller1 = ComplainArticleController()
        controller1.title = "举报的文章"
 
        controller2 = ComplainCommentController()
        controller2.title = "举报的评论"
 
        
        initpageMenu()
         // Do any additional setup after loading the view.
    }
    
    
     func initpageMenu(){
          
        controllerArray.append(controller1)
        controllerArray.append(controller2)
 
           
        pageMenuController = PMKPageMenuController(controllers: controllerArray, menuStyle: .plain, menuColors:[ZYJColor.main], startIndex: 1, topBarHeight: 0)
        pageMenuController?.delegate = self
        self.addChild(pageMenuController!)
        self.view.addSubview(pageMenuController!.view)
        pageMenuController?.didMove(toParent: self)
           
       }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
      
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
    }
      
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
    }
 

}
extension ComplainController: PMKPageMenuControllerDelegate
{
  func pageMenuController(_ pageMenuController: PMKPageMenuController, willMoveTo viewController: UIViewController, at menuIndex: Int) {
  }

  func pageMenuController(_ pageMenuController: PMKPageMenuController, didMoveTo viewController: UIViewController, at menuIndex: Int) {
  }

  func pageMenuController(_ pageMenuController: PMKPageMenuController, didPrepare menuItems: [PMKPageMenuItem]) {
    // XXX: For .hacka style
    var i: Int = 1
    for item: PMKPageMenuItem in menuItems {
      item.badgeValue = String(format: "%zd", i)
      i += 1
    }
  }

  func pageMenuController(_ pageMenuController: PMKPageMenuController, didSelect menuItem: PMKPageMenuItem, at menuIndex: Int) {
    menuItem.badgeValue = nil // XXX: For .hacka style
  }
}

