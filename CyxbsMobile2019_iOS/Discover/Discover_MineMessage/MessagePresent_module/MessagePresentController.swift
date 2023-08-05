//
//  MessagePresentController.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/29.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

///消息系统的弹窗样式（包含一个取消，一个确定，具体见效果 待封装）
class MessagePresentController: UIViewController {
    
    // MARK: - Life Cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        self.view.backgroundColor = UIColor(red: 0 / 255, green: 15 / 255, blue: 37 / 255, alpha: 0.14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentView.center = self.view.superCenter
        self.view.addSubview(presentView)
    }
    
    // MARK: - Method
    
    /// 上面的也是最基本的，title和detail也可以选择其中一个，会自动布局
    /// - Parameters:
    ///   - str: 提示文字
    ///   - titleColor: 提示文字的颜色
    func addTitle(_ str: String, titleColor: UIColor) {
        self.presentView.addTitle(str: str, color: titleColor)
    }
    
    /// 添加一个detail（UI和title一样
    /// - Parameter detail: 提示文字
    func addDetail(_ detail: String) {
        self.presentView.addDetailStr(detail)
    }
    
    /// dismiss时单击的是不是取消
    /// - Parameter tapCancel: 单击后做的事情
    func addDismiss(touchCancel: ((Bool) -> Void)?) {
        self.presentView.tapButton { isCancel in
            self.dismiss(animated: false, completion: nil)
            if let touchCancel = touchCancel {
                touchCancel(isCancel)
            }
        }
    }
    
    // MARK: - Lazy
    
    //主要的弹窗视图，请自定义
    private lazy var presentView: MessagePresentView = {
        let presentView = MessagePresentView(frame: CGRect(x: 0, y: 0, width: 255, height: 146))
        return presentView
    }()
}
