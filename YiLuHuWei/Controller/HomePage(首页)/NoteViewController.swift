//
//  NoteViewController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/02/01.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import IQKeyboardManagerSwift
import ActionSheetPicker_3_0

class NoteViewController: BaseViewController,Requestable  {

    @IBOutlet weak var titleBg: UIView!
    @IBOutlet weak var titleF: UITextField!
    
    @IBOutlet weak var groupBg: UIView!
    @IBOutlet weak var gruopLabel: UILabel!
    
    
    @IBOutlet weak var contentBG: UIView!
    @IBOutlet weak var contrntF: UITextView!
    @IBOutlet weak var save: UIButton!
    
    @IBOutlet weak var contentlabel: UILabel!
    
    
    var noteModel = NoteModel()
    
    var groupList = [DepartmentModel]()
    
    var groupChoosePicker:ActionSheetStringPicker? = nil //小组选择器
    
    var group_id = 0
    var atitle = ""
    var content = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "笔记"
        titleBg.layer.cornerRadius = 10
        titleBg.layer.masksToBounds = true
        
        groupBg.layer.cornerRadius = 10
        groupBg.layer.masksToBounds = true
        
        contentBG.layer.cornerRadius = 10
        contentBG.layer.masksToBounds = true
 
        save.layer.cornerRadius = 10
        save.layer.masksToBounds = true
        if noteModel?.id == 0{
            addGestureRecognizerToView(view: gruopLabel, target: self, actionName: "gruopLabelAction")
            loadCache()
        }else{
            titleF.isEnabled = false
            titleF.text = noteModel?.title
            
            gruopLabel.text = noteModel?.group_name
            gruopLabel.textColor = UIColor.black
            
            contrntF.isEditable = false
            contrntF.text = noteModel?.content
            contentlabel.text = "内容"
            
            save.isHidden = true
        }
 
        // Do any additional setup after loading the view.
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
    
    @objc func gruopLabelAction(){
        var nextstrArr = [String]()
        for dictModel in groupList {
            nextstrArr.append(dictModel.name)
        }
        self.groupChoosePicker = ActionSheetStringPicker.init(title: "选择小组", rows: nextstrArr, initialSelection: 0, doneBlock: { [self] (picker, index, value) in
            if let strValue = value as? String {
                self.gruopLabel?.text = strValue
                self.gruopLabel?.textColor = UIColor.black
                self.group_id = groupList[index].id
            }
        }, cancel: { (picker) in
            
        }, origin:
            self.view
        )
        self.groupChoosePicker!.tapDismissAction = .cancel
        self.groupChoosePicker!.show()
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        atitle = titleF.text!
        content = contrntF.text!
        if atitle.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "标题不能为空")
            return
        }
        if atitle.charLength() > 20{
            DialogueUtils.showError(withStatus: "标题不能超过20字符")
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
        
        let pathAndParams = HomeAPI.noteSavePathPathAndParams(id: 0, title: atitle, group_id: group_id, content: content)
        postRequest(pathAndParams: pathAndParams,showHUD: false)
    }
 
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        
        let noticeView = UIAlertController.init(title: "提示", message: "添加成功", preferredStyle: .alert)
        noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
            
        }))
        self.present(noticeView, animated: true, completion: nil)
        //showOnlyTextHUD(text: "发布成功")
        
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
