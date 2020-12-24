//
//  AdverController.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/18.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import WebKit

class AdverController: BaseViewController , UIWebViewDelegate{

    
    var urlString: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情"
         loadWebView()
      

        // Do any additional setup after loading the view.
    }
    
    func loadWebView() {
        
        var myRequest = URLRequest(url: URL.init(string: urlString!)!)
        myRequest.cachePolicy = .useProtocolCachePolicy
        myRequest.timeoutInterval = 60
        self.adverwebView.load(myRequest)
        
    }
    
    lazy var adverwebView: WKWebView = {
         let webConfiguration = WKWebViewConfiguration()
         //初始化偏好设置属性：preferences
         webConfiguration.preferences = WKPreferences()
         //是否支持JavaScript
         webConfiguration.preferences.javaScriptEnabled = true
         //不通过用户交互，是否可以打开窗口
        // webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
         
         let webFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navigationHeaderAndStatusbarHeight)
         let webView = WKWebView(frame: webFrame, configuration: webConfiguration)
         webView.navigationDelegate = self
        // webView.scrollView.isScrollEnabled = false
         webView.scrollView.bounces = false
         webView.scrollView.showsVerticalScrollIndicator = false
         webView.scrollView.showsHorizontalScrollIndicator = false
         webView.navigationDelegate = self
        self.view.addSubview(webView)
         return webView
     }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AdverController: WKNavigationDelegate {
    
    // 监听网页加载进度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       // DialogueUtils.showWithStatus("详情加载")
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DialogueUtils.dismiss()
        
        let javascript = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);"
        webView.evaluateJavaScript(javascript, completionHandler: nil)
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
        
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
