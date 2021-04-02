//
//  PostCasesController.swift
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

class PostCasesController:  BaseTableController,Requestable {

    @IBOutlet weak var GroupLabel: UILabel!
    @IBOutlet weak var titleLabel: UITextField!
    
   
    
    @IBOutlet weak var contentBtn: UIButton!
    
    @IBOutlet weak var auxiliaryBtn: UIButton!
    
    @IBOutlet weak var diagnosisBtn: UIButton!
    
    @IBOutlet weak var follow_upBtn: UIButton!
    
    var groupList = [DepartmentModel]()
    
    var groupChoosePicker:ActionSheetStringPicker? = nil //小组选择器
    
    
    var group_id = 0
    var atitle = ""
    var content = ""
    var auxiliary = ""
    var diagnosis = ""
    var follow_up = ""
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "编辑病例"
        self.tableView.backgroundColor = ZYJColor.tableViewBg
        loadCache()
        createRightNavItem()
        //tableView.separatorStyle = .none
    }
    
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
     
        if content.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "主述病例不能为空")
            return
        }
        
        if group_id == 0{
            DialogueUtils.showError(withStatus: "请选择小组")
            return
        }
            
        let pathAndParams = HomeAPI.cesesSavePathAndParams(title: atitle, group_id: group_id, sex: 0, age: "", content: content, collection: "", physique: "", auxiliary: auxiliary, diagnosis: diagnosis, treatment: "", follow_up: follow_up)
         postRequest(pathAndParams: pathAndParams,showHUD: false)
        
    }
  
    override func onFailure(responseCode: String, description: String, requestPath: String) {
         super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)

        
        let noticeView = UIAlertController.init(title: "提示", message: "病例发布成功", preferredStyle: .alert)
        noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)

        }))
        self.present(noticeView, animated: true, completion: nil)
        //showOnlyTextHUD(text: "发布成功")
       
    }
    
    
    @IBAction func contentBtnAction(_ sender: Any) {
        let controller = WriteWebController()
        controller.writeBlock = {[weak self] (writeContent) -> Void in
            self?.content = writeContent
            self?.contentBtn.setTitle("*主述病史√", for: .normal)
        }
        if self.content != ""{
            controller.hadTypeContent = self.content
        }
        self.navigationController?.pushViewController(controller, animated: true)
     }
    
    //√√
    @IBAction func auxiliaryBtnAction(_ sender: Any) {
        let controller = WriteWebController()
        controller.writeBlock = {[weak self] (writeContent) -> Void in
            self?.auxiliary = writeContent
            self?.auxiliaryBtn.setTitle("查体辅助√", for: .normal)
        }
        if self.auxiliary != ""{
            controller.hadTypeContent = self.auxiliary
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func diagnosisBtnAction(_ sender: Any) {
        let controller = WriteWebController()
        controller.writeBlock = {[weak self] (writeContent) -> Void in
            self?.diagnosis = writeContent
            self?.diagnosisBtn.setTitle("诊断处理√", for: .normal)
        }
        if self.diagnosis != ""{
            controller.hadTypeContent = self.diagnosis
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func follow_upBtnAction(_ sender: Any) {
        let controller = WriteWebController()
        controller.writeBlock = {[weak self] (writeContent) -> Void in
            self?.follow_up = writeContent
            self?.follow_upBtn.setTitle("随访讨论√", for: .normal)
        }
        if self.follow_up != ""{
            controller.hadTypeContent = self.follow_up
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
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
                    self.GroupLabel?.text = strValue
                    self.group_id = groupList[index].id
                }
            }, cancel: { (picker) in
                
            }, origin:
                self.view
            )
            self.groupChoosePicker!.tapDismissAction = .cancel
            self.groupChoosePicker!.show()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
