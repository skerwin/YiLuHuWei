//
//  ChatBarView.swift
//  BossJob
//
//  Created by zhaoyuanjing on 2017/11/09.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import UIKit
import SnapKit

//let kChatKeyboardBgColor: UIColor = RGBAOVER(r: 0.96, g: 0.96, b: 0.96, a: 1.0)
let kChatKeyboardBgColor: UIColor = UIColor.groupTableViewBackground
let kChatBarOriginHeight: CGFloat = 50.0
let kChatBarTextViewMaxHeight: CGFloat = 100
let kChatBarTextViewHeight: CGFloat = kChatBarOriginHeight - 14.0
// 分割线颜色
let kSplitLineColor = RGBA(r: 0.78, g: 0.78, b: 0.80, a: 1.00)

protocol ChatBarViewDelegate: NSObjectProtocol {
    func chatBarShowTextKeyboard()
    func chatBarUpdateHeight(height: CGFloat)
    func chatBarSendMessage()
    func chatBarCollect()
}

enum ChatKeyboardType: Int {
    case noting
    case common
    case text
    case emotion
    case more
}
class ChatBarView: UIView {
     // MARK:- 记录属性
    var keyboardType: ChatKeyboardType = .noting
    weak var delegate: ChatBarViewDelegate?
    var inputTextViewCurHeight: CGFloat = kChatBarOriginHeight
    // MARK:- 懒加载
    lazy var commonButton: UIButton = {
        let commonBtn = UIButton(type: .custom)
        commonBtn.setImage(UIImage.init(named: "comment"), for: .normal)
        commonBtn.addTarget(self, action: #selector(commonBtnClick(_:)), for: .touchUpInside)
        return commonBtn
    }()
    lazy var followButton: UIButton = {
        let followButton = UIButton(type: .custom)
        followButton.setImage(UIImage.init(named: "xingxing"), for: .normal)
        followButton.addTarget(self, action: #selector(followBtnClick(_:)), for: .touchUpInside)
        return followButton
    }()
    
    lazy var countLabel: UILabel = {
        let countLabel = UILabel.init()
        countLabel.text = "99"
        countLabel.font = UIFont.systemFont(ofSize: 15)
           return countLabel
    }()
    
    private lazy var placeholderLabel: UILabel =
      {
            let lb = UILabel()
            lb.textColor = UIColor.lightGray
            lb.text = "占位文字"
            lb.font = UIFont.systemFont(ofSize: 15.0)
            return lb
     }()
  
    lazy var inputTextView: UITextView = { [unowned self] in
        let inputV = UITextView()
        inputV.font = UIFont.systemFont(ofSize: 15.0)
        inputV.textColor = UIColor.black
        inputV.returnKeyType = .send
        inputV.enablesReturnKeyAutomatically = true
        inputV.layer.cornerRadius = 8.0
        inputV.layer.masksToBounds = true
        inputV.layer.borderColor = ZYJColor.chatLine.cgColor
        inputV.layer.borderWidth = 0.5
        inputV.layer.backgroundColor = kChatKeyboardBgColor.cgColor
        inputV.delegate = self
        inputV.addObserver(self, forKeyPath: "attributedText", options: .new, context: nil)
        return inputV
        }()
    
    // MARK:- init
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置按钮图片
        self.resetBtnsUI()
        // 初始化UI
        self.setupUI()
        // 初始化事件
      //  self.setupEvents()
    }
    func setupUI(){
        backgroundColor = UIColor.white
        addSubview(commonButton)
        addSubview(followButton)
        addSubview(countLabel)
        addSubview(inputTextView)
          // 布局
        
        followButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-8)
            make.width.height.equalTo(35)
            make.bottom.equalTo(self.snp.bottom).offset(-7)
        }
        
        countLabel.snp.makeConstraints { (make) in
                make.right.equalTo(followButton.snp.right).offset(-27)
                make.width.height.equalTo(30)
                make.bottom.equalTo(self.snp.bottom).offset(-10)
        }
        
        commonButton.snp.makeConstraints { (make) in
            make.right.equalTo(countLabel.snp.left).offset(-5)
            make.width.height.equalTo(27)
            make.bottom.equalTo(self.snp.bottom).offset(-11)
        }
      
        inputTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(13)
            make.right.equalTo(commonButton.snp.left).offset(-8)
            make.top.equalTo(self).offset(7)
            make.bottom.equalTo(self).offset(-7)
        }
 
         // 添加上下两条线
        for i in 0..<2 {
            let splitLine = UIView()
            splitLine.backgroundColor = ZYJColor.Line.grey
            self.addSubview(splitLine)
            if i == 0 {
                splitLine.snp.makeConstraints({ (make) in
                    splitLine.snp.makeConstraints { (make) in
                        make.left.top.right.equalTo(self)
                        make.height.equalTo(1)
                    }
                })
            } else {
                splitLine.snp.makeConstraints({ (make) in
                    splitLine.snp.makeConstraints { (make) in
                        make.left.bottom.right.equalTo(self)
                        make.height.equalTo(0.5)
                    }
                })
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        inputTextView.removeObserver(self, forKeyPath: "attributedText")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
 
    
    @objc func commonBtnClick(_ btn: UIButton){
    }
    
    @objc func followBtnClick(_ btn: UIButton){
           // resetBtnsUI()
          delegate?.chatBarCollect()
         // followButton.setImage(UIImage.init(named: "xuanzhong"), for: .normal)
         // followButton.setImage(UIImage.init(named: "xuanzhong"), for: .highlighted)
    }
   
     func resetBtnsUI()  {
 
       
       // commonButton.setImage(UIImage.init(named: "comment"), for: .highlighted)
 
        // 时刻修改barView的高度
        self.textViewDidChange(inputTextView)
    }
 }
extension ChatBarView : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        resetBtnsUI()
        keyboardType = .text
         // 调用代理方法
        delegate?.chatBarShowTextKeyboard()
    }
    func textViewDidChange(_ textView: UITextView) {
        var height = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat(Float.greatestFiniteMagnitude))).height
        height = height > kChatBarTextViewHeight ? height : kChatBarTextViewHeight
        height = height < kChatBarTextViewMaxHeight ? height : textView.frame.size.height
        inputTextViewCurHeight = height + kChatBarOriginHeight - kChatBarTextViewHeight
        if inputTextViewCurHeight != textView.frame.size.height {
            UIView.animate(withDuration: 0.05, animations: {
                // 调用代理方法
                self.delegate?.chatBarUpdateHeight(height: self.inputTextViewCurHeight)
            })
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        if text == "\n" {
               
             delegate?.chatBarSendMessage()
             return false
 
        }
        return true
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
 
        inputTextView.scrollRangeToVisible(NSMakeRange(inputTextView.text.charLength(), 1))
         self.textViewDidChange(inputTextView)
    }
    
}
