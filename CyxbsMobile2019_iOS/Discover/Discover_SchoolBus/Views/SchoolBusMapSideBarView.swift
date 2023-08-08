//
//  SchoolBusMapSideBarView.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/20.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

/// 地图侧边控制栏
class SchoolBusMapSideBarView: UIView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(zoomInBtn)
        self.addSubview(zoomOutBtn)
        self.addSubview(orientateBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lazy
    
    /// 放大按钮
    lazy var zoomInBtn: UIButton = {
        let zoomInBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        zoomInBtn.setImage(UIImage(named: "plus.circle"), for: .normal)
        return zoomInBtn
    }()
    /// 缩小按钮
    lazy var zoomOutBtn: UIButton = {
        let zoomOutBtn = UIButton(frame: CGRect(x: 0, y: self.zoomInBtn.bottom + 18, width: self.zoomInBtn.width, height: self.zoomInBtn.height))
        zoomOutBtn.setImage(UIImage(named: "minus.circle"), for: .normal)
        return zoomOutBtn
    }()
    /// 定位按钮
    lazy var orientateBtn: UIButton = {
        let orientateBtn = UIButton(frame: CGRect(x: 0, y: self.zoomOutBtn.bottom + 18, width: 70, height: 70))
        orientateBtn.setImage(UIImage(named: "orientation"), for: .normal)
        return orientateBtn
    }()
}
