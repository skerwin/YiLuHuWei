//
//  VideoContentController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/07/30.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import ObjectMapper
import SwiftyJSON
import MJRefresh
import Reachability


//let kVideoCover = "https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

class VideoContentController: BaseViewController,Requestable {
    
    var player:ZFPlayerController!
    var containerView:UIImageView!
    var controlView:ZFPlayerControlView!
    var playBtn:UIButton!  //暂时不用
    
    var assetURLs = [URL]()
    var fid:Int?   //这是外级id，可能是文章id或者病例ID
    var commentModelList = [Array<CommentModel>]()
    var toCommentModel:CommentModel?
    var vmodel = AVCModel()
    var tableView:UITableView!
    var headView:UIView?
    var chatHeadView:CommentHeadView!
    var chatBlankHeadView:CommentBlankHeadView!
    
    var titleHeadView:CommentVideoHeadView!
    
    var VideoTitle = ""
    
    var goodCount = 0
    
    var commentCount = 0
    
    var selectedSection = 0
    
    
    var rightBarButton:UIButton!
    
    var ybMenu:YBPopupMenu!
    
    var cYbMenu:YBPopupMenu!
    
    var reportModel = CommentModel()
    
    
    var reachability: Reachability!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "视频详情"
        
        configPlayer()
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        creatSectionView()
        loadData()
        self.addChild(commentBarVC)
        self.view.addSubview(self.containerView)
        initTableView()
        createRightNavItem()
        
        checkNetWork()
        
//        let agreement = stringForKey(key: Constants.ExemptionAgreement)
//        if agreement == nil || (agreement?.isLengthEmpty())!{
//            let noticeView = UIAlertController.init(title: "温馨提示", message: "本APP只作为学术学习工具，您在做任何医疗决定时必须去专业的医疗机构寻求医生的建议，本APP不提供任何的医疗决定服务", preferredStyle: .alert)
//            noticeView.addAction(UIAlertAction.init(title: "已了解", style: .default, handler: { (action) in
//                setStringValueForKey(value: "ExemptionAgreement" as String, key: Constants.ExemptionAgreement)
//
//            }))
//            self.present(noticeView, animated: true, completion: nil)
//        }
        
    }
    
    func  checkNetWork(){
        do {
            reachability = try Reachability.init()
        } catch {
            print("Unable to create Reachability")
            return
        }
 
        // 检测网络连接状态
        if reachability.connection == .wifi{
            print("网络连接：wifi")
        }
        else if reachability.connection == .cellular{
            
            let videoNet = stringForKey(key: Constants.videoNetWork)
            if videoNet == nil || (videoNet?.isLengthEmpty())!{
                let noticeView = UIAlertController.init(title: "温馨提示", message: "当前非WiFi环境，是否继续播放", preferredStyle: .alert)
                noticeView.addAction(UIAlertAction.init(title: "退出播放", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                
                noticeView.addAction(UIAlertAction.init(title: "不再提示", style: .cancel, handler: { (action) in
                    setStringValueForKey(value: "videoNetWork" as String, key: Constants.videoNetWork)
                }))
                self.present(noticeView, animated: true, completion: nil)
            }
            
            print("网络连接：数据流量")
        }
        else if reachability.connection == .unavailable{
            print("网络连接：不可用")
        }
        else {
            print("网络连接：不可用")
        }
    }
    func loadData(){
        
        let requestParams = HomeAPI.VideoShowPathAndParams(id:fid!)
        postRequest(pathAndParams: requestParams,showHUD: false)
    }
    func pullloadData(){
        
        let commentPathParams = HomeAPI.commentPathAndParams(limit: pagenum, page: page, object_id: fid!, table_name: vmodel!.table_name, order_type: 0)
        postRequest(pathAndParams: commentPathParams,showHUD: false)
    }
    
    
    func goodData (){
        let requestlParams = HomeAPI.ContentlikePathAndParams(id:fid!,table_name: vmodel!.table_name)
        postRequest(pathAndParams: requestlParams,showHUD: false)
    }
    
    func collectData(){
        
        let requestlParams = HomeAPI.ContentCollectPathAndParams(mode: vmodel!)
        postRequest(pathAndParams: requestlParams,showHUD: false)
    }
    
    func commentBlockAction(cmodel: CommentModel){
        let requestlParams = HomeAPI.shieldPathAndParams(id: cmodel.id )
        postRequest(pathAndParams: requestlParams,showHUD: false)
    }
    
    func createRightNavItem() {
        
        rightBarButton = UIButton.init()
        rightBarButton.frame = CGRect.init(x: 0, y: screenWidth - 50, width: 44, height: 44)
        rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
        rightBarButton.setImage(UIImage.init(named: "gengduo"), for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
        
        
    }
    @objc func rightNavBtnClic(_ btn: UIButton){
        
        if vmodel!.id == 0{
            return
        }
        if vmodel?.is_collect == 0{
            if vmodel?.is_report == 0{
                YBPopupMenu.showRely(on: btn, titles: ["分享","收藏","举报"], icons: ["tipfengxiang","tipNOshoucang","tipNOjubao"], menuWidth: 115, delegate: self)
            }else{
                YBPopupMenu.showRely(on: btn, titles: ["分享","收藏","已举报"], icons: ["tipfengxiang","tipNOshoucang","tipjubao"], menuWidth: 115, delegate: self)
            }
        }else{
            if vmodel?.is_report == 0{
                YBPopupMenu.showRely(on: btn, titles: ["分享","已收藏","举报"], icons: ["tipfengxiang","tipshoucang","tipNOjubao"], menuWidth: 115, delegate: self)
            }else{
                YBPopupMenu.showRely(on: btn, titles: ["分享","已收藏","已举报"], icons: ["tipfengxiang","tipshoucang","tipjubao"], menuWidth: 115, delegate: self)
            }
        }
        
    }
    func savemessage(message:String){
        var parent_id = 0
        var to_user_id = 0
        if toCommentModel?.id == nil ||  toCommentModel?.id == 0{
            parent_id = 0
            to_user_id =  vmodel!.user_id
        }else{
            parent_id = toCommentModel?.id ?? 0
            to_user_id = toCommentModel?.users!.id ?? 0
        }
        
        let saveCommentParams = HomeAPI.saveCommentPathAndParams(object_id: fid!, table_name: vmodel!.table_name, url: "", parent_id: parent_id, to_user_id: to_user_id, content: message)
        postRequest(pathAndParams: saveCommentParams,showHUD: false)
        toCommentModel = nil
        
    }
    
    
    //视频相关部分
    func configPlayer(){
        
        //"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4")!]
        controlView = ZFPlayerControlView.init()
        controlView.fastViewAnimated = true;
        controlView.autoHiddenTimeInterval = 5;
        controlView.autoFadeTimeInterval = 0.5;
        controlView.prepareShowLoading = true;
        controlView.prepareShowControlView = true;
        
        
        playBtn = UIButton.init(type: .custom)
        playBtn.setImage(UIImage.init(named: "new_allPlay_44x44_@2x"), for: .normal)
        playBtn.addTarget(self, action:(#selector(playClick)), for: .touchUpInside)
        
        
        containerView = UIImageView.init()
        containerView.setImageWithURLString("zhanweitu1", placeholder:ZFUtilities.image(with: UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1), size: CGSize.init(width: 1, height: 1)))
        self.containerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenWidth*9/16)
        
        let playerManager = ZFAVPlayerManager.init()
        self.player = ZFPlayerController.player(withPlayerManager: playerManager, containerView: containerView)
        self.player.controlView = self.controlView;
        /// 设置退到后台不播放
        
        self.player.pauseWhenAppResignActive = true;
        self.player.resumePlayRecord = false;
        
    }
    
    
    @objc func playClick(){
        self.player.playTheIndex(0)
        self.controlView.showTitle(VideoTitle, cover: UIImage.init(named: "zhanweitu2"), fullScreenMode: .automatic)
        // self.controlView.showTitle(VideoTitle, coverURLString: kVideoCover, fullScreenMode: .automatic)
    }
    
    
    //评论内容部分
    
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
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = creatHeadView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.containerView.snp.bottom)
            make.bottom.equalTo(self.commentBarVC.view.snp.top)
        }
    }
    @objc func pullRefreshList() {
         page = page + 1
         self.pullloadData()
     }
    
    func creatHeadView() -> UIView {
        titleHeadView = Bundle.main.loadNibNamed("CommentVideoHeadView", owner: nil, options: nil)!.first as? CommentVideoHeadView
        titleHeadView!.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 159)
  
        let headBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 159))
        headBgView.addSubview(titleHeadView!)
        return headBgView
    }
    
    func creatSectionView() {
        
        chatBlankHeadView = (Bundle.main.loadNibNamed("CommentBlankHeadView", owner: nil, options: nil)!.first as! CommentBlankHeadView)
        chatBlankHeadView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 365)
        
        
        chatHeadView = (Bundle.main.loadNibNamed("CommentHeadView", owner: nil, options: nil)!.first as! CommentHeadView)
        chatHeadView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 115)
        
    }
    
    func creatFootView() -> UIView {
        let footBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 3))
        footBgView.backgroundColor = UIColor.groupTableViewBackground
        return footBgView
    }
    // MARK: 输入栏控制器
    lazy var commentBarVC: CommentBarController = { [unowned self] in
        let barVC = CommentBarController()
        self.view.addSubview(barVC.view)
        barVC.view.snp.makeConstraints { (make) in
            make.left.right.width.equalTo(self.view)
            if screenHeight > 667.0 {
                make.bottom.equalTo(self.view.snp.bottom)
            }else{
                make.bottom.equalTo(self.view.snp.bottom)
            }
            
            make.height.equalTo(kChatBarOriginHeight)
        }
        barVC.delegate = self
        return barVC
    }()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: ZYJColor.tableViewBg), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: ZYJColor.tableViewBg)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
        //让导航栏透明
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
        self.player.isViewControllerDisappear = false
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.player.isViewControllerDisappear = true
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: ZYJColor.main), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: ZYJColor.main)
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.player.stop()
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
        
        if requestPath == HomeAPI.commentPath{
            
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
            
        }else if requestPath == HomeAPI.VideoShowPath{
            vmodel = Mapper<AVCModel>().map(JSONObject: responseResult.rawValue)
            
            if vmodel?.table_name == ""{
                vmodel?.table_name = "video_manage"
            }
            pullloadData()
            let strUrl = vmodel!.video_id.urlEncoded()
            guard let Url = URL.init(string:strUrl) else { return }
            
            assetURLs.append(Url)
            self.player.assetURLs = self.assetURLs;
            self.playClick()
            if vmodel?.post_title == "" {
                titleHeadView.videoTitlelabel.text = vmodel?.title
            }else {
                titleHeadView.videoTitlelabel.text = vmodel?.post_title
            }
            if vmodel?.post_excerpt == "" {
                titleHeadView.descLabel.text = vmodel?.post_excerpt
            }else {
                titleHeadView.descLabel.text = vmodel?.excerpt
            }
            titleHeadView.departMentlabel.text = vmodel?.group_name
            goodCount = vmodel!.post_like
            if vmodel!.comment_count > 999{
                commentCount = 999
            }else{
                commentCount = vmodel!.comment_count
            }
            commentBarVC.barView.countLabel.text = "\(goodCount)"
            if vmodel?.is_like == 0{
                commentBarVC.barView.commonButton.setImage(UIImage.init(named: "weidianzan"), for: .normal)
            }else{
                commentBarVC.barView.commonButton.setImage(UIImage.init(named: "dianzanAct"), for: .normal)
            }
            chatHeadView.commentCount.text = "评论专区(" + "\(commentCount)" + ")"
            
        }else if requestPath == HomeAPI.saveCommentPath{
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
            vmodel?.is_collect = operate
            if operate == 0{
                if vmodel?.is_report == 0{
                    self.ybMenu.refreshIcon(["tipfengxiang","tipNOshoucang","tipNOjubao"], titles: ["分享","收藏","举报"])
                }else{
                    self.ybMenu.refreshIcon(["tipfengxiang","tipNOshoucang","tipjubao"], titles: ["分享","收藏","已举报"])
                }
                showOnlyTextHUD(text: "取消收藏成功")
                
            }else{
                if vmodel?.is_report == 0{
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
        message.title = vmodel?.title
       
        if vmodel?.post_excerpt == "" {
            message.text = vmodel?.post_excerpt
        }else {
            message.text = vmodel?.excerpt
        }
        
        message.platform = platform
        message.mediaType = .video;
        message.url = vmodel!.video_id.urlEncoded()
        
        
        let imageLogo = UIImage.init(named: "logo")
//        message.image = imageLogo?.pngData()
        
        
        let imageURL = vmodel?.thumbnail
        do {
            let imageData: Data? = try Data(contentsOf: URL(string: imageURL ?? "")!)
            message.image = imageData
        } catch {
            message.image = imageLogo?.pngData()
            print(error)
        }
        
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
    
    var isLogControllerView = false
    
    override func pushLoginController(){
        let controller = UIStoryboard.getNewLoginController()
        controller.modalPresentationStyle = .fullScreen
        
        controller.reloadLogin = {[weak self] () -> Void in
            self!.isLogControllerView = false
            self?.playClick()
            self?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self?.navigationController?.navigationBar.shadowImage = UIImage()
            self?.navigationController?.navigationBar.isTranslucent = true
            
        }
        self.present(controller, animated: true, completion: nil)
    }
}


extension VideoContentController:ChatMsgControllerDelegate {
    func avterButtonClick() {
        
    }
    
    func chatMsgVCWillBeginDragging(chatMsgVC: ChatMsgController){
        // 还原barView的位置
        //resetChatBarFrame()
    }
}
extension VideoContentController:CommentBarControllerDelegate{
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
extension VideoContentController:UITableViewDataSource,UITableViewDelegate {
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
            if commentModelList.count == 0 {
                
                return chatBlankHeadView
            }else{
                
                return chatHeadView
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

extension VideoContentController:CommentCellDelegate {
    
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
extension VideoContentController:ReCommentCellDelegate {
    
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


extension VideoContentController:YBPopupMenuDelegate{
    func ybPopupMenuDidSelected(at index: Int, ybPopupMenu: YBPopupMenu!) {
        if ybPopupMenu == self.cYbMenu {
            if index == 0{
                
                let noticeView = UIAlertController.init(title: "提示", message: "您确定要屏蔽此条评论么", preferredStyle: .alert)
                
                
                noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                    self.commentBlockAction(cmodel: self.reportModel!)
                }))
                
                noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                    
                }))
                self.present(noticeView, animated: true, completion: nil)
                
                
                
            }else{
                let controller = UIStoryboard.getComplainTypeController()
                controller.model = self.reportModel
                controller.complainSuccess = {[weak self] () -> Void in
                    self?.vmodel?.is_report = 1
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
                
                if self.vmodel?.is_report == 1 {
                    self.showOnlyTextHUD(text: "请在个人中心查看")
                    return
                }
                
                let controller = UIStoryboard.getComplainTypeController()
                controller.amodel = self.vmodel
                controller.complainSuccess = {[weak self] () -> Void in
                    self?.vmodel?.is_report = 1
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
