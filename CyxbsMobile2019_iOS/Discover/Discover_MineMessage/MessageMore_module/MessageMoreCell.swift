//
//  MessageMoreCell.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/29.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

let MessageMoreCellReuseIdentifier = "MessageMoreCell"

class MessageMoreCell: UITableViewCell {
    
    ///是否需要ball
    var needBall: Bool {
        willSet {
            if newValue {
                self.imgView.image = UIImage(named: "setting_s")
            } else {
                self.imgView.image = UIImage(named: "setting")
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
        self.needBall = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(imgView)
        self.contentView.addSubview(titleLab)
    }
    
    // MARK: - Method
    
    func draw(img: UIImage, title: String) {
        self.imgView.image = img
        self.titleLab.text = title
    }
    
    override func draw(_ rect: CGRect) {
        self.imgView.centerY = self.contentView.superCenter.y
        self.titleLab.left = self.imgView.right + 15
        self.titleLab.top = self.imgView.top
        self.titleLab.stretchRight_(toPointX: self.contentView.right, offset: 15)
    }
    
    // MARK: - Lazy
    
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 12, y: 0, width: 18, height: 18))
        return imgView
    }()
    
    private lazy var titleLab: UILabel = {
        let titleLab = UILabel(frame: CGRect(x: 0, y: 0, width: 58, height: 20))
        titleLab.font = UIFont(name: PingFangSC, size: 14)
        titleLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#DFDFE3", alpha: 1))
        return titleLab
    }()
}
