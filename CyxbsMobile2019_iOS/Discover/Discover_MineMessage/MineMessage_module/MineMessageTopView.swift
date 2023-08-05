//
//  MineMessageTopView.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/31.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

protocol MineMessageTopViewDelegate: AnyObject {
    ///可定可以滑动到某个位置，重复点不会触发
    func mineMessageTopView(_ view: MineMessageTopView, willScrollFrom firstBtn: UIButton, toBtn secondBtn: UIButton)
}

///我的消息头视图
class MineMessageTopView: SSRTopBarBaseView {
    
    weak var delegate: MineMessageTopViewDelegate?
    ///系统通知点
    var systemHadMsg = Bool() {
        willSet {
            if systemHadMsg == newValue {
                return
            }
            if newValue {
                self.systemBtn.addSubview(systemBall)
            } else {
                self.systemBall.removeFromSuperview()
            }
        }
    }
    ///活动通知点
    var activeHadMsg = Bool() {
        willSet {
            if activeHadMsg == newValue {
                return
            }
            if newValue {
                self.activeBtn.addSubview(activeBall)
            } else {
                self.activeBall.removeFromSuperview()
            }
        }
    }
    ///更多有没有设置
    var moreHadSet = Bool() {
        willSet {
            if moreHadSet == newValue {
                return
            }
            if newValue {
                self.moreBall.removeFromSuperview()
            } else {
                self.moreBtn.addSubview(moreBall)
            }
        }
    }
    ///线是不是在动
    var lineIsScroll = Bool()
    
    // MARK: - Life Cycle
    
    override init(safeViewHeight height: CGFloat) {
        super.init(safeViewHeight: height)
        
        self.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1), dark: UIColor(red: 29 / 255, green: 29 / 255, blue: 29 / 255, alpha: 1))
        self.addTitle("我的消息", withTitleLay: .left, withStyle: nil)
        let bezier = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.width, height: self.height), byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 20, height: 20))
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        layer.path = bezier.cgPath
        self.layer.mask = layer
        
        self.safeView.addSubview(moreBtn)
        self.safeView.addSubview(systemBtn)
        self.safeView.addSubview(activeBtn)
        
        self.addSwithLine(withOrigin: CGPoint(x: 0, y: self.safeView.superBottom - 3))
        self.swithLine?.centerX = self.systemBtn.centerX
        self.systemBtn.isSelected = true
        self.lineIsScroll = false
        self.hadLine = false
        self.moreHadSet = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    /// 为“更多”添加事件
    /// - Parameters:
    ///   - target: 应该是个vc
    ///   - action: 应该弹出一个选择vc
    func addMoreBtnTarget(target: Any, action: Selector) {
        self.moreBtn.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func lineScrollToCenterX(_ centerX: CGFloat, more: CGFloat) {
        self.lineIsScroll = true
        UIView.animate(withDuration: 0.4) {
            self.swithLine?.centerX = centerX + more
        } completion: { fineshed in
            if fineshed {
                UIView.animate(withDuration: 0.2) {
                    self.swithLine?.centerX = centerX
                } completion: { finish in
                    if finish && self.lineIsScroll {
                        self.lineIsScroll = false
                    }
                }
            }
        }
    }
    
    @objc private func clickBtn(_ button: UIButton) {
        //当前没被选中，说明line在另一个位置，需要滑动到这个位置
        if button.isSelected == false {
            //如果在第一个位置，多位移为正，反之
            let more = (button == self.systemBtn ? -10 : +10) as CGFloat
            //如果在滑动，那就等
            if self.lineIsScroll {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.lineScrollToCenterX(button.centerX, more: more)
                }
            } else {
                self.lineScrollToCenterX(button.centerX, more: more)
            }
            
            if let delegate = delegate {
                delegate.mineMessageTopView(self, willScrollFrom: (button == systemBtn ? activeBtn : systemBtn), toBtn: button)
            }
        }
        //设置一下选中状态
        button.isSelected = true
        let anotherBtn = (button == systemBtn ? activeBtn : systemBtn)
        anotherBtn.isSelected = false
        self.moreBtn.tag = (button == self.activeBtn) ? 1 : 0
        button.setTitleColor(UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#DFDFE3", alpha: 1)), for: .normal)
        anotherBtn.setTitleColor(UIColor(DMNamespace.dm, light: UIColor(hexString: "#142C52", alpha: 0.4), dark: UIColor(hexString: "#F0F0F0", alpha: 55)), for: .normal)
    }
    
    // MARK: - Lazy
    
    //多选按钮
    private lazy var moreBtn: SSRButton = {
        let moreBtn = SSRButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        moreBtn.setImage(UIImage(named: "more_d"), for: .normal)
        moreBtn.right = self.superRight - 26
        moreBtn.centerY = 20
        moreBtn.expandHitEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        moreBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        moreBtn.imageView?.contentMode = .scaleAspectFit
        moreBtn.tag = 0
        return moreBtn
    }()
    //系统通知按钮
    private lazy var systemBtn: UIButton = {
        let systemBtn = UIButton(frame: CGRect(x: 0, y: 0, width: self.width / 2, height: 30))
        systemBtn.bottom = self.safeView.superBottom - 10
        systemBtn.setTitle("系统通知", for: .normal)
        systemBtn.titleLabel?.font = UIFont(name: PingFangSC, size: 18)
        systemBtn.setTitleColor(UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#DFDFE3", alpha: 1)), for: .normal)
        systemBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        return systemBtn
    }()
    //活动通知按钮
    private lazy var activeBtn: UIButton = {
        let activeBtn = UIButton(frame: CGRect(x: self.systemBtn.right, y: 0, width: self.width / 2, height: 30))
        activeBtn.bottom = self.systemBtn.bottom
        activeBtn.setTitle("活动通知", for: .normal)
        activeBtn.titleLabel?.font = UIFont(name: PingFangSC, size: 18)
        activeBtn.setTitleColor(UIColor(DMNamespace.dm, light: UIColor(hexString: "#142C52", alpha: 0.4), dark: UIColor(hexString: "#F0F0F0", alpha: 55)), for: .normal)
        activeBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        return activeBtn
    }()
    
    private lazy var systemBall: UIView = {
        let systemBall = UIView(frame: CGRect(x: self.systemBtn.titleLabel!.right, y: -1, width: 6, height: 6))
        systemBall.layer.cornerRadius = systemBall.width / 2
        systemBall.backgroundColor = UIColor(red: 255 / 255, green: 98 / 255, blue: 98 / 255, alpha: 1)
        return systemBall
    }()
    
    private lazy var activeBall: UIView = {
        let activeBall = UIView(frame: CGRect(x: self.activeBtn.titleLabel!.right, y: -1, width: 6, height: 6))
        activeBall.layer.cornerRadius = self.systemBall.width / 2
        activeBall.backgroundColor = UIColor(red: 255 / 255, green: 98 / 255, blue: 98 / 255, alpha: 1)
        return activeBall
    }()
    
    private lazy var moreBall: UIView = {
        let moreBall = UIView(frame: CGRect(x: self.moreBtn.imageView!.right, y: 0, width: 6, height: 6))
        moreBall.layer.cornerRadius = moreBall.width / 2
        moreBall.backgroundColor = UIColor(red: 255 / 255, green: 98 / 255, blue: 98 / 255, alpha: 1)
        return moreBall
    }()
}
