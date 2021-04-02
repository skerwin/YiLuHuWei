//
//  AuthenController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/08/04.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import ActionSheetPicker_3_0
import SwiftyJSON
import ObjectMapper

class AuthenController: BaseTableController,Requestable,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var menBtn: UIButton!
    
    @IBOutlet weak var wommen: UIButton!
    @IBOutlet weak var mobileText: UITextField!
    
    @IBOutlet weak var hospitalText: UITextField!
    @IBOutlet weak var officesLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var badgeImage: UIImageView!
    
    
    @IBOutlet weak var certificateImage1: UIImageView!
    
    @IBOutlet weak var summbitBtn: UIButton!
    
    
    @IBOutlet weak var badgedeleteBtn: UIButton!
    @IBOutlet weak var cerDeleteBtn: UIButton!
    
    @IBAction func badgedeleteBtnAction(_ sender: Any) {
        
        self.badgedeleteBtn.isHidden = true
        self.userModel?.qualifications = 0
        breastplateimgModel = ImageModel()
        self.badgeImage.image = UIImage.init(named: "jiahaotupian")
 
    }
    @IBAction func cerDeleteBtnAction(_ sender: Any) {
        self.cerDeleteBtn.isHidden = true
        self.userModel?.qualifications_two = 0
        medicallicenceimgModel1 = ImageModel()
        self.certificateImage1.image = UIImage.init(named: "jiahaotupian")
    }
    
    var professionalModelList = [DepartmentModel]()
    var departmentsModelList = [DepartmentModel]()
    var nextDepartmentsList = [DepartmentModel]()
    
    var officesChoosePicker:ActionSheetCustomPicker? = nil //科室选择器
    var titlePicker:ActionSheetStringPicker? = nil //职称选择器
    
    var uploadTag = 0
    
    var userModel = UserModel()
    
    var imageToken = ""
    
    var isFormMine = false
    
    lazy var profileActionController: UIAlertController = UIAlertController.init(title: "选择照片", message: "", preferredStyle: .actionSheet)
    
    lazy var pickerController: UIImagePickerController = {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        return pickerController
    }()
    
    
    
    func createRightNavItem(title:String = "返回",imageStr:String = "") {
        if imageStr == ""{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: title, style: .plain, target: self, action:  #selector(rightNavBtnClick))
        }else{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: imageStr), style: .plain, target: self, action: #selector(rightNavBtnClick))
        }
         
        
    }
    
    
    @objc func rightNavBtnClick(){
        
        self.dismiss(animated: true, completion: nil)
        //跳转前的操作写这里
        
    }
    func initView(){
        profileActionController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        profileActionController.addAction(UIAlertAction.init(title: "从相机选择", style: .default, handler: { (action) in
            self.openPhotoLibrary()
        }))
        profileActionController.addAction(UIAlertAction.init(title: "拍照", style: .default, handler: { (action) in
            self.openCamera()
        }))
        
        
        addGestureRecognizerToView(view: badgeImage, target: self, actionName: "badgeImageAction")
        addGestureRecognizerToView(view: certificateImage1, target: self, actionName: "certificateImage1Action")
        
        
        summbitBtn.backgroundColor = ZYJColor.main
        summbitBtn.setTitle("提交", for:.normal)
        summbitBtn.setTitleColor(UIColor.white, for: .normal)
        summbitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        summbitBtn.layer.cornerRadius = 15
        summbitBtn.layer.masksToBounds = true
        
        badgedeleteBtn.isHidden = true
        cerDeleteBtn.isHidden = true
    
        
        
        mobileText.isEnabled = false
        //let str = stringForKey(key: Constants.account)!
        mobileText.text = stringForKey(key: Constants.account)!
        userModel?.mobile = mobileText.text!
        userModel?.password = stringForKey(key: Constants.password) ?? ""
        
        
        if let gender = objectForKey(key: Constants.gender)  {
            
            if gender is NSNull {
                wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
                menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
                userModel!.sex = 0
            }else{
                if (gender as! Int) == 0 {
                    wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
                    menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
                }else if (gender as! Int) == 2 {
                    userModel?.sex = 2
                    wommen.setImage(UIImage.init(named: "quanYES"), for: .normal)
                    menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
                }else{
                    userModel?.sex = 1
                    menBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
                    wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
                }
            }
        }else{
            wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
            menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
            userModel!.sex = 0
        }
 
        let truename = stringForKey(key: Constants.truename)
        if truename != nil && !(truename?.isLengthEmpty())!{
            nameText.text = truename
            //nameText.isEnabled = false
        }
     }
    
    @IBAction func menBtnAction(_ sender: Any) {
        userModel?.sex = 1
        menBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
        wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
        
    }
    
    @IBAction func wommenBtnAction(_ sender: Any) {
        userModel?.sex = 2
        wommen.setImage(UIImage.init(named: "quanYES"), for: .normal)
        menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
        
    }
    
    @IBAction func summbitAction(_ sender: Any) {
      
 
        userModel?.user_realname = nameText.text!
        userModel?.hospital = hospitalText.text!

        userModel?.qualifications = breastplateimgModel!.id

        userModel?.qualifications_two = medicallicenceimgModel1!.id

        if userModel!.user_realname.isLengthEmpty() || userModel!.sex == 0 || userModel!.mobile.isLengthEmpty() || userModel!.hospital.isLengthEmpty() {
                showOnlyTextHUD(text: "请完善您个人的信息")
                return
        }

        if userModel!.department_id == 0 || userModel!.professional_id == 0 {
                showOnlyTextHUD(text: "请完善您的信息")
                return
        }
        
        if userModel!.qualifications == 0 {
            showOnlyTextHUD(text: "请上传您的胸牌照片")
            return
        }

        if userModel?.qualifications_two == 0 {
            userModel!.qualification_type = 1
        }else{
            userModel!.qualification_type = 2
        }

        //TODO ZHAO
        if userModel!.user_realname.isContainsEmoji() || (userModel!.hospital).isContainsEmoji() {
            showOnlyTextHUD(text: "不支持输入表情")
            return
        }

      
        let authenPersonalParams = HomeAPI.authDoctorPathAndParams(usermodel: userModel!)
        postRequest(pathAndParams: authenPersonalParams,showHUD: false)
     
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "医师认证"
        initView()
        if isFormMine == false{
            createRightNavItem(title: "返回", imageStr: "backarrow")
        }
       
        prepareData()
        
    }
    
    func prepareData(){
        let jobtitleParams = HomeAPI.professionalPathAndParams()
        postRequest(pathAndParams: jobtitleParams,showHUD: false)
    }
    
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
       
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        if requestPath == HomeAPI.professionalPath {
            professionalModelList = getArrayFromJsonByArrayName(arrayName: "pro_list", content:  responseResult)
            departmentsModelList = getArrayFromJsonByArrayName(arrayName: "depart_list", content:  responseResult)
            nextDepartmentsList = departmentsModelList.first!.child
         }
        
        else if requestPath == HomeAPI.authDoctorPath {
            //保存一下真实姓名
            setValueForKey(value:  userModel?.sex as AnyObject, key: Constants.gender)
            setValueForKey(value:  userModel?.user_realname as AnyObject, key: Constants.truename)
            let vc = UIStoryboard.getAuthenSubmitedController()
            vc.isFormMine = self.isFormMine
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Table view data source
    @objc func badgeImageAction(){
        self.present(profileActionController, animated: true, completion: nil)
        profileActionController.message = "请选择您的胸牌照片"
        uploadTag = 0
        
    }
    @objc func certificateImage1Action(){
        self.present(profileActionController, animated: true, completion: nil)
        profileActionController.message = "请选择您的医师资格证照片"
        uploadTag = 1
        
    }
   
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 3
        }else if section == 1{
            return 3
        }else if section == 2{
            return 2
        }
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 122
        }
        return 44
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            if indexPath.row == 1 {
                
                self.officesChoosePicker = ActionSheetCustomPicker.init(title: "科室选择", delegate: self, showCancelButton: true, origin: self.view, initialSelections: [0,0])
                self.officesChoosePicker?.delegate = self
                officesChoosePicker?.tapDismissAction  = .success;
                officesChoosePicker?.show()
                
                
            }else if indexPath.row == 2 {
                var nextstrArr = [String]()
                if professionalModelList.count == 0{
                    return
                }
                for model in professionalModelList {
                    nextstrArr.append(model.name)
                }
                self.titlePicker = ActionSheetStringPicker(title: "职称选择", rows: nextstrArr, initialSelection: 0, doneBlock: { (picker, index, value) in
                    let model = self.professionalModelList[index]
                    self.titleLabel.text = model.name
                    self.userModel?.professional_text = model.name
                    self.userModel?.professional_id = model.id
                }, cancel: { (picker) in
                    
                }, origin: self.view)
                self.titlePicker!.tapDismissAction = .cancel
                self.titlePicker!.show()
            }
        }
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
        mobileText.resignFirstResponder()
        hospitalText.resignFirstResponder()
    }
    //13336088188
    
    var breastplateimgModel = ImageModel()
    var medicallicenceimgModel1 = ImageModel()
    var imagePath = ""
    func uploadPhoto(filePath: String) {
        DialogueUtils.showWithStatus("正在上传")
        HttpRequest.uploadImage(url: "/file/uploadimage", filePath: filePath ,success: { [self] (content) -> Void in
            DialogueUtils.dismiss()
            DialogueUtils.showSuccess(withStatus: "上传成功")
                        
            if self.uploadTag == 0 {
                self.badgedeleteBtn.isHidden = false
                self.breastplateimgModel = Mapper<ImageModel>().map(JSONObject: content.rawValue)
                self.userModel?.qualifications = breastplateimgModel?.id ?? 0
             }else if self.uploadTag == 1 {
                self.cerDeleteBtn.isHidden = false
                self.medicallicenceimgModel1 = Mapper<ImageModel>().map(JSONObject: content.rawValue)
                self.userModel?.qualifications_two = medicallicenceimgModel1?.id ?? 0
            }
            
        }) { (errorInfo) -> Void in
            if self.uploadTag == 0 {
                self.badgeImage.image = UIImage.init(named: "jiahaotupian")
                self.breastplateimgModel = ImageModel()
                
            }else if self.uploadTag == 1 {
                self.certificateImage1.image = UIImage.init(named: "jiahaotupian")
                self.medicallicenceimgModel1 = ImageModel()
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
                        if uploadTag == 0 {
                            badgeImage.image = image
                         }else if uploadTag == 1 {
                            certificateImage1.image = image
                        }
                        uploadPhoto(filePath: imagePath)
                    }
                }
            }
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    
    var isNextDepartment = false
    var isNextDepartment1 = false
}

extension AuthenController:ActionSheetCustomPickerDelegate,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return departmentsModelList.count
        }else{
            return nextDepartmentsList.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0{
            return departmentsModelList[row].name
        }else{
            return nextDepartmentsList[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0{
            isNextDepartment = true
            nextDepartmentsList = departmentsModelList[row].child
         
            pickerView.reloadComponent(1)
        }else{
            isNextDepartment1 = true
            self.userModel?.department_text = nextDepartmentsList[row].name
            self.userModel?.department_id = nextDepartmentsList[row].id
            officesLabel.text = nextDepartmentsList[row].name
        }
    }
    func actionSheetPickerDidSucceed(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
     
        if isNextDepartment {
            if isNextDepartment1 == false{
                self.userModel?.department_text = nextDepartmentsList[0].name
                self.userModel?.department_id = nextDepartmentsList[0].id
                officesLabel.text = nextDepartmentsList[0].name
            }
          
        }else{
            if isNextDepartment1 == false{
                nextDepartmentsList = departmentsModelList[0].child
                self.userModel?.department_text = nextDepartmentsList[0].name
                self.userModel?.department_id = nextDepartmentsList[0].id
                officesLabel.text = nextDepartmentsList[0].name
            }
           
        }
    }
    func actionSheetPickerDidCancel(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
        
    }
    
    //重置label
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var lable:UILabel? = view as? UILabel
        if lable == nil{
            lable = UILabel.init()
        }
        if component == 0{
            
            lable?.text = departmentsModelList[row].name
            lable?.font = UIFont.systemFont(ofSize: 17)
        }else{
            lable?.text = nextDepartmentsList[row].name
             lable?.font = UIFont.systemFont(ofSize: 16)
        }
        lable?.textAlignment = .center
        return lable!
    }
}
