//
//  FeedBackController.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/12/31.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import ObjectMapper

class FeedBackController: BaseViewController ,Requestable,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var uitextView: UITextView!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var summitBtn: UIButton!
    
    
    var imageNum = 0
    
    @IBAction func summitBtnAction(_ sender: Any) {
        
        let content = uitextView.text!
        var phone = phoneText.text!
        
        if content.isLengthEmpty() {
            showOnlyTextHUD(text: "请填写您的意见")
            return
        }
        if phone.isLengthEmpty()  {
            phone = stringForKey(key: Constants.account)!
        }
        
        let authenPersonalParams = HomeAPI.feedbackPathAndParams(content: content, images: "0", phone: phone)
        postRequest(pathAndParams: authenPersonalParams,showHUD: false)
    }
    
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
       
          showOnlyTextHUD(text: description)
        //super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
        
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        showOnlyTextHUD(text: "保存成功")
        //self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        phoneText.resignFirstResponder()
        uitextView.resignFirstResponder()
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "意见反馈"
        
        
        
        addGestureRecognizerToView(view: image1, target: self, actionName: "headImageAction1")
        addGestureRecognizerToView(view: image2, target: self, actionName: "headImageAction2")
        addGestureRecognizerToView(view: image3, target: self, actionName: "headImageAction3")
        addGestureRecognizerToView(view: image4, target: self, actionName: "headImageAction4")
        
        profileActionController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        profileActionController.addAction(UIAlertAction.init(title: "从相机选择", style: .default, handler: { (action) in
            self.openPhotoLibrary()
        }))
        profileActionController.addAction(UIAlertAction.init(title: "拍照", style: .default, handler: { (action) in
            self.openCamera()
        }))
        
    }
    
    @objc func headImageAction1(){
        self.present(profileActionController, animated: true, completion: nil)
        imageNum = 1
       // profileActionController.message = "请选择您的照片"
        
    }
    @objc func headImageAction2(){
        self.present(profileActionController, animated: true, completion: nil)
        imageNum = 2
       // profileActionController.message = "请选择您的照片"
        
    }
    @objc func headImageAction3(){
        self.present(profileActionController, animated: true, completion: nil)
        imageNum = 3
       // profileActionController.message = "请选择您的照片"
        
    }
    @objc func headImageAction4(){
        self.present(profileActionController, animated: true, completion: nil)
        imageNum = 4
       // profileActionController.message = "请选择您的照片"
        
    }
    
    
    
    
    
    lazy var profileActionController: UIAlertController = UIAlertController.init(title: "选择照片", message: "", preferredStyle: .actionSheet)
    
    lazy var pickerController: UIImagePickerController = {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        return pickerController
    }()
    
    
    
    
    
  
    
    
    
    
  
    
    
    
    
    var imagePath = ""
    var headimgModel = ImageModel()
    func uploadPhoto(filePath: String) {
        DialogueUtils.showWithStatus("正在上传")
        
       // /common/api/up_img
       // /users/api/editAvatar
        HttpRequest.uploadImage(url: "/common/api/up_img", filePath: filePath,success: { (content) -> Void in
            DialogueUtils.dismiss()
            DialogueUtils.showSuccess(withStatus: "上传成功")
            self.headimgModel = Mapper<ImageModel>().map(JSONObject: content.rawValue)
        }) { (errorInfo) -> Void in
            DialogueUtils.dismiss()
            DialogueUtils.showError(withStatus: errorInfo)
         
        }
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
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker:UIImagePickerController,didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey:Any]){
        let publicImageType = "public.image"
        if let typeInfo = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaType.rawValue)] as? String {
            if typeInfo == publicImageType {
                if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage {
                    var data: NSData?
                    if image.pngData() == nil {
                        data = image.jpegData(compressionQuality: 0.8) as NSData?
                    } else {
                        data = image.pngData() as NSData?
                    }
                    if data != nil {//上传头像到服务器
                        let home = NSHomeDirectory() as NSString
                        let docPath = home.appendingPathComponent("Documents") as NSString;
                        imagePath = docPath.appendingPathComponent("uplodImage.png");
                        data?.write(toFile: imagePath, atomically: true)
                        if imageNum == 1{
                            image1.image = image
                        }else if imageNum == 2{
                            image2.image = image
                        }else if imageNum == 2{
                            image3.image = image
                        }else if imageNum == 2{
                            image4.image = image
                        }
                        uploadPhoto(filePath: imagePath)
                    }
                }
            }
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
    
}
