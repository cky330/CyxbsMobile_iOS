//
//  BusGuideBarView.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/23.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class BusGuideBarView: UIScrollView {
    
    var lineDataAry: [Any] = []
    var stationDataAry: [Any] = []
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(lineLab)
        self.addSubview(runTimeLab)
        self.addSubview(runTypeBtn)
        self.addSubview(sendTypeBtn)
        self.addSubview(lineBtn)
        lineBtn.alpha = 0
        self.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#FFFFFF" , alpha: 1), dark: UIColor(hexString: "#1D1D1D", alpha: 1))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lazy
    
    lazy var lineLab: UILabel = {
        let lineLab = UILabel(frame: CGRect(x: 16, y: 19, width: 200, height: 31))
        lineLab.font = UIFont(name: PingFangSCBold, size: 22)
        lineLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#F0F0F0", alpha: 1))
        return lineLab
    }()
    
    lazy var runTimeLab: UILabel = {
        let runTimeLab = UILabel(frame: CGRect(x: 0, y: 12, width: 160, height: 17))
        runTimeLab.right = self.right - 16
        runTimeLab.font = UIFont(name: PingFangSCLight, size: 12)
        runTimeLab.textAlignment = .right
        runTimeLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#F0F0F0", alpha: 1))
        return runTimeLab
    }()
    
    lazy var sendTypeBtn: UIButton = {
        let sendTypeBtn = UIButton(frame: CGRect(x: 0, y: self.runTimeLab.bottom + 8, width: 62, height: 17))
        sendTypeBtn.right = self.runTypeBtn.left - 8
        sendTypeBtn.titleLabel?.font = UIFont(name: PingFangSCLight, size: 11)
        sendTypeBtn.layer.cornerRadius = sendTypeBtn.height / 2
        sendTypeBtn.isUserInteractionEnabled = false
        sendTypeBtn.setTitleColor(UIColor(DMNamespace.dm, light: UIColor(hexString: "#07BFE1", alpha: 1), dark: UIColor(hexString: "#07BFE1", alpha: 1)), for: .normal)
        sendTypeBtn.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#07BFE1", alpha: 0.09), dark: UIColor(hexString: "#07BFE1", alpha: 0.09))
        return sendTypeBtn
    }()
    
    lazy var runTypeBtn: UIButton = {
        let runTypeBtn = UIButton(frame: CGRect(x: 0, y: self.runTimeLab.bottom + 8, width: 40, height: 19))
        runTypeBtn.right = self.right - 16
        runTypeBtn.titleLabel?.font = UIFont(name: PingFangSCLight, size: 11)
        runTypeBtn.layer.cornerRadius = runTypeBtn.height / 2
        runTypeBtn.isUserInteractionEnabled = false
        runTypeBtn.setTitleColor(UIColor(DMNamespace.dm, light: UIColor(hexString: "#FF45B9", alpha: 1), dark: UIColor(hexString: "#FF45B9", alpha: 1)), for: .normal)
        runTypeBtn.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#FF45B9", alpha: 0.08), dark: UIColor(hexString: "#FF45B9", alpha: 0.08))
        return runTypeBtn
    }()
    
    lazy var lineBtn: ChangeLineBtn = {
        let lineBtn = ChangeLineBtn(frame: CGRect(x: 0, y: 16, width: 80, height: 30))
        lineBtn.right = self.right - 10
        lineBtn.layer.cornerRadius = 16
        return lineBtn
    }()
}
