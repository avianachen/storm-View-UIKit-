//
//  ViewController.swift
//  Project4
//
//  Created by cxq on 2025/4/17.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["www.hackingwithswift.com","www.apple.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let forward = UIBarButtonItem(title: ">", style:.plain,target: webView, action: #selector(webView.goForward))
        let back = UIBarButtonItem(title: "<", style:.plain, target: webView, action: #selector(webView.goBack))
        toolbarItems = [back,forward,progressButton,spacer,refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else{
            decisionHandler(.allow)
            return
        }
        print(url.host ?? "")
        //某些情况下，URL 可能是合法的，但它的上下文或来源可能不符合你的要求。例如，某些嵌入的资源（如广告链接）可能被错误地识别为不允许的 URL。可以通过检查   navigationAction   的类型来区分用户直接输入的 URL 和自动加载的资源。
        //检查是否是用户直接输入的URL
        if navigationAction.navigationType == .linkActivated{
            if websites.contains(url.host ?? ""){
                decisionHandler(.allow)
            }else{
                showBlockedURLAlert(url:url)
                decisionHandler(.cancel)
            }
        }else{
            decisionHandler(.allow)
        }
        //decisionHandler(.cancel)
            
    }
    
    func showBlockedURLAlert(url:URL){
        let ac = UIAlertController(title: "访问被阻止", message: "您尝试访问的 \(url.host ?? "") 已被阻止。", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
        present(ac,animated: true,completion: nil)
    }
    
    @objc func openTapped(){
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac,animated: true)
    }
    
    func openPage(action:UIAlertAction){
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    
}


