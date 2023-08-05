//
//  SystemMessageCell.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/30.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

let SystemMessageCellReuseIdentifier = "SystemMessageCell"

///系统消息的cell模式
class SystemMessageCell: UITableViewCell {
    
    var hadRead: Bool {
        willSet {
            if hadRead == newValue {
                return
            }
            if newValue {
                self.readBall.removeFromSuperview()
            } else {
                self.contentView.addSubview(readBall)
            }
        }
    }
    
    // MARK: - Life Cycle
    
    init() {
        fatalError("init() is unavailable")
    }
    init(frame: CGRect) {
        fatalError("init(frame:) is unavailable")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.hadRead = true
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .default
        self.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(timeLab)
        self.contentView.addSubview(titleLab)
        self.contentView.addSubview(detailLab)
    }
    
    // MARK: - Method
    
    ///基础赋值控件文字
    func draw(title: String, content: String, date: String) {
        self.titleLab.text = title
        self.detailLab.text = content
        self.timeLab.text = date
    }
    
    private func customMultipleChoice() {
        if self.isEditing {
            let imgView = self.subviews.last?.subviews.first
            imgView?.tintColor = UIColor(red: 88 / 255, green: 82 / 255, blue: 255 / 255, alpha: 1)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            self.customMultipleChoice()
        }
        UIView.animate(withDuration: 0.17) {
            self.timeLab.right = self.contentView.superRight - 16
            self.detailLab.stretchRight_(toPointX: self.contentView.superRight, offset: 16)
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.timeLab.top = 26
        self.timeLab.right = self.contentView.superRight - 16
        self.titleLab.centerY = timeLab.centerY
        self.titleLab.left = 30
        self.titleLab.width = 167
        self.detailLab.top = titleLab.bottom + 6
        self.detailLab.left = self.titleLab.left
        self.detailLab.stretchRight_(toPointX: timeLab.right, offset: 5)
        self.readBall.center = CGPoint(x: titleLab.left / 2, y: titleLab.centerY)
        self.customMultipleChoice()
    }
    
    // MARK: - Lazy
    
    //消息时间文本
    private lazy var timeLab: UILabel = {
        let timeLab = UILabel(frame: CGRect(x: 0, y: 10, width: 70, height: 15))
        timeLab.backgroundColor = UIColor.clear
        timeLab.font = UIFont(name: PingFangSC, size: 12)
        timeLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#15315B", alpha: 0.7), dark: UIColor(hexString: "#F0F0F0", alpha: 0.55))
        return timeLab
    }()
    //标题文本
    private lazy var titleLab: UILabel = {
        let titleLab = UILabel(frame: CGRect(x: 30, y: 28, width: 0, height: 22))
        titleLab.stretchRight_(toPointX: self.timeLab.left, offset: 5)
        titleLab.backgroundColor = UIColor.clear
        titleLab.font = UIFont(name: PingFangSCBold, size: 16)
        titleLab.textColor = UIColor(DMNamespace.dm, light: UIColor(red: 17 / 255, green: 44 / 255, blue: 84 / 255, alpha: 1), dark: UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1))
        return titleLab
    }()
    //内容文本
    private lazy var detailLab: UILabel = {
        let detailLab = UILabel(frame: CGRect(x: self.titleLab.left, y: self.titleLab.bottom + 6, width: 0, height: 20))
        detailLab.backgroundColor = UIColor.clear
        detailLab.font = UIFont(name: PingFangSC, size: 14)
        detailLab.textColor = UIColor(DMNamespace.dm, light: UIColor(red: 17 / 255, green: 44 / 255, blue: 84 / 255, alpha: 1), dark: UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1))
        return detailLab
    }()
    //已读标记
    private lazy var readBall: UIView = {
        let readBall = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 6))
        readBall.backgroundColor = UIColor(red: 255 / 255, green: 98 / 255, blue: 98 / 255, alpha: 1)
        readBall.layer.cornerRadius = readBall.width / 2
        readBall.centerY = self.titleLab.centerY
        readBall.right = self.titleLab.left - 5
        return readBall
    }()
}
