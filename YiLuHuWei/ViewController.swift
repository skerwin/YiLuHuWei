//
//  ViewController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/07/23.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import XHLaunchAd

class ViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

 
        var pickerController:UIImagePickerController!
        
        var dele1:UIImagePickerControllerDelegate!
        var dele2:UINavigationControllerDelegate!
 
        var profileActionController: UIAlertController = UIAlertController.init(title: "选择照片", message: "", preferredStyle: .actionSheet)
     
 
    func initView(){
     
        profileActionController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                 
             }))
        profileActionController.addAction(UIAlertAction.init(title: "从相机选择", style: .default, handler: { (action) in
                 self.openPhotoLibrary()
             }))
        profileActionController.addAction(UIAlertAction.init(title: "拍照", style: .default, handler: { (action) in
                 self.openCamera()
             }))
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "详情"

        XHLaunchAd.setLaunch(.launchScreen)
        let imageAdconfiguration = XHLaunchImageAdConfiguration.default()
        imageAdconfiguration.duration = 5;
        imageAdconfiguration.imageNameOrURLString = "adImage4.gif"
        imageAdconfiguration.openModel = "http://www.it7090.com"
        XHLaunchAd.imageAd(with: imageAdconfiguration, delegate: self)
        
    }
    
    @objc func badgeImageAction(){
        self.present(profileActionController, animated: true, completion: nil)
        profileActionController.message = "请选择您的医师资格证照片2"
    }
     
    // 打开照相功能
      func openCamera() {
          if UIImagePickerController.isSourceTypeAvailable(.camera) {
              pickerController.sourceType = .camera
              pickerController.allowsEditing = true
              present(pickerController, animated: true, completion: nil)
          } else {
              print("模拟器没有摄像头，请使用真机调试")
          }
      }
      
      func openPhotoLibrary() {
          
          
          pickerController = UIImagePickerController()
          pickerController.delegate = self
          self.navigationController?.delegate = self
                 
          dele1 = pickerController.delegate
          dele2 =  self.navigationController?.delegate
          pickerController.allowsEditing = true
          
          pickerController.sourceType = .photoLibrary
          pickerController.allowsEditing = true
          present(pickerController, animated: true, completion: nil)
      }
      
      private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
         print("r5436utyr")
      }
      
 
}

