//
//  MessageSettingCell.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/28.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

let MessageSettingCellReuseIdentifier = "MessageSettingCell"

protocol MessageSettingCellDelegate: AnyObject {
    func messageSettingCell(_ cell: MessageSettingCell, swipeSwitch aSwitch: UISwitch)
}

class MessageSettingCell: UITableViewCell {
    
    weak var delegate: MessageSettingCellDelegate?
    
    ///开关是否已打开，默认没打开
    var switchOn: Bool {
        get {
            return self.messageSwitch.isOn
        }
        set {
            self.messageSwitch.setOn(newValue, animated: false)
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
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.accessoryView = self.messageSwitch
        self.contentView.addSubview(messageTitleLab)
        self.contentView.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#FFFFFF", alpha: 1), dark: UIColor(hexString: "#2C2C2C", alpha: 1))
        self.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#FFFFFF", alpha: 1), dark: UIColor(hexString: "#2C2C2C", alpha: 1))
    }
    
    // MARK: - Method
    
    @objc private func swipeSwitch(_ switch: UISwitch) {
        if let delegate = self.delegate {
            delegate.messageSettingCell(self, swipeSwitch: self.messageSwitch)
        }
    }
    
    func draw(title: String, switchOn: Bool) {
        self.messageTitleLab.text = title
        self.switchOn = switchOn
    }
    
    override func draw(_ rect: CGRect) {
        self.messageTitleLab.centerY = self.contentView.superCenter.y
    }
    
    // MARK: - Lazy
    
    //标题文本
    private lazy var messageTitleLab: UILabel = {
        let messageTitleLab = UILabel(frame: CGRect(x: 10, y: 14, width: 162, height: 22))
        messageTitleLab.font = UIFont(name: PingFangSCBold, size: 16)
        messageTitleLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#F0F0F0", alpha: 1))
        return messageTitleLab
    }()
    //开关
    private lazy var messageSwitch: UISwitch = {
        let messageSwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        messageSwitch.onTintColor = UIColor(red: 42 / 255, green: 33 / 255, blue: 209 / 255, alpha: 1)
        messageSwitch.subviews.first?.subviews.first?.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#C3D4EE", alpha: 1), dark: UIColor(hexString: "#5A5A5A", alpha: 1))
        messageSwitch.addTarget(self, action: #selector(swipeSwitch), for: .valueChanged)
        return messageSwitch
    }()    
}
