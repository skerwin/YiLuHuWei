//
//  MainTabBarController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/07/23.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit



enum TabbarContentType: Int {
    case HomePage = 0,Articl, Mine
}

class MainTabBarController: UITabBarController {

    
    let homePageController = HomeViewController()
   
    let columnForController = SchoolViewController()
    let mineController = UIStoryboard.getMineViewController()
         
    var selectedItemTag = 0
    
    override func viewDidLoad() {
        

        super.viewDidLoad()
 
        addChildViewControllers()
        self.tabBar.tintColor = ZYJColor.main
//        addChildViewControllers()
//        if let viewControllers = viewControllers {
//            selectedViewController = viewControllers[0]
//        }
//             /// Set the animation type for swipe
//         swipeAnimatedTransitioning?.animationType = SwipeAnimationType.overlap
//
//            /// Set the animation type for tap
//         tapAnimatedTransitioning?.animationType = SwipeAnimationType.push
//
//            /// if you want cycling switch tab, set true 'isCyclingEnabled'
//         isCyclingEnabled = false
//
//            /// Disable custom transition on tap.
//         tapAnimatedTransitioning = nil
//
//            /// Set swipe to only work when strictly horizontal.
//         diagonalSwipeEnabled = false
        }
        private func addChildViewControllers() {
         addNavChildViewController(controller: homePageController, title: "首页",
                               image: UIImage(named: "iconHome")!,
                               selectedImage: UIImage(named: "iconHomeSelected")!,
                               tag: TabbarContentType.HomePage.rawValue)
         addNavChildViewController(controller: columnForController, title: "云学院",
                               image: UIImage(named: "iconArctile")!,
                               selectedImage: UIImage(named: "iconArctileSelected")!,
                               tag: TabbarContentType.Articl.rawValue)
         addNavChildViewController(controller: mineController, title: "我的",
                               image: UIImage(named: "iconMine")!,
                               selectedImage: UIImage(named: "iconMineSelected")!,
                               tag: TabbarContentType.Mine.rawValue)
       //  self.delegate = self

    }
    
    
      private func addNavChildViewController(controller: UIViewController, title: String, image: UIImage, selectedImage: UIImage, tag:Int) {
           controller.title = title
           // controller.tabBarItem = ESTabBarItem.init(title: title, image: image, selectedImage: UIImage)
           controller.tabBarItem.image = image
           controller.tabBarItem.tag = tag
           controller.tabBarItem.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
           let navController = MainNavigationController(rootViewController: controller)

           addChild(navController)

       }
//        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//            // Handle didSelect viewController method here
//        }

}
extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        return true
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        viewController.viewWillAppear(true)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.selectedItemTag = item.tag
        if selectedItemTag == 2 {
            mineController.viewWillAppear(true)
        }else if selectedItemTag == 1 {
            columnForController.viewWillAppear(true)
        }
    }
}

