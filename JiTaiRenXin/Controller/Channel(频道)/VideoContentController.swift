//
//  VideoContentController.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/30.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import ObjectMapper
import SwiftyJSON
import MJRefresh


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
    var vmodel = videoModel()
    var tableView:UITableView!
    var headView:UIView?
    var chatHeadView:ACommentBlankHeadView!
    var chatBlankHeadView:CommentBlankHeadView!
    
    var titleHeadView:CommentHeadView!
    
    var VideoTitle = ""
    
    var goodCount = 0
    
    var commentCount = 0
    
    var selectedSection = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configPlayer()
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        creatSectionView()
        loadData()
        pullloadData()
        self.addChild(commentBarVC)
        self.view.addSubview(self.containerView)
        initTableView()
        
        let agreement = stringForKey(key: Constants.ExemptionAgreement)
        if agreement == nil || (agreement?.isLengthEmpty())!{
            let noticeView = UIAlertController.init(title: "温馨提示", message: "本APP只作为学术学习工具，您在做任何医疗决定时必须去专业的医疗机构寻求医生的建议，本APP不提供任何的医疗决定服务", preferredStyle: .alert)
            noticeView.addAction(UIAlertAction.init(title: "已了解", style: .default, handler: { (action) in
                setStringValueForKey(value: "ExemptionAgreement" as String, key: Constants.ExemptionAgreement)

            }))
            self.present(noticeView, animated: true, completion: nil)
        }
        
    }
    func loadData(){
        
        let requestParams = HomeAPI.ContentDetailPathAndParams(id:fid!)
        postRequest(pathAndParams: requestParams,showHUD: false)
    }
    func pullloadData(){
        
        let commentPathParams = HomeAPI.commentPathAndParams(pageSize:pagenum, page: page,id:fid!)
        postRequest(pathAndParams: commentPathParams,showHUD: true)
    }
    
    
    func collectData(){
        let requestlParams = HomeAPI.ContentCollectPathAndParams(id:fid!)
        postRequest(pathAndParams: requestlParams,showHUD: false)
    }
    
    //
    func goodData (){
        let pathAndParams = HomeAPI.ContentlikePathAndParams(id: fid!)
        postRequest(pathAndParams: pathAndParams,showHUD: false)
        
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
        commentModelList.removeAll()
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
        self.containerView.frame = CGRect.init(x: 0, y: -44, width: screenWidth, height: screenWidth*9/16)
        
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
        
        //  let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        //  tableView.mj_header = addressHeadRefresh
        //  tableView.mj_header?.beginRefreshing()
        // let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
        
        //暂时不加分页
        // tableView.mj_footer = footerRefresh
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
    
    
    func creatHeadView() -> UIView {
        titleHeadView = Bundle.main.loadNibNamed("CommentHeadView", owner: nil, options: nil)!.first as? CommentHeadView
        titleHeadView!.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 50)
        titleHeadView.delegate = self
        //chatHeadView.goodBtn.setImage(UIImage.init(named: "good"), for: .normal)
        //chatHeadView.backgroundColor = UIColor.yellow
        // self.view.addSubview(self.titleHeadView)
        
        let headBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 50))
        headBgView.addSubview(titleHeadView!)
        return headBgView
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
        
        //让导航栏透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.player.isViewControllerDisappear = false
        self.player.playTheIndex(0)
        
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.player.isViewControllerDisappear = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: ZYJColor.main), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: ZYJColor.main)
        
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
            
        }else if requestPath == HomeAPI.ContentDetailPath{
            vmodel = Mapper<videoModel>().map(JSONObject: responseResult.rawValue)
            
            let strUrl = vmodel!.videoInfoModel?.video_url.urlEncoded()
            guard let Url = URL.init(string:strUrl!) else { return }
            
            assetURLs.append(Url)
            self.player.assetURLs = self.assetURLs;
            self.playClick()
            titleHeadView.videoTitlelabel.text = vmodel?.title
            titleHeadView.sourceBtn.titleLabel?.text = vmodel?.source
            titleHeadView.sourceBtn.setTitle(vmodel?.source, for: .normal)
            goodCount = vmodel!.likes
            chatHeadView.goodLabel.text = "点赞数" + "\(goodCount)"
            chatBlankHeadView.goodCountlabel.text = "点赞数" + "\(goodCount)"
            
            if vmodel?.is_collect == 0{
                commentBarVC.barView.followButton.setImage(UIImage.init(named: "xingxing"), for: .normal)
            }else{
                commentBarVC.barView.followButton.setImage(UIImage.init(named: "xuanzhong"), for: .normal)
            }
            
            if vmodel?.is_like == 0{
                chatHeadView.goodbtn.setImage(UIImage.init(named: "good"), for: .normal)
                chatBlankHeadView.goodBtn.setImage(UIImage.init(named: "good"), for: .normal)
            }else{
                chatHeadView.goodbtn.setImage(UIImage.init(named: "goodSelected"), for: .normal)
                chatBlankHeadView.goodBtn.setImage(UIImage.init(named: "goodSelected"), for: .normal)
            }
            return
            
        }else if requestPath == HomeAPI.saveCommentPath{
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
        
        commentBarVC.barView.countLabel.text = "\(commentModelList.count)"
        tableView.reloadData()
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
        resetChatBarFrame()
    }
    
    
}
extension VideoContentController:CommentBarControllerDelegate{
    func commentCollect() {
        
        if !currentIsLogin() && isLogControllerView == false {
            isLogControllerView = true
            self.pushLoginController()
            return
        }
        self.collectData()
    }
    
    func forLoginVC() {
        if !currentIsLogin() && isLogControllerView == false {
            isLogControllerView = true
            self.pushLoginController()
            return
        }
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
        
        if messge.isEmptyStr() {
            showOnlyTextHUD(text: "评论内容不能为空")
            return
        }
        self.savemessage(message: messge)
        resetChatBarFrame()
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
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
}
extension VideoContentController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //   tableView.tableViewDisplayWithMsg(message: "请稍候", rowCount: commentModelList.count ,isdisplay: true)
        if commentModelList.count == 0{
            return 1
        }else{
            return commentModelList.count
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
        if commentModelList.count == 0{

            return chatBlankHeadView
        }else{

            return chatHeadView
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if commentModelList.count == 0{
            return 365
        }else{
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        resetChatBarFrame()
    }
}
extension VideoContentController:CommentCellDelegate {
 
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
    
    func commentACtion(cmodel:CommentModel,section:Int) {
        
        toCommentModel = cmodel
        commentBarVC.barView.inputTextView.becomeFirstResponder()
    }
    
}


extension VideoContentController:CommentBlankHeadViewDelegate {
    func goodBtnAction() {
        if !currentIsLogin() && isLogControllerView == false {
            isLogControllerView = true
            self.pushLoginController()
            return
        }
        
        self.goodData ()
    }
    
    
    
}
extension VideoContentController:ACommentBlankHeadViewDelegate {
    func goodLBtnAction() {
        if !currentIsLogin() && isLogControllerView == false {
            isLogControllerView = true
            self.pushLoginController()
            return
        }
        
        self.goodData ()
    }
 
 }
extension VideoContentController:CommentHeadViewDelegate {
    func sourceBtnAction() {
    
        let controller = NewNotifyDetailController()
        controller.urlString = vmodel?.videoInfoModel!.video_url ?? ""
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
 
 }
