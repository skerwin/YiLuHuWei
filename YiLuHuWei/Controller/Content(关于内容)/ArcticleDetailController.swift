//
//  ArcticleDetailController.swift
//  YiLuHuWei
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
    
    var amodel = AVCModel()
    
    var chatHeadView:CommentHeadView!
    
    var chatBlankHeadView:CommentBlankHeadView!
    
    var goodCount = 0
    
    var commentCount = 0
    
    var webIsLoad = false
    
    var selectedSection = 0
    
    var isCases = false
    
    
    var rightBarButton:UIButton!
    
    var ybMenu:YBPopupMenu!
    
    var cYbMenu:YBPopupMenu!
    
    var reportModel = CommentModel()
    
    var isToNewWeb = false
    
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
        
        if isCases{
            self.title = "病历详情"
        }else{
            self.title = "文章详情"
        }
        super.viewDidLoad()
 
        creatSectionView()
        createRightNavItem()
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
        
        var myRequest = URLRequest(url: URL.init(string: (urlString?.urlEncoded())!)!)
        myRequest.cachePolicy = .useProtocolCachePolicy
        myRequest.timeoutInterval = 60
        self.changeWebView.load(myRequest)
        
    }
    
    func loadData(){
        if isCases{
            let casesDetailParams = HomeAPI.CasesShowPathAndParams(id:fid!)
            postRequest(pathAndParams: casesDetailParams,showHUD: false)
            
        }else{
            let ArticleDetailParams = HomeAPI.ArticleShowPathAndParams(id:fid!)
            postRequest(pathAndParams: ArticleDetailParams,showHUD: false)
        }
 
    }
    
    func goodData (){
        let requestlParams = HomeAPI.ContentlikePathAndParams(id:fid!,table_name: amodel!.table_name)
        postRequest(pathAndParams: requestlParams,showHUD: false)
    }
    
    func collectData(){
     
        let requestlParams = HomeAPI.ContentCollectPathAndParams(mode: amodel!)
        postRequest(pathAndParams: requestlParams,showHUD: false)
    }
    
    func commentBlockAction(cmodel: CommentModel){
        let requestlParams = HomeAPI.shieldPathAndParams(id: cmodel.id )
        postRequest(pathAndParams: requestlParams,showHUD: false)
    }
    
    
    func creatSectionView() {
        
        chatBlankHeadView = (Bundle.main.loadNibNamed("CommentBlankHeadView", owner: nil, options: nil)!.first as! CommentBlankHeadView)
        chatBlankHeadView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 365)
 
        chatHeadView = (Bundle.main.loadNibNamed("CommentHeadView", owner: nil, options: nil)!.first as! CommentHeadView)
        chatHeadView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 55)
    }
    
    func createRightNavItem() {
        
        rightBarButton = UIButton.init()
        rightBarButton.frame = CGRect.init(x: 0, y: screenWidth - 50, width: 44, height: 44)
        rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
        rightBarButton.setImage(UIImage.init(named: "gengduo"), for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
 
    }
    @objc func rightNavBtnClic(_ btn: UIButton){
   
        
        if amodel!.id == 0{
            return
        }
        if amodel?.is_collect == 0{
            if amodel?.is_report == 0{
                YBPopupMenu.showRely(on: btn, titles: ["分享","收藏","举报"], icons: ["tipfengxiang","tipNOshoucang","tipNOjubao"], menuWidth: 115, delegate: self)
            }else{
                YBPopupMenu.showRely(on: btn, titles: ["分享","收藏","已举报"], icons: ["tipfengxiang","tipNOshoucang","tipjubao"], menuWidth: 115, delegate: self)
            }
        }else{
            if amodel?.is_report == 0{
                YBPopupMenu.showRely(on: btn, titles: ["分享","已收藏","举报"], icons: ["tipfengxiang","tipshoucang","tipNOjubao"], menuWidth: 115, delegate: self)
            }else{
                YBPopupMenu.showRely(on: btn, titles: ["分享","已收藏","已举报"], icons: ["tipfengxiang","tipshoucang","tipjubao"], menuWidth: 115, delegate: self)
            }
        }
    
    }
    func pullloadData(){
        
        let commentPathParams = HomeAPI.commentPathAndParams(limit: pagenum, page: page, object_id: fid!, table_name: amodel!.table_name, order_type: 0)
        postRequest(pathAndParams: commentPathParams,showHUD: false)
    }
    
    func savemessage(message:String){
        var parent_id = 0
        var to_user_id = 0
        if toCommentModel?.id == nil ||  toCommentModel?.id == 0{
            parent_id = 0
            to_user_id =  amodel!.user_id
        }else{
            parent_id = toCommentModel?.id ?? 0
            to_user_id = toCommentModel?.users!.id ?? 0
        }
        
        let saveCommentParams = HomeAPI.saveCommentPathAndParams(object_id: fid!, table_name: amodel!.table_name, url: "", parent_id: parent_id, to_user_id: to_user_id, content: message)
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
        if requestPath == HomeAPI.ArticleShowPath || requestPath == HomeAPI.CasesShowPath{
            amodel = Mapper<AVCModel>().map(JSONObject: responseResult.rawValue)
            if amodel?.id == 0 || amodel == nil{
                showOnlyTextHUD(text: "此文章或病例不存在")
                return
            }
            if amodel?.table_name == ""{
                if isCases {
                    amodel?.table_name = "cases"
                }else{
                    amodel?.table_name = "portal_post"
                }
            }
 
            if amodel?.title == "" {
                let title = amodel!.post_title
                amodel?.title = title
            }
            
            if amodel?.title == "" {
                let title = amodel!.post_title
                amodel?.title = title
            }
            
            urlString = amodel?.url
            goodCount = amodel!.post_like
            if amodel!.comment_count > 999{
                commentCount = 999
            }else{
                commentCount = amodel!.comment_count
            }
            commentBarVC.barView.countLabel.text = "\(goodCount)"
            if amodel?.is_like == 0{
                commentBarVC.barView.commonButton.setImage(UIImage.init(named: "weidianzan"), for: .normal)
            }else{
                commentBarVC.barView.commonButton.setImage(UIImage.init(named: "dianzanAct"), for: .normal)
            }
            chatHeadView.commentCount.text = "评论专区(" + "\(commentCount)" + ")"
            //commentCount
            loadWebView()
            
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
            
        }
        else if requestPath == HomeAPI.commentPath{
            list = getArrayFromJsonByArrayName(arrayName: "list", content:  responseResult)
            //commentCount = responseResult["count"].intValue
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
           
            chatHeadView.commentCount.text = "评论专区(" + "\(commentCount)" + ")"
            self.tableView.reloadData()
 
        }
        else if requestPath == HomeAPI.ContentCollectPath{
            let operate = responseResult["hand_status"].intValue
            amodel?.is_collect = operate
            if operate == 0{
                if amodel?.is_report == 0{
                    self.ybMenu.refreshIcon(["tipfengxiang","tipNOshoucang","tipNOjubao"], titles: ["分享","收藏","举报"])
                }else{
                    self.ybMenu.refreshIcon(["tipfengxiang","tipNOshoucang","tipjubao"], titles: ["分享","收藏","已举报"])
                }
                showOnlyTextHUD(text: "取消收藏成功")
                
              }else{
                if amodel?.is_report == 0{
                    self.ybMenu.refreshIcon(["tipfengxiang","tipshoucang","tipNOjubao"], titles: ["分享","已收藏","举报"])
                }else{
                    self.ybMenu.refreshIcon(["tipfengxiang","tipshoucang","tipjubao"], titles: ["分享","已收藏","已举报"])
                }
                showOnlyTextHUD(text: "收藏成功")
             }
        }
        else if requestPath == HomeAPI.ContentlikePath{
                 let operate = responseResult["hand_status"].intValue
                 goodCount = responseResult["post_like"].intValue
                 if operate == 0{
                     //goodSelected
                     showOnlyTextHUD(text: "取消点赞")
                     commentBarVC.barView.commonButton.setImage(UIImage.init(named: "weidianzan"), for: .normal)
                     commentBarVC.barView.countLabel.text = "\(goodCount)"

                 }else{
                     showOnlyTextHUD(text: "点赞成功")
                     commentBarVC.barView.commonButton.setImage(UIImage.init(named: "dianzanAct"), for: .normal)
                     commentBarVC.barView.countLabel.text = "\(goodCount)"
                 }
                 
        }  else if requestPath == HomeAPI.shieldPath{
            showOnlyTextHUD(text: "已屏蔽")
            commentModelList.removeAll()
            page = 1
            selectedSection = 0
            pullloadData()
            if toCommentModel == nil {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section:0), at: .bottom, animated: true)
            }
            
        }
 
         tableView.reloadData()
    }
 
    lazy var shareView: ShareView = {
        
        let sv = ShareView.getFactoryShareView { (platform, type) in
            self.shareInfoWithPlatform(platform: platform)
            
        }
        self.view.addSubview(sv!)
        return sv!
 
    }()

    func shareInfoWithPlatform(platform:JSHAREPlatform){
        let message = JSHAREMessage.init()
       // let dateString = DateUtils.dateToDateString(Date.init(), dateFormat: "yyy-MM-dd HH:mm:ss")
        message.title = amodel?.title
        
        let imageLogo = UIImage.init(named: "logo")
       
        if isCases {
            message.text = amodel?.content.html2String
            message.image = imageLogo?.pngData()
        }else{
            message.text = amodel?.post_excerpt.html2String
            if amodel?.show_type != 0{
                let imageURL = amodel?.thumbnail
                do {
                    let imageData: Data? = try Data(contentsOf: URL(string: imageURL ?? "")!)
                    message.image = imageData
                } catch {
                    message.image = imageLogo?.pngData()
                    print(error)
                }
              }else{
                message.image = imageLogo?.pngData()
            }
        }

        message.platform = platform
        message.mediaType = .link;
        message.url = amodel?.url
      
        var tipString = ""
        JSHAREService.share(message) { (state, error) in
            if state == JSHAREState.success{
                if platform == .wechatSession || platform == .wechatTimeLine{
                    tipString = "分享成功";
                }else{
                    tipString = "收藏成功";
                }
                
                
            }else if state == JSHAREState.fail{
                if platform == .wechatSession || platform == .wechatTimeLine{
                    tipString = "分享失败";
                    
                }else{
                    tipString = "收藏失败";
                }
                
            }else if state == JSHAREState.cancel{
                if platform == .wechatSession || platform == .wechatTimeLine{
                    tipString = "分享取消";
                }else{
                    tipString = "收藏取消";
                   
                }
                
            } else if state == JSHAREState.unknown{
                tipString = "Unknown";
            }else{
                tipString = "Unknown";
            }
             DispatchQueue.main.async(execute: {
                
                let tipView = UIAlertController.init(title: "", message: tipString, preferredStyle: .alert)
                tipView.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
     
                }))
                self.present(tipView, animated: true, completion: nil)

            })
        }
 
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
 
         let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
        //暂时不加分页
         tableView.mj_footer = footerRefresh
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
         let urlstr = navigationAction.request.url?.absoluteString
        if urlstr != urlString{
            commentModelList.removeAll()
            isToNewWeb = true
         
        }else{
            isToNewWeb = false
        }
        decisionHandler(.allow)
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

        if isToNewWeb {
            commentBarVC.willMove(toParent: nil)
            commentBarVC.barView.removeFromSuperview()
            commentBarVC.removeFromParent()
            tableView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self.view)
                make.top.equalTo(self.view.snp.top)
                make.bottom.equalTo(self.view.snp.bottom)
            }
            self.navigationItem.rightBarButtonItem = nil
            self.tableView.reloadData()
            return
        }
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
    func commentBarGood() {
        if !currentIsLogin() && isLogControllerView == false {
            isLogControllerView = true
            self.pushLoginController()
            return
        }
        self.goodData ()
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
                cell.delegeta = self
                return cell
            }
        }
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if webIsLoad {
                if commentModelList.count == 0 {
                    if isToNewWeb {
                        return UIView()
                    }
                    return chatBlankHeadView
                    
                }else{
                    if isToNewWeb {
                        return UIView()
                    }
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
                return 55
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
 
    func complainActiion(cmodel: CommentModel,onView:UIButton) {
        if !currentIsLogin() && isLogControllerView == false {
            isLogControllerView = true
            self.pushLoginController()
            return
        }
        reportModel = cmodel
        cYbMenu = YBPopupMenu.init()
        cYbMenu.showRely(on: onView, titles:  ["屏蔽","举报"], icons: nil, menuWidth: 65) { (popupMenu) in
            popupMenu!.delegate = self;
            popupMenu?.type = .dark
            popupMenu!.priorityDirection = .right;
            popupMenu!.arrowDirection = .right;
            popupMenu!.arrowPosition = 40;
         }
     }
    
    func commentACtion(cmodel: CommentModel, section: Int) {
         self.selectedSection = section
         toCommentModel = cmodel
         commentBarVC.barView.inputTextView.becomeFirstResponder()
    }
}
extension ArcticleDetailController:ReCommentCellDelegate {
 
    func reComplainActiion(cmodel: CommentModel,onView:UIButton) {
        if !currentIsLogin() && isLogControllerView == false {
            isLogControllerView = true
            self.pushLoginController()
            return
        }
        reportModel = cmodel
        cYbMenu = YBPopupMenu.init()
        cYbMenu.showRely(on: onView, titles:  ["屏蔽","举报"], icons: nil, menuWidth: 65) { (popupMenu) in
            popupMenu!.delegate = self;
            popupMenu?.type = .dark
            popupMenu!.priorityDirection = .right;
            popupMenu!.arrowDirection = .right;
            popupMenu!.arrowPosition = 40;
         }
     }
    
}


extension ArcticleDetailController:YBPopupMenuDelegate{
    func ybPopupMenuDidSelected(at index: Int, ybPopupMenu: YBPopupMenu!) {
        if ybPopupMenu == self.cYbMenu {
            if index == 0{
                
                if !currentIsLogin() && isLogControllerView == false {
                    isLogControllerView = true
                    self.pushLoginController()
                    return
                }
                
                let noticeView = UIAlertController.init(title: "提示", message: "您确定要屏蔽此条评论么", preferredStyle: .alert)
                
                
                noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                    self.commentBlockAction(cmodel: self.reportModel!)
                }))
                
                noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                    
                }))
                self.present(noticeView, animated: true, completion: nil)
 
                
            }else{
                if !currentIsLogin() && isLogControllerView == false {
                    isLogControllerView = true
                    self.pushLoginController()
                    return
                }
                if self.reportModel?.is_report == 1 {
                    showOnlyTextHUD(text: "你已举报过该条评论")
                    return
                }
                
                let controller = UIStoryboard.getComplainTypeController()
                controller.model = self.reportModel
                controller.complainSuccess = {[weak self] () -> Void in
                    self?.amodel?.is_report = 1
                    self!.showOnlyTextHUD(text: "举报成功")
                
                }
                self.present(controller, animated: true, completion: nil)
            }
        }else{
                        
            self.ybMenu = ybPopupMenu
            if index == 1{

               if !currentIsLogin() && isLogControllerView == false {
                   isLogControllerView = true
                   self.pushLoginController()
                   return
               }
               self.collectData()

           }else if index == 2 {
            
              if !currentIsLogin() && isLogControllerView == false {
                isLogControllerView = true
                self.pushLoginController()
                return
              }
               
               if self.amodel?.is_report == 1 {
                   self.showOnlyTextHUD(text: "请在个人中心查看")
                   return
               }
               
               let controller = UIStoryboard.getComplainTypeController()
               controller.amodel = self.amodel
               controller.complainSuccess = {[weak self] () -> Void in
                   self?.amodel?.is_report = 1
                   self!.showOnlyTextHUD(text: "举报成功")
               
               }
               self.present(controller, animated: true, completion: nil)
           }else{
               if !currentIsLogin() && isLogControllerView == false {
                 isLogControllerView = true
                 self.pushLoginController()
                 return
               }
                self.shareView.show(withContentType: JSHAREMediaType(rawValue: 3)!)
           }
        }
      
        
    }
 
}
