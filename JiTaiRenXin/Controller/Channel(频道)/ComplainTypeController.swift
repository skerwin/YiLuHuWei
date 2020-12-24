//
//  ComplainTypeController.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/19.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import SwiftyJSON
import IQKeyboardManagerSwift
import ObjectMapper

class ComplainTypeController: BaseViewController,Requestable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var cancleBtn: UIButton!
    @IBOutlet weak var sureBtn: UIButton!
    
    let placeStr = "请输入举报原因"
    var detailContent = ""
    
    var model: CommentModel!
    var textType = ""
    var cid = 0    //被举报的评论ID
    var complainSuccess:(() -> Void)?

    
    var dataSources = ["广告或垃圾信息","违反法律法规","包含侮辱性词汇","其他"]
    @IBAction func cancleBtnACtion(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sureBtnACtion(_ sender: Any) {
         detailContent = textView.text
         if detailContent == placeStr{
            detailContent = ""
         }
        if textType.isEmptyStr() {
            showOnlyTextHUD(text: "请选择举报类型")
            return
        }
        
        let pathAndParams = HomeAPI.ComplainCommentPathAndParams(report_type: 2, categories: textType, id: model.id, reason: detailContent, article_id: model.obj_id)
        postRequest(pathAndParams: pathAndParams,showHUD: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = true;
        textView.layer.borderWidth = 1
        textView.layer.borderColor = ZYJColor.testLine.cgColor
        textView.textColor = UIColor.darkText
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.delegate = self;
        
        textView.text = placeStr
        textView.textColor = UIColor.gray
//        if textView.text == "placeStr"{
//             textView.textColor = UIColor.darkText
//        }else{
//             textView.textColor = UIColor.gray
//        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibWithTableViewCellName(name: ComplainTypeCell.nameOfClass)
        tableView.separatorStyle = .none
        
        
        // Do any additional setup after loading the view.
    }
    
       override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
           //ischeck 是否审核  0 未审核  1  审核中  2 通过审核 3 审核为通过
           super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
           self.complainSuccess!()
           self.dismiss(animated: true, completion: nil)
    
       }
       
       override func onFailure(responseCode: String, description: String, requestPath: String) {
           
           super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
           
       }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        textView.resignFirstResponder()
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
extension ComplainTypeController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComplainTypeCell", for: indexPath) as! ComplainTypeCell
        cell.selectionStyle = .none
        cell.textType.text = dataSources[indexPath.row]
        cell.dotImage.image = UIImage.init(named: "quanNO")
        //cell.model = notifyModelList[indexPath.row]
        //cell.delegeta = self
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.reloadData()
        
        let cell = tableView.cellForRow(at: indexPath) as! ComplainTypeCell
        
         cell.dotImage.image = UIImage.init(named: "quanYES")
         textType = dataSources[indexPath.row]
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
extension ComplainTypeController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeStr{
            textView.text = ""
        }
        textView.textColor = UIColor.darkText
        textView.font = UIFont.systemFont(ofSize: 15)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = placeStr
            textView.textColor = UIColor.gray
            textView.font = UIFont.systemFont(ofSize: 15)
        }else{
            textView.textColor = UIColor.darkText
            textView.font = UIFont.systemFont(ofSize: 15)
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        return true
    }
}
