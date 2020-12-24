//
//  PersonsInfoController.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/03.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import ActionSheetPicker_3_0
import SwiftyJSON
import ObjectMapper

class PersonsInfoController: BaseTableController,Requestable,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var mobileText: UITextField!
    @IBOutlet weak var nickNameText: UITextField!
    
    @IBOutlet weak var menBtn: UIButton!
    @IBOutlet weak var wommen: UIButton!
    
    @IBAction func menActioin(_ sender: Any) {
        userModel?.sex = 1
        menBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
        wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
    }
    
    @IBAction func wonmen(_ sender: Any) {
        
        userModel?.sex = 2
        wommen.setImage(UIImage.init(named: "quanYES"), for: .normal)
        menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
    }
    
    
    var userModel = UserModel()
    
    var imageToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人信息"
        self.tableView.showsVerticalScrollIndicator = false
        createRightNavItem()
        addGestureRecognizerToView(view: headImage, target: self, actionName: "headImageAction")
        
        profileActionController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        profileActionController.addAction(UIAlertAction.init(title: "从相机选择", style: .default, handler: { (action) in
            self.openPhotoLibrary()
        }))
        profileActionController.addAction(UIAlertAction.init(title: "拍照", style: .default, handler: { (action) in
            self.openCamera()
        }))
        
        mobileText.text = stringForKey(key: Constants.account)
        userModel?.mobile = mobileText.text!
        mobileText.isEnabled = false
        
        let truename = stringForKey(key: Constants.truename)
        if truename != nil && !(truename?.isLengthEmpty())!{
            nameText.text = truename
            userModel?.realname = truename!
            nameText.isEnabled = false
        }
        
        let nickname = stringForKey(key: Constants.nickname)
        if nickname != nil && !(nickname?.isLengthEmpty())!{
            nickNameText.text = nickname
        }
        
        if let gender = objectForKey(key: Constants.gender){
            
            if (gender as! Int) == 0 {
                wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
                menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
            }else if (gender as! Int) == 2 {
                userModel?.sex = 2
                wommen.setImage(UIImage.init(named: "quanYES"), for: .normal)
                menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
                menBtn.isEnabled = false
                wommen.isEnabled = false
            }
            else{
                userModel?.sex = 1
                menBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
                wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
                menBtn.isEnabled = false
                wommen.isEnabled = false
            }
 
        }else{
            wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
            menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
            userModel!.sex = 0
        }
        
      
        let avater = stringForKey(key: Constants.avatar)
         if avater != nil && !(avater?.isLengthEmpty())!{
            headImage.displayHeadImageWithURL(url: userModel?.avatar_url)
            userModel?.avatar = avater!
            userModel?.avatar_id = Int.init(avater!) ?? 0
        }
        headImage.layer.cornerRadius = 30;
        headImage.layer.masksToBounds = true
      
    }
 
    lazy var profileActionController: UIAlertController = UIAlertController.init(title: "选择照片", message: "", preferredStyle: .actionSheet)
    
    lazy var pickerController: UIImagePickerController = {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        return pickerController
    }()
    
    
    @objc func headImageAction(){
        self.present(profileActionController, animated: true, completion: nil)
       // profileActionController.message = "请选择您的照片"
        
    }
 
    
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
       
          showOnlyTextHUD(text: description)
        //super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
        
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        showOnlyTextHUD(text: "保存成功")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightNavBtnClick(){
   
        userModel?.realname = nameText.text!
        userModel?.nickname = nickNameText.text!
 
        if userModel!.nickname.count > 10 {
            showOnlyTextHUD(text: "昵称不能超过10个字符")
            return
        }
        
        //        if  userModel!.avatar_id == -1 {
        //            showOnlyTextHUD(text: "请完善您的信息")
        //            return
        //        }
        if userModel!.realname.isLengthEmpty() || userModel!.nickname.isLengthEmpty() {
            showOnlyTextHUD(text: "请完善您的信息")
            return
        }
        
        if userModel!.realname.isContainsEmoji() || userModel!.nickname.isContainsEmoji() {
            showOnlyTextHUD(text: "不支持输入表情")
            return
        }
 
 
        
        let authenPersonalParams = HomeAPI.editProfilePathAndParams(usermodel: userModel!)
        postRequest(pathAndParams: authenPersonalParams,showHUD: false)
        
    }
    func createRightNavItem(title:String = "保存",imageStr:String = "") {
        if imageStr == ""{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: title, style: .plain, target: self, action:  #selector(rightNavBtnClick))
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: imageStr), style: .plain, target: self, action: #selector(rightNavBtnClick))
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.1
        }else{
            return 10
        }
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        nameText.resignFirstResponder()
        nickNameText.resignFirstResponder()
        mobileText.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        nameText.resignFirstResponder()
        nickNameText.resignFirstResponder()
        mobileText.resignFirstResponder()
        
    }
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
            self.userModel?.avatar_id = self.headimgModel!.id
        }) { (errorInfo) -> Void in
            DialogueUtils.dismiss()
            DialogueUtils.showError(withStatus: errorInfo)
            self.headImage.image = UIImage.init(named: "HeaderCamera")
            self.headimgModel = ImageModel()
            self.userModel?.avatar_id = -1
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
                        headImage.image = image
                        uploadPhoto(filePath: imagePath)
                    }
                }
            }
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
    
}
