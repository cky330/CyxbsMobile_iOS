//
//  MessageDetailTitleView.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/28.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class MessageDetailTitleView: UIView {
    
    var userPublishModel = UserPublishModel<AnyObject>()
    
    // MARK: - Life Cycle
    
    init() {
        fatalError("init() is unavailable")
    }
    override init(frame: CGRect) {
        fatalError("init(frame:) is unavailable")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 使用这个来创建
    /// - Parameters:
    ///   - width: 指定宽度（高度已自适应
    ///   - model: 奇怪的模型
    init(width: CGFloat, specialUserPublishModel model: UserPublishModel<AnyObject>) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        
        self.userPublishModel = model
        self.addSubview(titleLab)
        if let _ = model.headURL , model.headURL != "" , let _ = model.author {
            //状态：多
            self.addSubview(headImgView)
            self.addSubview(userLab)
            self.addSubview(timeLab)
            self.timeLab.left = userLab.left
            self.timeLab.top = userLab.bottom
        } else {
            //状态：少
            self.addSubview(timeLab)
            self.timeLab.left = titleLab.left
            self.timeLab.top = titleLab.bottom + 8
        }
        self.height = timeLab.bottom
    }
    
    // MARK: - Lazy

    //标题文本
    private lazy var titleLab: UILabel = {
        let titleLab = UILabel(frame: CGRect(x: 0, y: 0, width: self.width, height: 0))
        titleLab.font = UIFont(name: PingFangSCBold, size: 22)
        titleLab.height = self.userPublishModel.title!.height(for: titleLab.font, width: self.width)
        titleLab.numberOfLines = 0
        titleLab.text = self.userPublishModel.title
        titleLab.backgroundColor = UIColor.clear
        titleLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#F0F0F0", alpha: 1))
        return titleLab
    }()
    //头像图片
    private lazy var headImgView: UIImageView = {
        let headImgView = UIImageView(frame: CGRect(x: 0, y: self.titleLab.bottom + 12, width: 28, height: 28))
        headImgView.layer.cornerRadius = headImgView.width / 2
        headImgView.clipsToBounds = true
        headImgView.setImageWith(URL(string: self.userPublishModel.headURL!), placeholder: UIImage(named: "默认头像"))
        return headImgView
    }()
    //名字文本
    private lazy var userLab: UILabel = {
        let userLab = UILabel(frame: CGRect(x: self.headImgView.right + 12, y: self.headImgView.top, width: 0, height: 17))
        userLab.stretchRight_(toPointX: self.titleLab.right, offset: 0)
        userLab.font = UIFont(name: PingFangSC, size: 12)
        userLab.text = self.userPublishModel.author
        userLab.backgroundColor = UIColor.clear
        userLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#F0F0F0", alpha: 1))
        return userLab
    }()
    //时间文本
    private lazy var timeLab: UILabel = {
        let timeLab = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 15))
        timeLab.text = self.userPublishModel.uploadDate
        timeLab.font = UIFont(name: PingFangSC, size: 11)
        timeLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#142C52", alpha: 0.4), dark: UIColor(hexString: "#F0F0F0", alpha: 0.55))
        return timeLab
    }()
}
