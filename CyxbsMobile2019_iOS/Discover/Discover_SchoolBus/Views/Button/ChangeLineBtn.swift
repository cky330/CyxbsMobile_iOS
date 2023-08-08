//
//  ChangeLineBtn.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/22.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

/// 切换线路按钮
class ChangeLineBtn: UIButton {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(lineLab)
        self.addSubview(imgView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lazy
    
    /// 线路文本
    lazy var lineLab: UILabel = {
        let lineLab = UILabel(frame: CGRect(x: 12, y: 5, width: 38, height: 20))
        lineLab.font = UIFont(name: PingFangSCBold, size: 14)
        return lineLab
    }()
    /// 双箭头切换标
    lazy var imgView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 54, y: 10, width: 14.05, height: 10.26))
        return imgView
    }()
}
