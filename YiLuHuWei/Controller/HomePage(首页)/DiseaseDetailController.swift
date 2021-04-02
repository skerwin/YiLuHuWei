//
//  DiseaseDetailController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/21.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import ObjectMapper
import WebKit

class DiseaseDetailController: BaseViewController ,Requestable{
    
    
    var name = ""
    var subTypeName = ""
    var ct = ""
    var diseaseModel = DiseaseDetail()
    var tempTagList = [DiseaseTags]()
    var contetString = ""
    var diseaseID = ""
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var courcelabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentWebIView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "详情"
        loadData()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func loadData(){
        //55bf00e7c5479fa8da1e9ff9 55bf00dec5479fa8da1e9ff0
        let diseaseDetail = HomeAPI.diseaseDetailPathAndParams(id: diseaseID)
        postRequest(pathAndParams: diseaseDetail,showHUD: true)
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    func attrHtmlStringFrom(content: String) -> NSAttributedString{
        
        
        //let strCon = content as! NSString
        var attrstring:NSAttributedString!
        
        let str = String.localizedStringWithFormat("<html><meta content=\"width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=0; \" name=\"viewport\" /><body style=\"overflow-wrap:break-word;word-break:break-all;white-space: normal; font-size:15px; color:#A4A4A4; \">%@</body></html>", content)
        
        
        attrstring = str.html2AttributedString
        
        return attrstring
        
    }
    
    func html2String(content: String) -> String{
        
        let str = String.localizedStringWithFormat("<html><meta content=\"width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=0; \" name=\"viewport\" /><body style=\"overflow-wrap:break-word;word-break:break-all;white-space: normal; font-size:16px; color:#000000; \">%@</body></html>", content)
        //return str
        return str
        
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        diseaseModel = Mapper<DiseaseDetail>().map(JSONObject: responseResult.rawValue)
        if diseaseModel == nil {
            return
        }
        //  let str1 = "<p>致病机制</p>"
        //  let str = "<font color=\"#6c6c6c\">满20减5 满40减15，还剩<font color=\"#ff9147\">113天";
        // for tagmodel in diseaseModel!.tagList {
        for tagmodel in diseaseModel!.tagList {
            if tagmodel.name == "简介"{
                contetString = contetString + "<h3>简介</h3>" + tagmodel.content
                tempTagList.append(tagmodel)
                break
            }
        }
        for tagmodel in diseaseModel!.tagList {
            if tagmodel.name == "临床表现"{
                contetString = contetString + "<h3>临床表现</h3>" + tagmodel.content
                tempTagList.append(tagmodel)
                break
            }
        }
        for tagmodel in diseaseModel!.tagList {
            if tagmodel.name == "病因"{
                contetString = contetString + "<h3>病因</h3>" + tagmodel.content
                tempTagList.append(tagmodel)
                break
            }
        }
        for tagmodel in diseaseModel!.tagList {
            if tagmodel.name == "检查"{
                contetString = contetString + "<h3>病因</h3>" + tagmodel.content
                tempTagList.append(tagmodel)
                break
            }
        }
        for tagmodel in diseaseModel!.tagList {
            if tagmodel.name == "诊断"{
                contetString = contetString + "<h3>诊断</h3>" + tagmodel.content
                tempTagList.append(tagmodel)
                break
            }
        }
        for tagmodel in diseaseModel!.tagList {
            if tagmodel.name == "治疗"{
                contetString = contetString + "<h3>治疗</h3>" + tagmodel.content
                tempTagList.append(tagmodel)
                break
            }
        }
        
        for tagmodel in diseaseModel!.tagList {
            if tagmodel.name == " 预防预后"{
                contetString = contetString + "<h3>治疗</h3>" + tagmodel.content
                tempTagList.append(tagmodel)
                break
            }
        }
        
        //   }
        titleLabel.text = diseaseModel?.name
        courcelabel.text = diseaseModel?.subTypeName
        timeLabel.text = diseaseModel?.ct
        contentWebIView.loadHTMLString(html2String(content: contetString), baseURL: nil)
        
        //let token = responseResult["token"].stringValue
        // DiseaseList = getArrayFromJsonByArrayName(arrayName: "contentlist", content:  responseResult["pagebean"])
        
        
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
