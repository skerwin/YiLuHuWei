//
//  PostArcticleController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/29.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import IQKeyboardManagerSwift
import ActionSheetPicker_3_0

class PostArcticleController:  BaseTableController,Requestable,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var groupLabel: UITextField!
    @IBOutlet weak var contentLabel: UITextField!
    
    @IBOutlet weak var plcontentLabel: UILabel!
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var imagedelBtn1: UIButton!
    @IBOutlet weak var imagedelBtn2: UIButton!
    @IBOutlet weak var imagedelBtn3: UIButton!
    
    @IBAction func imagedelBtnAction1(_ sender: Any) {
       ImageModel1 = ImageModel()
        imagedelBtn1.isHidden = true
        self.image1.image = UIImage.init(named: "jiahaotupian")
    }
    @IBAction func imagedelBtnAction2(_ sender: Any) {
        ImageModel2 = ImageModel()
        imagedelBtn2.isHidden = true
        self.image2.image = UIImage.init(named: "jiahaotupian")
    }
    @IBAction func imagedelBtnAction3(_ sender: Any) {
        ImageModel3 = ImageModel()
        imagedelBtn3.isHidden = true
        self.image3.image = UIImage.init(named: "jiahaotupian")
    }
    
    var groupList = [DepartmentModel]()
    
    var groupChoosePicker:ActionSheetStringPicker? = nil //小组选择器
    
    var group_id = 0
    var atitle = ""
    var content = ""
    
    var imageTag = 0
    
    var imageNameList = [String]()
    var imagePathList = [String]()
    
    var hadTypeContent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "编辑文章"
        self.tableView.backgroundColor = ZYJColor.tableViewBg
        imagedelBtn1.isHidden = true
        imagedelBtn2.isHidden = true
        imagedelBtn3.isHidden = true
        loadCache()
        createRightNavItem()
        
        addGestureRecognizerToView(view: image1, target: self, actionName: "image1Action")
        addGestureRecognizerToView(view: image2, target: self, actionName: "image2Action")
        addGestureRecognizerToView(view: image3, target: self, actionName: "image3Action")
        
        profileActionController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        profileActionController.addAction(UIAlertAction.init(title: "从相机选择", style: .default, handler: { (action) in
            self.openPhotoLibrary()
        }))
        profileActionController.addAction(UIAlertAction.init(title: "拍照", style: .default, handler: { (action) in
            self.openCamera()
        }))
        contentLabel.isEnabled = false
        //tableView.separatorStyle = .none
    }
    
    @objc func image1Action(){
        imageTag = 1
        self.present(profileActionController, animated: true, completion: nil)
       // profileActionController.message = "请选择您的照片"
        
    }
    @objc func image2Action(){
        imageTag = 2
        self.present(profileActionController, animated: true, completion: nil)
       // profileActionController.message = "请选择您的照片"
        
    }
    @objc func image3Action(){
        imageTag = 3
        self.present(profileActionController, animated: true, completion: nil)
       // profileActionController.message = "请选择您的照片"
        
    }
    lazy var profileActionController: UIAlertController = UIAlertController.init(title: "选择照片", message: "", preferredStyle: .actionSheet)
    
    lazy var pickerController: UIImagePickerController = {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        return pickerController
    }()
    
    func createRightNavItem(title:String = "发布",imageStr:String = "") {
        if imageStr == ""{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: title, style: .plain, target: self, action:  #selector(rightNavBtnClick))
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: imageStr), style: .plain, target: self, action: #selector(rightNavBtnClick))
        }
        
    }
    
    func loadCache(){
        let result = XHNetworkCache.check(withURL: HomeAPI.groupAllListPath)
        if result {
            let dict = XHNetworkCache.cacheJson(withURL: HomeAPI.groupAllListPath)
            let responseJson = JSON(dict)
            print("缓存读取")
            var list = [DepartmentModel]()
            list = getArrayFromJson(content: responseJson["data"])
            for model in list{
                for cmodel in model.child{
                    groupList.append(cmodel)
                }
            }
            
        }
    }
    var imagePath = ""
    var ImageModel1 = ImageModel()
    var ImageModel2 = ImageModel()
    var ImageModel3 = ImageModel()
    
    @objc func rightNavBtnClick(){
        
        atitle = titleLabel.text!
        if atitle.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "标题不能为空")
            return
        }
        if atitle.charLength() > 30{
            DialogueUtils.showError(withStatus: "标题不能超过30字符")
            return
        }
        if group_id == 0{
            DialogueUtils.showError(withStatus: "请选择小组")
            return
        }
        
        if content.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "内容不能为空")
            return
        }
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        
        
        if ImageModel1?.id != 0 {
             imageNameList.append(ImageModel1?.filename ?? "")
             imagePathList.append(ImageModel1?.file_path ?? "")
        }
        if ImageModel2?.id != 0 {
             imageNameList.append(ImageModel2?.filename ?? "")
             imagePathList.append(ImageModel2?.file_path ?? "")
        }
        
        if ImageModel3?.id != 0 {
             imageNameList.append(ImageModel3?.filename ?? "")
             imagePathList.append(ImageModel3?.file_path ?? "")
        }
        
        
        paramsDictionary["photos_names"] = imageNameList as AnyObject
        paramsDictionary["photos_urls"] = imagePathList as AnyObject
        
        let pathAndParams = HomeAPI.articleSavePathAndParams(post_title: atitle, group_id: group_id, more: paramsDictionary, post_content: content)
        postRequest(pathAndParams: pathAndParams,showHUD: false)
        
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        
        let noticeView = UIAlertController.init(title: "提示", message: "文章发布成功", preferredStyle: .alert)
        noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
            
        }))
        self.present(noticeView, animated: true, completion: nil)
        //showOnlyTextHUD(text: "发布成功")
        
    }
    
 
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
        
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1{
            var nextstrArr = [String]()
            for dictModel in groupList {
                nextstrArr.append(dictModel.name)
            }
            self.groupChoosePicker = ActionSheetStringPicker.init(title: "选择小组", rows: nextstrArr, initialSelection: 0, doneBlock: { [self] (picker, index, value) in
                if let strValue = value as? String {
                    self.groupLabel?.text = strValue
                    self.group_id = groupList[index].id
                }
            }, cancel: { (picker) in
            }, origin:
                self.view
            )
            self.groupChoosePicker!.tapDismissAction = .cancel
            self.groupChoosePicker!.show()
        } else if indexPath.row == 2{
            let controller = WriteWebController()
            controller.writeBlock = {[weak self] (writeContent) -> Void in
                self?.content = writeContent
                self?.hadTypeContent = writeContent
                self?.contentLabel.text = writeContent.html2String
                self?.plcontentLabel.text = "已填写"
                self?.plcontentLabel.textColor = ZYJColor.main
            }
            if self.hadTypeContent != ""{
                controller.hadTypeContent = self.hadTypeContent
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func uploadPhoto(filePath: String) {
        DialogueUtils.showWithStatus("正在上传")
        HttpRequest.uploadImage(url: "/file/uploadimage", filePath: filePath ,success: { [self] (content) -> Void in
            DialogueUtils.dismiss()
            DialogueUtils.showSuccess(withStatus: "上传成功")
 
            if self.imageTag == 1 {
                imagedelBtn1.isHidden = false
                ImageModel1 = Mapper<ImageModel>().map(JSONObject: content.rawValue)
            }else if self.imageTag == 2 {
                imagedelBtn2.isHidden = false
                ImageModel2 = Mapper<ImageModel>().map(JSONObject: content.rawValue)
            }else{
                imagedelBtn3.isHidden = false
                ImageModel3 = Mapper<ImageModel>().map(JSONObject: content.rawValue)
            }
        }) { (errorInfo) -> Void in
            if self.imageTag == 1 {
                self.image1.image = UIImage.init(named: "jiahaotupian")
            }else if self.imageTag == 2 {
                self.image2.image = UIImage.init(named: "jiahaotupian")
            }else{
                self.image3.image = UIImage.init(named: "jiahaotupian")
            }
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
                        if imageTag == 1 {
                            image1.image = image
                        }else if imageTag == 2 {
                            image2.image = image
                        }else{
                            image3.image = image
                        }
                        uploadPhoto(filePath: imagePath)
                    }
                }
            }
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
}
