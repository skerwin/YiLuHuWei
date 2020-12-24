//
//  ChatMsgController.swift
//  BossJob
//
//  Created by zhaoyuanjing on 2017/11/09.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import SnapKit



protocol ChatMsgControllerDelegate: class {
    func chatMsgVCWillBeginDragging(chatMsgVC: ChatMsgController)
    func avterButtonClick()
}

class ChatMsgController: BaseViewController {

     // MARK:- 属性
    // MARK: 用户模型
     weak var delegate: ChatMsgControllerDelegate?
    
 
 
    var headView:UIView?
    
    var startNum = 100
    var roomNum = 1
    
    var tableView:UITableView!
    
    var chatHeadView:CommentHeadView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // initData()
       //  creatHeadView()
        createUI()
 
        // Do any additional setup after loading the view.
    }
    
    
//    func creatHeadView() {
//        headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 153))
//        let chatHeadView = Bundle.main.loadNibNamed("ChatHeadView", owner: nil, options: nil)!.first as! ChatHeadView
//        chatHeadView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 153)
//        let choosedRole = stringForKey(key: Constants.userType)
//        if  choosedRole == "0"{
//            chatHeadView.configView(model: superModel!)
//        }else{
//            chatHeadView.configBossView(model: bossModel!)
//        }
//
//        headView!.addSubview(chatHeadView)
//        addGestureRecognizerToView(view: headView!, target: self, actionName: "tableHeadViewAction")
//    }

    func tableHeadViewAction() {
        delegate?.avterButtonClick()
    }
    
    func createUI(){
        // 添加tableView
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = creatHeadView()
        tableView.estimatedRowHeight = 57.5
        // 注册cell
        //tableView.register(ChatTextCell.classForCoder(), forCellReuseIdentifier: ChatTextCell.nameOfClass)
        
         self.view.addSubview(tableView)
              tableView.snp.makeConstraints { (make) in
              make.left.right.bottom.equalTo(self.view)
              make.top.equalTo(self.view.snp.top).offset(0)
        }
 
      //  let addressHeadRefresh = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
      //  tableView.mj_header = addressHeadRefresh
        //        self.tableView.mj_header.endRefreshing()
    }
    
    func creatHeadView() -> UIView {
       chatHeadView = Bundle.main.loadNibNamed("CommentHeadView", owner: nil, options: nil)!.first as? CommentHeadView
        chatHeadView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 158)
        //chatHeadView.backgroundColor = UIColor.yellow
        self.view.addSubview(self.chatHeadView)
        
        let headBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 158))
        headBgView.addSubview(chatHeadView)
         return headBgView
        // addGestureRecognizerToView(view: headView!, target: self, actionName: "tableHeadViewAction")
    }
    func creatFootView() -> UIView {
         let footBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 3))
          footBgView.backgroundColor = UIColor.groupTableViewBackground
          return footBgView
     }
    
    
    
 
    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    /**
     生成随机字符串,
      - parameter length: 生成的字符串的长度
      - returns: 随机生成的字符串
     */
    func getRandomStringOfLength(length: Int) -> String {
        var ranStr = ""
        for _ in 0..<length {
            let index = Int(arc4random_uniform(UInt32(characters.count)))
           // ranStr.append(characters[characters.startIndex.advanced(by: index)])
         }
        return ranStr
        
    }
 
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func avterBtnClick() {
        delegate?.avterButtonClick()
    }
 
 }
extension ChatMsgController:UITableViewDataSource,UITableViewDelegate {
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//       // func initSearchView(){
//        let ivew = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight))
//        headView = Bundle.main.loadNibNamed("ChatHeadView", owner: nil, options: nil)!.first as! ChatHeadView
//        ivew.addSubview(headView!)
//
//           return ivew
//           // headView.frame = CGRect.init(x: 0, y: -10, width: screenWidth, height: 64)
//           // headView.delegate = self
//            //self.navigationItem.titleView = searView
//      //  }
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 120
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  tableView.tableViewDisplayWithMsg(message: "暂时消息", rowCount: 0)
         return 20
     }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var   cellID = "cellID";
        var  cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellID)
        if (cell==nil) {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellID);
        }
         cell.textLabel?.text = "124324354"
         return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 44
     
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.chatMsgVCWillBeginDragging(chatMsgVC: self)
    }
}
extension ChatMsgController {
    // MARK: 滚到底部
    func scrollToBottom(animated: Bool = false) {
        self.view.layoutIfNeeded()
        //if dataArr.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 5, section: 0), at: .top, animated: animated)
      //  }
    }
    
 }
// MARK:- private Method
extension ChatMsgController {
    fileprivate func insertRows(_ rows: [IndexPath], atBottom: Bool = true) {
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: rows, with: .none)
        self.tableView.endUpdates()
        if atBottom {
            self.scrollToBottom()
        }
        UIView.setAnimationsEnabled(true)
      
    }
    // MARK: 更新数据
    fileprivate func updataRow(_ rows: [IndexPath]) {
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: rows, with: .none)
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        
    }
    
    // MARK: 删除数据
    fileprivate func deleteRow(_ rows: [IndexPath]) {
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: rows, with: .none)
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
       
    }
   
}

