////
////  ColumForDetailController.swift
////  JiTaiRenXin
////
////  Created by zhaoyuanjing on 2020/08/06.
////  Copyright © 2020 gansukanglin. All rights reserved.
////
//
//import UIKit
//
//
////废弃
//class ColumForDetailController: BaseViewController ,Requestable {
//
//    var columForHeaderView:ColumForHeaderView!
//
//    var controllerArray : [UIViewController] = []
//    var controller1:ChannelArticleController!
//    var controller2:ChannelReportController!
//    var controller3:ChannelVideoController!
//    var pageMenuController: PMKPageMenuController? = nil
//
//    var cid = 0 //栏目详情页的时候要传一个栏目详情id
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = "栏目详情"
//
//        columForHeaderView = Bundle.main.loadNibNamed("ColumForHeaderView", owner: nil, options: nil)!.first as? ColumForHeaderView
//        columForHeaderView?.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 172)
//
//        let bgview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 172))
//        bgview.addSubview(columForHeaderView)
//        self.view.addSubview(bgview)
//
//
//
//        controller1 = ChannelArticleController()
//        controller1.title = "文章"
//        controller1.menupagetype = MenuPageType.ColumForDetail
//        controller1.parentNavigationController = self.navigationController
//
//
//        controller2 = ChannelReportController()
//        controller2.title = "病例"
//        controller2.menupagetype = MenuPageType.ColumForDetail
//        controller2.parentNavigationController = self.navigationController
//
//        controller3 = ChannelVideoController()
//        controller3.title = "视频"
//        controller3.menupagetype = MenuPageType.ColumForDetail
//        controller3.parentNavigationController = self.navigationController
//
//        initpageMenu()
//         // Do any additional setup after loading the view.
//    }
//
//
//     func initpageMenu(){
//
//        controllerArray.append(controller1)
//        controllerArray.append(controller2)
//        controllerArray.append(controller3)
//
//
//        pageMenuController = PMKPageMenuController(controllers: controllerArray, menuStyle: .plain, menuColors:[ZYJColor.main], startIndex: 1, topBarHeight: 172)
//        pageMenuController?.delegate = self
//        self.addChild(pageMenuController!)
//        self.view.addSubview(pageMenuController!.view)
//        pageMenuController?.didMove(toParent: self)
//
//
//       }
//
//    override func viewWillDisappear(_ animated: Bool) {
//          super.viewWillDisappear(animated)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor.white), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: UIColor.white)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black] //设置导航栏标题颜色
//        self.navigationController?.navigationBar.tintColor = UIColor.black   //设置导航栏按钮颜色
//        //UIApplication.shared.statusBarStyle = .lightContent
//     }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: ZYJColor.main), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: ZYJColor.main)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white] //设置导航栏标题颜色
//        self.navigationController?.navigationBar.tintColor = UIColor.white   //设置导航栏按钮颜色
//       // UIApplication.shared.statusBarStyle = .default
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//           super.viewDidAppear(animated)
//    }
//
//
//}
//extension ColumForDetailController: PMKPageMenuControllerDelegate
//{
//  func pageMenuController(_ pageMenuController: PMKPageMenuController, willMoveTo viewController: UIViewController, at menuIndex: Int) {
//  }
//
//  func pageMenuController(_ pageMenuController: PMKPageMenuController, didMoveTo viewController: UIViewController, at menuIndex: Int) {
//  }
//
//  func pageMenuController(_ pageMenuController: PMKPageMenuController, didPrepare menuItems: [PMKPageMenuItem]) {
//    // XXX: For .hacka style
//    var i: Int = 1
//    for item: PMKPageMenuItem in menuItems {
//      item.badgeValue = String(format: "%zd", i)
//      i += 1
//    }
//  }
//
//  func pageMenuController(_ pageMenuController: PMKPageMenuController, didSelect menuItem: PMKPageMenuItem, at menuIndex: Int) {
//    menuItem.badgeValue = nil // XXX: For .hacka style
//  }
//}
