//
//  MessagePresentView.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/28.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

///真正被弹出的视图，可单独使用
class MessagePresentView: UIView {

    typealias TapCancelBlock = (Bool) -> Void
    //回调block
    private var cancelBlock: TapCancelBlock?
    //标记titleLab是否初始化
    private var isTitleLabInitialized = false
    //标记detailLab是否初始化
    private var isDetailLabInitialized = false

    // MARK: - Life Cycle

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 255, height: 146))
        self.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(cancelBtn)
        self.addSubview(okBtn)
        self.addSubview(messageView)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#FFFFFF", alpha: 1), dark: UIColor(hexString: "#2C2C2C", alpha: 1))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method

    /// 添加一个标题信息，标题文字颜色可改
    /// - Parameters:
    ///   - str: 标题信息
    ///   - color: 标题文字颜色
    func addTitle(str: String, color: UIColor) {
        if !isTitleLabInitialized {
            self.messageView.addSubview(titleLab)
            self.titleLab.center = self.messageView.superCenter
        }
        if isDetailLabInitialized {
            self.height += 24
            self.sizeToFit()
        }
        self.titleLab.text = str
        self.titleLab.textColor = color
    }

    /// 添加描述（UI和title一样
    /// - Parameter dateil: 描述文字
    func addDetailStr(_ detail: String) {
        if !isDetailLabInitialized {
            self.messageView.addSubview(detailLab)
            self.detailLab.center = self.messageView.superCenter
        }
        if isTitleLabInitialized {
            self.height += 21
            self.sizeToFit()
        }
        self.detailLab.text = detail
    }

    /// 单击了按钮，返回是不是取消
    /// - Parameter tapCancel: 单击按钮，返回是否是取消
    func tapButton(tapCancel: ((Bool) -> Void)?) {
        if let cancelBlock = tapCancel {
            self.cancelBlock = cancelBlock
        }
    }

    @objc private func clickCancelBtn(_ button: UIButton) {
        if let cancelBlock = cancelBlock {
            let isCancel = (button == self.cancelBtn)
            cancelBlock(isCancel)
        }
    }

    override func draw(_ rect: CGRect) {
        self.cancelBtn.bottom = self.superBottom - 35
        self.okBtn.bottom = self.cancelBtn.bottom
        self.titleLab.bottom = self.messageView.superCenter.y
        self.detailLab.top = self.titleLab.bottom
        self.messageView.stretchBottom_(toPointY: self.cancelBtn.top, offset: 5)
    }

    // MARK: - Lazy

    //取消按钮
    private lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(frame: CGRect(x: self.width * 0.1, y: 0, width: 93, height: 34))
        cancelBtn.bottom = self.superBottom - 35
        cancelBtn.layer.cornerRadius = cancelBtn.height / 2
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(red: 195 / 255, green: 212 / 255, blue: 238 / 255, alpha: 1), dark: UIColor(red: 90 / 255, green: 90 / 255, blue: 90 / 255, alpha: 1))
        cancelBtn.addTarget(self, action: #selector(clickCancelBtn), for: .touchUpInside)
        return cancelBtn
    }()
    //文本总的一个view
    private lazy var messageView: UIView = {
        let messageView = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height - self.cancelBtn.top + 5))
        messageView.backgroundColor = UIColor.clear
        return messageView
    }()
    //标题文本
    private lazy var titleLab: UILabel = {
        let titleLab = UILabel(frame: CGRect(x: 0, y: 0, width: self.width, height: 19))
        titleLab.font = UIFont(name: PingFangSC, size: 14)
        titleLab.textAlignment = .center
        titleLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#DFDFE3", alpha: 1))
        self.isTitleLabInitialized = true
        return titleLab
    }()
    //细节文本
    private lazy var detailLab: UILabel = {
        let detailLab = UILabel(frame: CGRect(x: 0, y: 0, width: self.width, height: 19))
        detailLab.font = UIFont(name: PingFangSC, size: 14)
        detailLab.textAlignment = .center
        detailLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#DFDFE3", alpha: 1))
        self.isDetailLabInitialized = true
        return detailLab
    }()
    //确定按钮
    private lazy var okBtn: UIButton = {
        let okBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 93, height: 34))
        okBtn.right = self.superRight - self.width * 0.1
        okBtn.bottom = self.cancelBtn.bottom
        okBtn.layer.cornerRadius = okBtn.height / 2
        okBtn.setTitle("确定", for: .normal)
        okBtn.setTitleColor(UIColor.white, for: .normal)
        okBtn.backgroundColor = UIColor(red: 74 / 255, green: 68 / 255, blue: 228 / 255, alpha: 1)
        okBtn.addTarget(self, action: #selector(clickCancelBtn), for: .touchUpInside)
        return okBtn
    }()
}
