//
//  WriteWebController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/29.
//  Copyright © 2021 gansukanglin. All rights reserved.
//
import UIKit
import WebKit

class WriteWebController: BaseViewController {

    var saveBtn = UIButton()
    var urlString = "http://talent.cdhg123.club/portal/cases/add.html"
    var hadTypeContent = ""
    
    var writeBlock:((_ writeString:String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "编辑"
        initView()
        
    }
    
 
    
    func initView(){
        loadWebView()
        createRightNavItem()
        
//        saveBtn = UIButton.init()
//        saveBtn.frame = CGRect.init(x: 0, y: screenHeight - 60 - navigationHeaderAndStatusbarHeight, width: screenWidth, height: 50)
//        saveBtn.addTarget(self, action: #selector(saveBtnClick(_:)), for: .touchUpInside)
//        saveBtn.backgroundColor = ZYJColor.main
//        saveBtn.setTitle("保存", for: .normal)
        
//        self.view.addSubview(saveBtn)
        //saveBtn.setImage(UIImage.init(named: "gengduo"), for: .normal)
    }
    
    
    func createRightNavItem(title:String = "保存",imageStr:String = "") {
        if imageStr == ""{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: title, style: .plain, target: self, action:  #selector(rightNavBtnClick))
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: imageStr), style: .plain, target: self, action: #selector(rightNavBtnClick))
        }
        
    }
    
    @objc func rightNavBtnClick(){
        self.writeWebView.evaluateJavaScript("getHtml()") { (response, error) in
            let responseString:String = response as! String
            if responseString.isLengthEmpty(){
                DialogueUtils.showError(withStatus: "请输入内容")
                return
            }
            self.writeBlock!(responseString)
            self.navigationController?.popViewController(animated: true)
            print(responseString )
        }
    }

    lazy var writeWebView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        //初始化偏好设置属性：preferences
        webConfiguration.preferences = WKPreferences()
        //是否支持JavaScript
        webConfiguration.preferences.javaScriptEnabled = true
        //不通过用户交互，是否可以打开窗口
        webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        let webFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navigationHeaderAndStatusbarHeight)
        let webView = WKWebView(frame: webFrame, configuration: webConfiguration)
      // webView.backgroundColor = UIColor.blue
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = true
        webView.scrollView.showsVerticalScrollIndicator = true
        webView.scrollView.showsHorizontalScrollIndicator = true
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        
        return webView
    }()
    
    func loadWebView() {
        
        var myRequest = URLRequest(url: URL.init(string: urlString)!)
        myRequest.cachePolicy = .useProtocolCachePolicy
        myRequest.timeoutInterval = 60
        self.writeWebView.load(myRequest)
        
    }
}

extension WriteWebController: WKNavigationDelegate {
    
    // 监听网页加载进度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if hadTypeContent != "" {
            let textStr = "addHtml('" + "\(hadTypeContent)" + "')"
            webView.evaluateJavaScript(textStr, completionHandler: nil)
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
    
}
