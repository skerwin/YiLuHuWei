//
//  ArcticleDetailController.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/03.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import WebKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class ArcticleDetailController: BaseViewController ,Requestable, UIWebViewDelegate {
    
    var urlString: String?
    // 进度条
    lazy var progressView = UIProgressView()
    
    var tableView:UITableView!
    
    var fid:Int?   //这是外级id，可能是文章id或者病例ID
   
    
    var commentModelList = [Array<CommentModel>]()
    
    var toCommentModel:CommentModel?
    
    var amodel = ArticleModel()
    var cmodel = CaseModel()
    
    var menytype:MenuType!
    
    var chatHeadView:ACommentBlankHeadView!
    
    var chatBlankHeadView:CommentBlankHeadView!
    
    var type = 1
    
    var goodCount = 0
    
    var commentCount = 0
    
    var webIsLoad = false
    
    var selectedSection = 0
    
    // MARK: 输入栏控制器
    lazy var commentBarVC: CommentBarController = { [unowned self] in
        let barVC = CommentBarController()
        self.view.addSubview(barVC.view)
        barVC.view.snp.makeConstraints { (make) in
            make.left.right.width.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
            
            make.height.equalTo(kChatBarOriginHeight)
        }
        barVC.delegate = self
        return barVC
        }()
    
    override func viewDidLoad() {
        self.title = "详情"
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: ZYJColor.main), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: ZYJColor.main)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white] //设置导航栏标题颜色
        self.navigationController?.navigationBar.tintColor = UIColor.white   //设置导航栏按钮颜色
        
        if menytype == MenuType.Articel{
            type = 1
            
        }else if menytype == MenuType.Report{
            type = 2
        }else if menytype == MenuType.Video{
            type = 3
        }
        creatSectionView() 
        loadData()
        
        initTableView()
        self.addChild(commentBarVC)
        
        
        let agreement = stringForKey(key: Constants.ExemptionAgreement)
        if agreement == nil || (agreement?.isLengthEmpty())!{
            let noticeView = UIAlertController.init(title: "温馨提示", message: "本APP只作为学术学习工具，您在做任何医疗决定时必须去专业的医疗机构寻求医生的建议，本APP不提供任何的医疗决定服务", preferredStyle: .alert)
            noticeView.addAction(UIAlertAction.init(title: "已了解", style: .default, handler: { (action) in
                setStringValueForKey(value: "ExemptionAgreement" as String, key: Constants.ExemptionAgreement)

            }))
            self.present(noticeView, animated: true, completion: nil)
        }
 
    }
    
    func loadWebView() {
        
        var myRequest = URLRequest(url: URL.init(string: urlString!)!)
        myRequest.cachePolicy = .useProtocolCachePolicy
        myRequest.timeoutInterval = 60
        self.changeWebView.load(myRequest)
        
    }
    func loadData(){
        if menytype == MenuType.Articel{
            let ArticleDetailParams = HomeAPI.ContentDetailPathAndParams(id:fid!)
            postRequest(pathAndParams: ArticleDetailParams,showHUD: false)
      
        }else if menytype == MenuType.Report{
            
            let requestParams = HomeAPI.ContentDetailPathAndParams(id:fid!)
            postRequest(pathAndParams: requestParams,showHUD: false)
        }else if menytype == MenuType.Video{
            type = 3
        }
    }
    
    func collectData(){
        if menytype == MenuType.Articel{
            let requestlParams = HomeAPI.ContentCollectPathAndParams(id:fid!)
            postRequest(pathAndParams: requestlParams,showHUD: false)
            
        }else if menytype == MenuType.Report{
            let requestParams = HomeAPI.ContentCollectPathAndParams(id:fid!)
            postRequest(pathAndParams: requestParams,showHUD: false)
        }else if menytype == MenuType.Video{
            type = 3
        }
    }
    
    func creatSectionView() {
        
        chatBlankHeadView = (Bundle.main.loadNibNamed("CommentBlankHeadView", owner: nil, options: nil)!.first as! CommentBlankHeadView)
        chatBlankHeadView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 365)
        chatBlankHeadView.delegate = self
        chatBlankHeadView.goodBtn.setImage(UIImage.init(named: "good"), for: .normal)
        
        
        chatHeadView = (Bundle.main.loadNibNamed("ACommentBlankHeadView", owner: nil, options: nil)!.first as! ACommentBlankHeadView)
        chatHeadView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 115)
        chatHeadView.delegate = self
        chatHeadView.goodbtn.setImage(UIImage.init(named: "good"), for: .normal)
    }
    func goodData (){
        
        let requestlParams = HomeAPI.ContentlikePathAndParams(id:fid!)
        postRequest(pathAndParams: requestlParams,showHUD: false)
 
    }
    func pullloadData(){
        
        let commentPathParams = HomeAPI.commentPathAndParams(pageSize:pagenum, page: page,id:fid!)
        postRequest(pathAndParams: commentPathParams,showHUD: false)
    }
    
    func savemessage(message:String){
        var parent_id = 0
        if toCommentModel?.id == nil ||  toCommentModel?.id == -1{
            parent_id = 0
        }else{
            parent_id = toCommentModel?.id ?? 0
        }
        
        let saveCommentParams = HomeAPI.saveCommentPathAndParams(obj_id: fid ?? 0, parent_id: parent_id, content: message)
 
        postRequest(pathAndParams: saveCommentParams,showHUD: false)
        toCommentModel = nil
    }
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        
        var list:[CommentModel]!
        if requestPath == HomeAPI.ContentDetailPath{
            
            if menytype == MenuType.Articel{
                amodel = Mapper<ArticleModel>().map(JSONObject: responseResult.rawValue)
                urlString = amodel?.web_url
                goodCount = amodel!.likes
                if amodel?.is_collect == 0{
                     commentBarVC.barView.followButton.setImage(UIImage.init(named: "xingxing"), for: .normal)
                }else{
                     commentBarVC.barView.followButton.setImage(UIImage.init(named: "xuanzhong"), for: .normal)
                }
                if amodel?.is_like == 0{
                    chatHeadView.goodbtn.setImage(UIImage.init(named: "good"), for: .normal)
                    chatBlankHeadView.goodBtn.setImage(UIImage.init(named: "good"), for: .normal)
                }else{
                    chatHeadView.goodbtn.setImage(UIImage.init(named: "goodSelected"), for: .normal)
                    chatBlankHeadView.goodBtn.setImage(UIImage.init(named: "goodSelected"), for: .normal)
                }
            }else if menytype == MenuType.Report{
                cmodel = Mapper<CaseModel>().map(JSONObject: responseResult.rawValue)
                urlString = cmodel?.web_url
                goodCount = cmodel!.likes
                if cmodel?.is_collect == 0{
                     commentBarVC.barView.followButton.setImage(UIImage.init(named: "xingxing"), for: .normal)
                }else{
                     commentBarVC.barView.followButton.setImage(UIImage.init(named: "xuanzhong"), for: .normal)
                }
                if cmodel?.is_like == 0{
                    chatHeadView.goodbtn.setImage(UIImage.init(named: "good"), for: .normal)
                    chatBlankHeadView.goodBtn.setImage(UIImage.init(named: "good"), for: .normal)
                }else{
                    chatHeadView.goodbtn.setImage(UIImage.init(named: "goodSelected"), for: .normal)
                    chatBlankHeadView.goodBtn.setImage(UIImage.init(named: "goodSelected"), for: .normal)
                }
            }
            loadWebView()
            chatHeadView.goodLabel.text = "点赞数" + "\(goodCount)"
            chatBlankHeadView.goodCountlabel.text = "点赞数" + "\(goodCount)"
            return
        }
        else if requestPath == HomeAPI.saveCommentPath{
            showOnlyTextHUD(text: "发送成功")
            commentModelList.removeAll()
            page = 1
            selectedSection = 0
            pullloadData()
            if toCommentModel == nil {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section:0), at: .bottom, animated: true)
            }
            return
        }
        else if requestPath == HomeAPI.commentPath{
            list = getArrayFromJsonByArrayName(arrayName: "list", content:  responseResult)
            commentCount = responseResult["comment_count"].intValue
            if list.count < 10 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            for cModel in list {
                var tempList = [CommentModel]()
                tempList.append(cModel)
                if cModel.child_list.count != 0 {
                    for subModel in cModel.child_list {
                        tempList.append(subModel)
                    }
                }
                commentModelList.append(tempList)
            }
           
            if toCommentModel == nil {
                selectedSection = 0
            }
            self.tableView.reloadData()
           
 
        }
        else if requestPath == HomeAPI.ContentCollectPath{
            let operate = responseResult["collect_type"].intValue
            if operate == 0{
                showOnlyTextHUD(text: "取消收藏成功")
                commentBarVC.barView.followButton.setImage(UIImage.init(named: "xingxing"), for: .normal)
             }else{
                showOnlyTextHUD(text: "收藏成功")
                commentBarVC.barView.followButton.setImage(UIImage.init(named: "xuanzhong"), for: .normal)
            }
        }
        else if requestPath == HomeAPI.ContentlikePath{
                 let operate = responseResult["like_type"].intValue
                 if operate == 0{
                     //goodSelected
                     showOnlyTextHUD(text: "取消点赞")
                     chatHeadView.goodbtn.setImage(UIImage.init(named: "good"), for: .normal)
                     chatBlankHeadView.goodBtn.setImage(UIImage.init(named: "good"), for: .normal)
                     chatHeadView.goodLabel.text = "点赞数" + "\(goodCount - 1)"
                     chatBlankHeadView.goodCountlabel.text = "点赞数" + "\(goodCount - 1)"
                     goodCount = goodCount - 1
                 }else{
                     showOnlyTextHUD(text: "点赞成功")
                     chatHeadView.goodbtn.setImage(UIImage.init(named: "goodSelected"), for: .normal)
                     chatBlankHeadView.goodBtn.setImage(UIImage.init(named: "goodSelected"), for: .normal)
                     
                     chatHeadView.goodLabel.text = "点赞数" + "\(goodCount + 1)"
                     chatBlankHeadView.goodCountlabel.text = "点赞数" + "\(goodCount + 1)"
                     goodCount = goodCount + 1
                 }
                 
        }
 
        commentBarVC.barView.countLabel.text = "\(commentCount)"
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - 懒加载
    
    func initTableView(){
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 110;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNibWithTableViewCellName(name: reCommentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: CommentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: commentPlacCell.nameOfClass)
        
        //  let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        //  tableView.mj_header = addressHeadRefresh
        //  tableView.mj_header?.beginRefreshing()
        // let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
        
        //暂时不加分页
        // tableView.mj_footer = footerRefresh
        //tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.commentBarVC.view.snp.top)
        }
    }
    
    @objc func pullRefreshList() {
         page = page + 1
         self.pullloadData()
     }
    lazy var changeWebView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        //初始化偏好设置属性：preferences
        webConfiguration.preferences = WKPreferences()
        //是否支持JavaScript
        webConfiguration.preferences.javaScriptEnabled = true
        //不通过用户交互，是否可以打开窗口
       // webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        let webFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 0)
        let webView = WKWebView(frame: webFrame, configuration: webConfiguration)
        // webView.backgroundColor = UIColor.blue
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.navigationDelegate = self
        
        
        return webView
    }()
    
    
    var isLogControllerView = false
      
      override func pushLoginController(){
          let controller = UIStoryboard.getNewLoginController()
          controller.modalPresentationStyle = .fullScreen
          
          controller.reloadLogin = {[weak self] () -> Void in
              self!.isLogControllerView = false
              
          }
          self.present(controller, animated: true, completion: nil)
      }
}
extension ArcticleDetailController: WKNavigationDelegate {
    
    // 监听网页加载进度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DialogueUtils.showWithStatus("详情加载")
     }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
     }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DialogueUtils.dismiss()
        pullloadData()
        
        webIsLoad = true
 
 
        let javascript = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);"
        webView.evaluateJavaScript(javascript, completionHandler: nil)
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
        
        var webheight = 0.0

        // 获取内容实际高度
        self.changeWebView .evaluateJavaScript("document.body.scrollHeight") { [unowned self] (result, error) in
            
            if let tempHeight: Double = result as? Double {
                webheight = tempHeight
             }
            DispatchQueue.main.async { [unowned self] in
                var tempFrame: CGRect = self.changeWebView.frame
                tempFrame.size.height = CGFloat(webheight)
                tempFrame.size.width = CGFloat(screenWidth)
                self.changeWebView.frame = tempFrame
                self.tableView.tableHeaderView = self.changeWebView
                self.tableView.reloadData()
                //                self.bgScrollView.contentSize = CGSize(width: self.bgScrollView.frame.size.width, height: self.changeWebView.frame.size.height)
            }
        }
    }
    
    
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        let alertView = UIAlertController.init(title: "提示", message: "加载失败", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title:"确定", style: .default) { okAction in
            _=self.navigationController?.popViewController(animated: true)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    // MARK: 重置barView的位置
    func resetChatBarFrame() {

        commentBarVC.resetKeyboard()
        UIApplication.shared.keyWindow?.endEditing(true)
        commentBarVC.view.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom)
        }
        UIView.animate(withDuration: kKeyboardChangeFrameTime, animations: {
            self.view.layoutIfNeeded()
        })
    }
 
}
extension ArcticleDetailController:ChatMsgControllerDelegate {
    func avterButtonClick() {
        
    }
    
    func chatMsgVCWillBeginDragging(chatMsgVC: ChatMsgController){
        // 还原barView的位置
        //resetChatBarFrame()
    }
}
extension ArcticleDetailController:CommentBarControllerDelegate{
    func commentCollect() {
        
        if !currentIsLogin() && isLogControllerView == false {
            isLogControllerView = true
            self.pushLoginController()
            return
        }
        self.collectData()
    }
    
    func sendMessage(messge: String) {
        if (messge.hasEmoji()) {
            showOnlyTextHUD(text: "不支持发送表情")
            return
            // message = message!.disable_emoji(text: message! as NSString)
        }
        
        if (messge.containsEmoji()) {
            showOnlyTextHUD(text: "不支持发送表情")
            return
            // message = message!.disable_emoji(text: message! as NSString)
        }
        if messge.isEmptyStr()  {
            showOnlyTextHUD(text: "评论内容不能为空")
            return
        }
        self.savemessage(message: messge)
        resetChatBarFrame()
    }
    
    func forLoginVC() {
           if !currentIsLogin() && isLogControllerView == false {
               isLogControllerView = true
               self.pushLoginController()
               return
           }
    }
 
    
    func commentBarUpdateHeight(height: CGFloat) {
        commentBarVC.view.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
    func commentBarVC(commentBarVC: CommentBarController, didChageChatBoxBottomDistance distance: CGFloat) {
        
       if !currentIsLogin()  {
            return
        }
        commentBarVC.view.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-distance)
        }
        UIView.animate(withDuration: kKeyboardChangeFrameTime, animations: {
            self.view.layoutIfNeeded()
        })
        self.view.layoutIfNeeded()
        if commentModelList.count != 0 && (toCommentModel == nil ||  toCommentModel?.id == -1){
            selectedSection = commentModelList.count - 1
        }
        self.tableView.scrollToRow(at: IndexPath(row: 0, section:selectedSection), at: .bottom, animated: true)
    }
    
}
extension ArcticleDetailController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if commentModelList.count == 0{
            return 1
        }else{
            return commentModelList.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if commentModelList.count == 0{
            return 1
        }else{
            return commentModelList[section].count
        }
        //   tableView.tableViewDisplayWithMsg(message: "请稍候", rowCount: commentModelList.count ,isdisplay: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = indexPath.section
        let row = indexPath.row
        
        if commentModelList.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentPlacCell", for: indexPath) as! commentPlacCell
            return cell
        }else{
            
            let modelList = commentModelList[section]
            
            if (modelList[row].parent_id) == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
                cell.selectionStyle = .none
                cell.sectoin = indexPath.section
                cell.model = modelList[row]
                cell.configModel()
                cell.delegeta = self
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "reCommentCell", for: indexPath) as! reCommentCell
                cell.selectionStyle = .none
                cell.model = modelList[row]
                cell.configModel()
                return cell
            }
        }
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if webIsLoad {
                if commentModelList.count == 0 {
                    
                    return chatBlankHeadView
                }else{
                    
                    return chatHeadView
                }
            }else{
                return UIView()
            }
        }else{
            return UIView()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if commentModelList.count == 0{
                return 365
            }else{
                return 100
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        resetChatBarFrame()
    }
}

extension ArcticleDetailController:CommentCellDelegate {
    func complainActiion(cmodel: CommentModel) {
 
        if !currentIsLogin() && isLogControllerView == false {
            isLogControllerView = true
            self.pushLoginController()
            return
        }
        
        
        let controller = UIStoryboard.getComplainTypeController()
        controller.model = cmodel
        controller.complainSuccess = {[weak self] () -> Void in
            self!.showOnlyTextHUD(text: "举报成功")
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    func commentACtion(cmodel: CommentModel, section: Int) {
         self.selectedSection = section
         toCommentModel = cmodel
         commentBarVC.barView.inputTextView.becomeFirstResponder()
    }
    
    
}
extension ArcticleDetailController:CommentBlankHeadViewDelegate {
    func goodBtnAction() {
        if !currentIsLogin() && isLogControllerView == false {
            isLogControllerView = true
            self.pushLoginController()
            return
        }
        
        self.goodData ()
    }
    
    
    
}
extension ArcticleDetailController:ACommentBlankHeadViewDelegate {
    func goodLBtnAction() {
        if !currentIsLogin() && isLogControllerView == false {
            isLogControllerView = true
            self.pushLoginController()
            return
        }

        self.goodData ()
    }



}
