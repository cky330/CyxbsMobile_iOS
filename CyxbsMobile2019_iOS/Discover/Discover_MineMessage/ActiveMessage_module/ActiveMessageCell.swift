//
//  ActiveMessageCell.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/29.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

let ActiveMessageCellReuseIdentifier = "ActiveMessageCell"

var activeMessageCellMaxHeight: CGFloat = 0

class ActiveMessageCell: UITableViewCell {
    
    ///是否已读，默认是true，已读没有红点
    var hadRead = Bool() {
        willSet {
            if hadRead == newValue {
                return
            }
            if newValue {
                self.readBall.removeFromSuperview()
            } else {
                self.messageTitleLab.addSubview(readBall)
            }
        }
    }
    //文字高度，快速
    private var fastContentHeight: CGFloat = 0
    
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
        self.backgroundColor = UIColor.clear
        self.hadRead = true
        
        self.contentView.addSubview(messageTitleLab)
        self.contentView.addSubview(headImgView)
        self.contentView.addSubview(authorNameLab)
        self.contentView.addSubview(messageTimeLab)
        self.contentView.addSubview(messageContentLab)
        self.contentView.addSubview(messageImgView)
        activeCellDefaultStyle()
    }
    
    // MARK: - Method
    
    ///计算高度（掉帧算法）
    static func heightFor(content: NSString, width: CGFloat) -> CGFloat {
        let string: NSString = "r\ni\ns\ne"
        activeMessageCellMaxHeight = string.height(for: CGSize(width: width, height: 0), font: UIFont(name: PingFangSC, size: 14)!)
        let contentHeight = content.height(for: CGSize(width: width, height: 0), font: UIFont(name: PingFangSC, size: 14)!)
        //计算高度，由文字最小高度+固定的头部高度+imgeView的计算高度组成
        return (activeMessageCellMaxHeight < contentHeight ? activeMessageCellMaxHeight : contentHeight) + 140 + (SCREEN_WIDTH - 2 * 30) * 193.0 / 343.0
    }
    
    ///设置基础内容，头像和背景都有默认
    func draw(title: String, headURL: String, author: String, date: String, content: String, imageURL: String) {
        self.setNeedsDisplay()
        self.messageTitleLab.text = title
        self.headImgView.setImageWith(URL(string: headURL), placeholder: UIImage(named: "默认头像"))
        self.authorNameLab.text = author
        self.messageTimeLab.text = date
        self.messageContentLab.text = content
        self.messageImgView.setImageWith(URL(string: imageURL), placeholder: UIImage(named: "default_background"))
    }
    
    private func activeCellDefaultStyle() {
        self.messageTitleLab.text = ""
        self.headImgView.image = UIImage(named: "默认头像")
        self.authorNameLab.text = ""
        self.messageTimeLab.text = ""
        self.messageContentLab.text = "\n\n"
        self.messageImgView.image = UIImage(named: "default_background")
    }
    
    override func draw(_ rect: CGRect) {
        self.messageTitleLab.stretchRight_(toPointX: self.contentView.superRight, offset: 30)
        self.authorNameLab.stretchRight_(toPointX: self.messageTitleLab.right, offset: 0)
        self.messageContentLab.width = self.messageTitleLab.width
        if let string = self.messageContentLab.text as NSString? {
            let height = string.height(for: CGSize(width: SCREEN_WIDTH - 2 * 17, height: 0), font: UIFont(name: PingFangSC, size: 14)!)
            self.messageContentLab.height = height < activeMessageCellMaxHeight ? height : activeMessageCellMaxHeight
            self.messageImgView.top = self.messageContentLab.bottom + 12
            self.messageImgView.width = self.messageContentLab.width
            self.messageImgView.height = 193.0 / 343.0 * self.messageImgView.width
        }
    }
    
    // MARK: - Lazy
    
    //标题文本
    private lazy var messageTitleLab: UILabel = {
        let messageTitleLab = UILabel(frame: CGRect(x: 30, y: 24, width: 0, height: 25))
        messageTitleLab.font = UIFont(name: PingFangSC, size: 18)
        messageTitleLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#DFDFE3", alpha: 1))
        return messageTitleLab
    }()
    //头像图片
    private lazy var headImgView: UIImageView = {
        let headImgView = UIImageView(frame: CGRect(x: self.messageTitleLab.left, y: self.messageTitleLab.bottom + 10, width: 28, height: 28))
        headImgView.layer.cornerRadius = headImgView.width / 2
        headImgView.clipsToBounds = true
        headImgView.backgroundColor = UIColor.gray
        return headImgView
    }()
    //作者文本
    private lazy var authorNameLab: UILabel = {
        let authorNameLab = UILabel(frame: CGRect(x: self.headImgView.right + 12, y: self.headImgView.top, width: 0, height: 17))
        authorNameLab.font = UIFont(name: PingFangSC, size: 12)
        authorNameLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#DFDFE3", alpha: 1))
        return authorNameLab
    }()
    //发布时间文本
    private lazy var messageTimeLab: UILabel = {
        let messageTimeLab = UILabel(frame: CGRect(x: self.authorNameLab.left, y: self.authorNameLab.bottom, width: 100, height: 15))
        messageTimeLab.font = UIFont(name: PingFangSC, size: 11)
        messageTimeLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#142C52", alpha: 0.4), dark: UIColor(hexString: "#F0F0F0", alpha: 0.55))
        return messageTimeLab
    }()
    //内容文本（自动布局）
    private lazy var messageContentLab: UILabel = {
        let messageContentLab = UILabel(frame: CGRect(x: self.messageTitleLab.left, y: self.headImgView.bottom + 14, width: 0, height: 80))
        messageContentLab.numberOfLines = 0
        messageContentLab.font = UIFont(name: PingFangSC, size: 14)
        messageContentLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#DFDFE3", alpha: 1))
        return messageContentLab
    }()
    //一个细节图片
    private lazy var messageImgView: UIImageView = {
        let messageImgView = UIImageView(frame: CGRect(x: self.messageTitleLab.left, y: self.messageContentLab.bottom + 12, width: 0, height: 0))
        messageImgView.layer.cornerRadius = 15
        messageImgView.clipsToBounds = true
        messageImgView.contentMode = .scaleToFill
        messageImgView.backgroundColor = UIColor.gray
        return messageImgView
    }()
    //已读标志
    private lazy var readBall: UIView = {
        let readBall = UIView(frame: CGRect(x: -12, y: 0, width: 6, height: 6))
        readBall.centerY = self.messageTitleLab.superCenter.y
        readBall.layer.cornerRadius = readBall.width / 2
        readBall.backgroundColor = UIColor(red: 255 / 255, green: 98 / 255, blue: 98 / 255, alpha: 1)
        return readBall
    }()
}
