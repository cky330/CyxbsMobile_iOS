//
//  MineMessageVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/8/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

///我的信息VC，主VC
@objcMembers
class MineMessageVC: UIViewController,
                     MineMessageTopViewDelegate,
                     MineMessageMoreVCDelegate,
                     SystemMessageVCDelegate,
                     ActiveMessageVCDelegate {
    
    //总的一个模型，用来请求，和其他操作
    private var mineMsgModel = MineMessageModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(topView)
        self.addChild(systemMessageVC)
        self.addChild(activeMessageVC)
        self.view.addSubview(contentView)
        self.contentView.addSubview(systemMessageVC.view)
        self.contentView.addSubview(activeMessageVC.view)
        self.view.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(red: 248 / 255, green: 249 / 255, blue: 252 / 255, alpha: 1), dark: UIColor(red: 0 / 255, green: 1 / 255, blue: 1 / 255, alpha: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.mineMsgModel.request {
            self.systemMessageVC.sysMsgModel = self.mineMsgModel.systemMsgModel
            let needSystemBall = self.systemMessageVC.hadReadAfterReloadData()
            self.topView.systemHadMsg = needSystemBall

            self.activeMessageVC.sysModel = self.mineMsgModel.activeMsgModel
            let needActiveBall = self.activeMessageVC.hadReadAfterReloadData()
            self.topView.activeHadMsg = needActiveBall

            if self.contentView.left < self.view.width / 2 {
                if self.systemMessageVC.sysMsgModel.msgAry.isEmpty {
                    NewQAHud.show(with: "没有系统消息了", add: self.systemMessageVC.view)
                }
            } else {
//                if self.activeMessageVC.sysModel.activeMsgAry.isEmpty {
                if self.systemMessageVC.sysMsgModel.msgAry.isEmpty {
                    NewQAHud.show(with: "没有活动消息了", add: self.systemMessageVC.view)
                }
            }
        } failure: { error in
            let view = (self.contentView.left < self.view.width / 2 ? self.systemMessageVC.view : self.activeMessageVC.view) as UIView
            NewQAHud.show(with: "网络异常", add: view)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.contentView.left < -self.view.width / 2 {
            self.systemMessageVC.view.isHidden = true
        }
    }
    
    // MARK: - MineMessageTopViewDelegate

    func mineMessageTopView(_ view: MineMessageTopView, willScrollFrom firstBtn: UIButton, toBtn secondBtn: UIButton) {
        let view = (firstBtn.left < secondBtn.left ? self.activeMessageVC.view : self.systemMessageVC.view) as UIView
        let moreSpace = (firstBtn.left < secondBtn.left ? -7 : 7) as CGFloat
        contentViewScrollTo(view, moreSpace: moreSpace)
        if firstBtn.left < secondBtn.left {
            self.systemMessageVC.viewWillDisappear(true)
            self.activeMessageVC.viewDidAppear(true)
        } else {
            self.activeMessageVC.viewWillDisappear(true)
            self.systemMessageVC.viewDidAppear(true)
        }
    }

    // MARK: - MineMessageMoreVCDelegate

    func mineMessageMoreVC(_ vc: MineMessageMoreVC, selectedTitle title: String) {
        if title == "一键已读" {
            //分vc
            if vc.popoverPresentationController?.sourceView?.tag != nil {
                //系统通知
                self.systemMessageVC.readAllMessage()
            } else {
                //活动通知
                self.activeMessageVC.readAllMessage()
            }
        } else if title == "删除已读" {
            //只有systemVC有
            self.systemMessageVC.deleteAllReadMessage()
        } else {
            //单击了设置，小红点无了，但需要我们去标记UserDefualt
            USER_DEFAULT.set(true, forKey: MineMessage_hadSettle_BOOL)
            self.topView.moreHadSet = USER_DEFAULT.bool(forKey: MineMessage_hadSettle_BOOL)
            self.navigationController?.pushViewController(MessageSettingVC(), animated: true)
        }
    }

    // MARK: - SystemMessageVCDelegate

    func systemMessageVC_hadReadAllMsg(vc: SystemMessageVC) {
        self.topView.systemHadMsg = false
    }

    // MARK: - ActiveMessageVCDelegate

    func activeMessageVC_hadReadAllMessage(vc: ActiveMessageVC) {
        self.topView.activeHadMsg = false
    }
    
    // MARK: - Method
    
    @objc private func popMineMessageVC() {
        if self.contentView.left < -self.view.width / 2 {
            self.systemMessageVC.view.isHidden = true
        }
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func showMore(_ sender: UIButton) {
        //只要没报错，不崩溃，建议不要更改如下代码（需要进一步验证）
        if !self.systemMessageVC.isEditing {
            let moreVC = MineMessageMoreVC()
            moreVC.delegate = self
            let popVC = moreVC.popoverPresentationController
            //弹出控制器的箭头指向的view
            popVC?.sourceView = sender
            //弹出视图的箭头的“尖”的坐标 - 在sender的底部边缘居中）
            popVC?.sourceRect = sender.bounds
            self.present(moreVC, animated: true, completion: nil)
        }
    }

    private func contentViewScrollTo(_ view: UIView, moreSpace:CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.contentView.left = -view.left + moreSpace
        } completion: { finished in
            if finished {
                if self.topView.lineIsScroll {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        UIView.animate(withDuration: 0.2) {
                            self.contentView.left = -view.left
                        }
                    }
                } else {
                    UIView.animate(withDuration: 0.2) {
                        self.contentView.left = -view.left
                    }
                }
            }
        }
    }
    
    // MARK: - Lazy
    
    //顶部视图
    private lazy var topView: MineMessageTopView = {
        let topView = MineMessageTopView(safeViewHeight: 94)
        topView.addBackButtonTarget(self, action: #selector(popMineMessageVC))
        topView.addMoreBtnTarget(target: self, action: #selector(showMore))
        topView.delegate = self
        topView.systemHadMsg = false
        topView.activeHadMsg = false
        topView.moreHadSet = USER_DEFAULT.bool(forKey: MineMessage_hadSettle_BOOL)
        return topView
    }()
    //两个VC视图加载这上面，用于动画
    private lazy var contentView: UIView = {
        let contentView = UIView(frame: CGRect(x: 0, y: self.topView.bottom, width: 2 * SCREEN_WIDTH, height: self.view.height - self.topView.bottom))
        contentView.backgroundColor = UIColor.clear
//        contentView.addSubview(systemMessageVC.view)
//        contentView.addSubview(activeMessageVC.view)
        return contentView
    }()
    //消息通知
    private lazy var systemMessageVC: SystemMessageVC = {
        let systemMessageVC = SystemMessageVC(systemMessage: self.mineMsgModel.systemMsgModel, frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.contentView.height))
        systemMessageVC.delegate = self
        return systemMessageVC
    }()
    //活动通知
    private lazy var activeMessageVC: ActiveMessageVC = {
        let activeMessageVC = ActiveMessageVC(activeMessage: self.mineMsgModel.activeMsgModel, frame: CGRect(x: self.systemMessageVC.view.right, y: 0, width: self.view.width, height: self.contentView.height))
        activeMessageVC.delegate = self
        return activeMessageVC
    }()
}
