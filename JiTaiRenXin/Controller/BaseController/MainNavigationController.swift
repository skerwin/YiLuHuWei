//
//  MainNavigationController.swift
//  BossJob
//
//  Created by zhaoyuanjing on 2017/09/26.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    var popDelegate: UIGestureRecognizerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavgationBar() //配置导航栏
        //addPanGesture()   //自定义导航栏会导致滑动实效，重新定义全屏滑动手势
          // Do any additional setup after loading the view.
     
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }

    func configNavgationBar(){
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationBar.setBackgroundImage(UIImage.imageWithColor(color: navigationBarColor), for: UIBarMetrics.default)
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage.imageWithColor(color: navigationBarColor)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white] //设置导航栏标题颜色
        navigationBar.tintColor = UIColor.white   //设置导航栏按钮颜色
 
    }
    func addPanGesture() {
        // 获取系统自带滑动手势的target对象
        self.popDelegate = self.interactivePopGestureRecognizer?.delegate
        //self.delegate = self
        // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//       let pan = UIPanGestureRecognizer.init(target: target, action: #selector(handleNav))
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
//           let backBarButton = UIBarButtonItem(image: UIImage(named: "backNormal")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
//            viewController.navigationItem.leftBarButtonItem = backBarButton
            viewController.hidesBottomBarWhenPushed = true
        }
         super.pushViewController(viewController, animated: animated)
    }
    
    @objc func back() {
        popViewController(animated: true)
    }
    
    func gestureBack(gesture: AnyObject ){
        popViewController(animated: true)
    }
 
}

