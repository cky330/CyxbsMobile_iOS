//
//  StationView.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/20.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class StationView: UIView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(frontImgView)
        self.addSubview(backImgView)
        self.addSubview(stationLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lazy
    
    /// “始”/“终”
    lazy var frontImgView: UIImageView = {
        let frontImgView = UIImageView(frame: CGRect(x: 16, y: 0, width: 24, height: 24))
        frontImgView.image = UIImage(named: "arrow")
        frontImgView.alpha = 0
        return frontImgView
    }()
    /// 线
    lazy var backImgView: UIImageView = {
        let backImgView = UIImageView(frame: CGRect(x: 0, y: 8, width: 46, height: 6))
        backImgView.image = UIImage(named: "busline.arrow")
        return backImgView
    }()
    
    lazy var stationLab: UILabel = {
        let stationLab = UILabel(frame: CGRect(x: 16, y: 22, width: 18, height: 145))
        stationLab.textAlignment = .center
        stationLab.numberOfLines = 0
        stationLab.font = UIFont(name: PingFangSCLight, size: 12)
        stationLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#2A4E84", alpha: 1), dark: UIColor(hexString: "#F0F0F0", alpha: 1))
        return stationLab
    }()
}
