//
//  MessageDetailVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/28.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import WebKit

class MessageDetailVC: UIViewController,
                       WKNavigationDelegate {
    //加载的URL
    private var url: String = ""
    //加载更多的URL
    private var moreURL: String?
    //(可能会有的)顶部视图
    private var titleView = MessageDetailTitleView()
    //用户发布信息
    private var publishModel: UserPublishModel<AnyObject>?
    
    // MARK: - Life Cycle
    
    init() {
        fatalError("init() is unavailable")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 根据URL加载页面
    /// - Parameter url: 传入URL
    init(url: String) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    /// 根据一堆奇怪的东西绘制
    /// - Parameters:
    ///   - url: 现在需要加载的URL
    ///   - model: 不传入，则不增加顶部。传入时，无头像或无名字则只有日期
    ///   - moreURL: 传入则跳转到第二层级URL
    init(url: String, useSpecialModel model: (() -> UserPublishModel<AnyObject>?)?, moreURL: String?) {
        super.init(nibName: nil, bundle: nil)
        
        self.url = url
        
        if let model = model {
            if let userPublishModel = model() {
                self.publishModel = userPublishModel
            }
        }
        
        if let moreURL = moreURL, moreURL != "" {
            self.moreURL = moreURL
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(topView)
        self.view.addSubview(webView)
        
        if let _ = self.moreURL {
            self.webView.scrollView.contentInset = UIEdgeInsets(top: self.webView.scrollView.contentInset.top, left: 0, bottom: 116, right: 0)
            self.webView.scrollView.addSubview(moreBtn)
        }
        
        if let publishModel = publishModel {
            self.titleView = MessageDetailTitleView(width: self.webView.width, specialUserPublishModel: publishModel)
            self.titleView.top = -self.titleView.height
            self.webView.scrollView.contentInset = UIEdgeInsets(top: self.titleView.height, left: 0, bottom: self.webView.scrollView.contentInset.bottom, right: 0)
            self.webView.scrollView.addSubview(titleView)
        }
        
        self.view.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(red: 248 / 255, green: 249 / 255, blue: 252 / 255, alpha: 1), dark: UIColor(red: 0 / 255, green: 1 / 255, blue: 1 / 255, alpha: 1))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.webView.navigationDelegate = nil
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let backgroundColorStr = UIColor(DMNamespace.dm, light: UIColor(hexString: "#F8F9FC", alpha: 1), dark: UIColor(hexString: "#000000", alpha: 1)).hexString()!
        let textColorStr = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#F0F0F0", alpha: 1)).hexString()!
        webView.evaluateJavaScript("document.body.style.backgroundColor = \"\(backgroundColorStr)\"", completionHandler: nil)
        webView.evaluateJavaScript("document.body.style.webkitTextFillColor = \"\(textColorStr)\"", completionHandler: nil)
        webView.evaluateJavaScript("document.body.style.fontFamily = \"PingFang SC\"", completionHandler: nil)
        
        let injectionJSStr = """
            var script = document.createElement('meta')
            script.name = 'viewport'
            script.content = "width=device-width, user-scalable=no"
            document.getElementsByTagName('head')[0].appendChild(script)
            """
        webView.evaluateJavaScript(injectionJSStr, completionHandler: nil)
        self.perform(#selector(messageDetailVC_showWebView), afterDelay: 0.1)
    }
    
    // MARK: - Method
    
    @objc private func messageDetailVC_pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func messageDetailVC_push() {
        let vc = MessageDetailVC(url: self.moreURL!, useSpecialModel: nil, moreURL: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func messageDetailVC_showWebView() {
        self.webView.isHidden = false
        self.moreBtn.top = self.webView.scrollView.contentSize.height + 36
        self.webView.scrollView.scrollToTop(animated: false)
    }
    
    // MARK: - Lazy
    
    //顶部视图
    private lazy var topView: SSRTopBarBaseView = {
        let topView = SSRTopBarBaseView(safeViewHeight: 44)
        topView.hadLine = false
        topView.addTitle("详情", withTitleLay: .left, withStyle: nil)
        topView.addBackButtonTarget(self, action: #selector(messageDetailVC_pop))
        return topView
    }()
    //加载页
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 16, y: self.topView.bottom, width: self.view.width - 2 * 16, height: self.view.height - self.topView.bottom))
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.load(HttpTool.share().urlRequest(withURL: self.url, bodyParameters: nil))
        webView.isHidden = true
        webView.navigationDelegate = self
        return webView
    }()
    //加载更多的按钮
    private lazy var moreBtn: UIButton = {
        let moreBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 184, height: 40))
        moreBtn.centerX = self.webView.scrollView.superCenter.x
        moreBtn.layer.cornerRadius = moreBtn.height / 2
        moreBtn.setTitle("点击前往", for: .normal)
        moreBtn.titleLabel?.font = UIFont(name: PingFangSC, size: 18)
        moreBtn.setTitleColor(UIColor.white, for: .normal)
        moreBtn.backgroundColor = UIColor(hexString: "#4A44E4", alpha: 1)
        moreBtn.addTarget(self, action: #selector(messageDetailVC_push), for: .touchUpInside)
        return moreBtn
    }()
}
