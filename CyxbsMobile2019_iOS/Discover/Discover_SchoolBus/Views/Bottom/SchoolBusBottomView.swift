//
//  SchoolBusBottomView.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/23.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

protocol SchoolBusBottomViewDelegate: AnyObject {
    func schoolBusBottomView(_ view: SchoolBusBottomView, didSelectedBtnWithIndex index: Int, isSelected: Bool )
}

class SchoolBusBottomView: UIView {
    
    // 标示所选中的按钮
    private var selectedBtn = UIButton()
    var delegate: SchoolBusBottomViewDelegate?
    private var lineLabAry: [UILabel] = []
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.selectedBtn = self.busBtnAry[0]
        self.addLineLabAry()
        self.addGesture()
        self.addSubview(titleLab)
        self.addSubview(dragHintView)
        self.layer.cornerRadius = 16
        self.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#FFFFFF" , alpha: 1), dark: UIColor(hexString: "#1D1D1D", alpha: 1))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    // 添加按钮下方文字文本
    private func addLineLabAry() {
        for i in 0..<5 {
            let label = UILabel(frame: CGRect(x: 0, y: self.busBtnAry[i].bottom + 9, width: 40, height: 14))
            label.centerX = self.busBtnAry[i].centerX
            label.textAlignment = .center
            label.font = UIFont(name: PingFangSCLight, size: 10)
            let string: String = ""
            if i < 4 {
                label.text = string.appendingFormat("%d号线", i + 1)
            } else {
                label.text = "乘车指南"
            }
            label.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#94A6C4", alpha: 1), dark: UIColor(hexString: "#FFFFFF", alpha: 1))
            self.addSubview(label)
        }
    }
    // 添加手势
    private func addGesture() {
        let recognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(withdrawBottomView))
        let recognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(popBottomView))
        recognizerDown.direction = .down
        recognizerUp.direction = .up
        self.addGestureRecognizer(recognizerDown)
        self.addGestureRecognizer(recognizerUp)
    }
    // 识别到向下滑动手势时收起底部视图
    @objc private func withdrawBottomView() {
        self.selectedBtn.isSelected = !self.selectedBtn.isSelected
        if self.delegate != nil {
            self.delegate?.schoolBusBottomView(self, didSelectedBtnWithIndex: self.selectedBtn.tag, isSelected: !self.selectedBtn.isSelected)
        }
    }
    // 识别到向上滑动手势时弹出底部视图
    @objc private func popBottomView() {
        self.selectedBtn.isSelected = !self.selectedBtn.isSelected
        if self.delegate != nil {
            self.delegate?.schoolBusBottomView(self, didSelectedBtnWithIndex: self.selectedBtn.tag, isSelected: !self.selectedBtn.isSelected)
        }
    }
    // 点击底部的按钮数组中的任意按钮时调用
    @objc private func clickBusLineBtn(_ button: UIButton) {
        self.busBtnControllerWithBtnTag(button.tag)
    }
    
    func busBtnControllerWithBtnTag(_ tag: Int) {
        // tag对应的button在数组中的位置
        let realPosition = (tag + self.busBtnAry.count - 1) % self.busBtnAry.count
        
        if self.selectedBtn.isSelected == false && self.selectedBtn.tag == tag {
            self.selectedBtn.isSelected = !self.selectedBtn.isSelected
        } else if tag != self.selectedBtn.tag {
            self.selectedBtn.isSelected = false
            self.busBtnAry[realPosition].isSelected = true
        } else {
            self.busBtnAry[realPosition].isSelected = !self.busBtnAry[realPosition].isSelected
        }
        
        // tag = 0: 乘车指南按钮
        if tag != 0 {
            self.selectedBtn = self.busBtnAry[realPosition]
        }
        if self.delegate != nil {
            self.delegate?.schoolBusBottomView(self, didSelectedBtnWithIndex: tag, isSelected: !self.selectedBtn.isSelected)
        }
    }
    
    //MARK: - Lazy
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel(frame: CGRect(x: 16, y: 109, width: 200, height: 31))
        return titleLab
    }()
    // 显示可拖拽的条
    private lazy var dragHintView: UIView = {
        let dragHintView = UIView(frame: CGRect(x: 0, y: self.top + 8, width: 36, height: 5))
        dragHintView.centerX = self.centerX
        dragHintView.layer.cornerRadius = 2.5
        dragHintView.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#E8F0FC", alpha: 1), dark: UIColor(hexString: "#000000", alpha: 1))
        return dragHintView
    }()
    // 校车+乘车指南按钮数组
    private lazy var busBtnAry: [UIButton] = {
        var busBtnAry: [UIButton] = []
        let count = self.defaultBusImgNameAry.count
        for i in 0..<count {
            let button = UIButton(frame: CGRect(x: (Int(KSCREEN_WIDTH) * ((i) % count) / count + Int(KSCREEN_WIDTH) * 19 / 375), y: 28, width: 36, height: 36))
            button.tag = (i + 1) % 5
            button.setImage(UIImage(named: self.defaultBusImgNameAry[i]), for: UIControl.State.normal)
            button.setImage(UIImage(named: self.defaultBusImgNameAry[i]), for: UIControl.State.highlighted)
            if i < count - 1 {
                button.setImage(UIImage(named: self.selectedBusImgNameAry[i]), for: UIControl.State.selected)
            }
            button.addTarget(self, action: #selector(clickBusLineBtn), for: UIControl.Event.touchUpInside)
            self.addSubview(button)
            busBtnAry.append(button)
        }
        return busBtnAry
    }()
    // 校车图片名（未点击
    private lazy var defaultBusImgNameAry: [String] = {
        let defaultBusImgNameAry = ["PinkBus", "OrangeBus", "BlueBus", "GreenBus", "Compass"]
        return defaultBusImgNameAry
    }()
    // 校车图片名（已点击
    private lazy var selectedBusImgNameAry: [String] = {
        let selectedBusImgNameAry = ["PinkBus_Click", "OrangeBus_Click", "BlueBus_Click", "GreenBus_Click", "Compass_Click"]
        return selectedBusImgNameAry
    }()
}
