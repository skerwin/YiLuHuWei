//
//  NewNotifyDetailController.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/11/17.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import WebKit

class NewNotifyDetailController: BaseViewController {
    
    var urlString = ""
    
    var model = NotifyModel()
    
//    setStringValueForKey(value: responseResult["privacy_url"].stringValue as String, key: "privacy_url")
//    setStringValueForKey(value: responseResult["about_url"].stringValue as String, key: "about_url")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if urlString == "" {
            urlString = model?.web_url ?? ""
         }
        loadWebView()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    lazy var changeWebView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        //初始化偏好设置属性：preferences
        webConfiguration.preferences = WKPreferences()
        //是否支持JavaScript
        webConfiguration.preferences.javaScriptEnabled = false
        //不通过用户交互，是否可以打开窗口
        // webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        let webFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
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
        if urlString == "" {
            return
        }
        
        var myRequest = URLRequest(url: URL.init(string: urlString)!)
        myRequest.cachePolicy = .useProtocolCachePolicy
        myRequest.timeoutInterval = 60
        clearCache()
        self.changeWebView.load(myRequest)
        
    }
    
    func clearCache() -> Void {
           URLCache.shared.removeAllCachedResponses();
           URLCache.shared.diskCapacity = 0;
           URLCache.shared.memoryCapacity = 0;
       }
}

extension NewNotifyDetailController: WKNavigationDelegate {
    
    // 监听网页加载进度
    
     func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            // 判断服务器采用的验证方法
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if challenge.previousFailureCount == 0 {
                // 如果没有错误的情况下 创建一个凭证，并使用证书
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(.useCredential, credential)
            } else {
                // 验证失败，取消本次验证
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }


    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("页面开始加载时调用")
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        print("当内容开始返回时调用")
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("页面加载完成之后调用")
        self.view.addSubview(webView)
    }
    
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
//        let alertView = UIAlertController.init(title: "提示", message: "加载失败", preferredStyle: .alert)
//        let okAction = UIAlertAction.init(title:"确定", style: .default) { okAction in
//            _=self.navigationController?.popViewController(animated: true)
//        }
//        alertView.addAction(okAction)
//        self.present(alertView, animated: true, completion: nil)
       // self.navigationController?.popToRootViewController(animated: true)
    }
    
}
