//
//  BusGuideView.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/22.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

/// 校车指南页
class BusGuideView: UIView {
    
    private var stationsAry: [Any] = []
    
    // MARK: - Life Cycle
    
    init(frame: CGRect, andStationData data: StationData) {
        super.init(frame: frame)
        self.stationsAry = data.stationsAry
        self.busImgView.image = UIImage(named: self.busImgNameAry[data.lineID])
        self.busLineLab.text = data.lineName
        self.runTimeLab.text = data.runTime
        self.runTypeBtn.setTitle(data.runType, for: .normal)
        self.sendTypeBtn.setTitle(data.sendType, for: .normal)
        self.stationScrollView.stationData = data
        self.addSubview(busImgView)
        self.addSubview(busLineLab)
        self.addSubview(runTimeLab)
        self.addSubview(runTypeBtn)
        self.addSubview(sendTypeBtn)
        self.addSubview(stationScrollView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lazy
    
    private lazy var stationScrollView: StationScrollView = {
        let stationScrollView = StationScrollView(frame: CGRect(x: 0, y: 65, width: KSCREEN_WIDTH, height: 163))
        stationScrollView.showsVerticalScrollIndicator = false
        stationScrollView.showsHorizontalScrollIndicator = false
        return stationScrollView
    }()
    // 校车图片
    private lazy var busImgView: UIImageView = {
        let busImgView = UIImageView(frame: CGRect(x: 16, y: 24, width: 36, height: 36))
        return busImgView
    }()
    // 校车线路文本
    private lazy var busLineLab: UILabel = {
        let busLineLab = UILabel(frame: CGRect(x: 68, y: 27, width: 200, height: 31))
        busLineLab.font = UIFont(name: PingFangSCBold, size: 22)
        busLineLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#F0F0F0", alpha: 1))
        return busLineLab
    }()
    // 运营时间文本
    private lazy var runTimeLab: UILabel = {
        let runTimeLab = UILabel(frame: CGRect(x: 0, y: 12, width: 160, height: 17))
        runTimeLab.right = self.right - 16
        runTimeLab.font = UIFont(name: PingFangSCLight, size: 12)
        runTimeLab.textAlignment = .right
        runTimeLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#F0F0F0", alpha: 1))
        return runTimeLab
    }()
    // 发车方式按钮
    private lazy var sendTypeBtn: UIButton = {
        let sendTypeBtn = UIButton(frame: CGRect(x: 0, y: self.runTimeLab.bottom + 8, width: 62, height: 17))
        sendTypeBtn.right = self.runTimeLab.left - 8
        sendTypeBtn.titleLabel?.font = UIFont(name: PingFangSCLight, size: 11)
        sendTypeBtn.layer.cornerRadius = sendTypeBtn.height / 2
        sendTypeBtn.isUserInteractionEnabled = false
        sendTypeBtn.setTitleColor(UIColor(DMNamespace.dm, light: UIColor(hexString: "#07BFE1", alpha: 1), dark: UIColor(hexString: "#07BFE1", alpha: 1)), for: .normal)
        sendTypeBtn.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#07BFE1", alpha: 0.09), dark: UIColor(hexString: "#07BFE1", alpha: 0.09))
        return sendTypeBtn
    }()
    // 运行方式按钮
    private lazy var runTypeBtn: UIButton = {
        let runTypeBtn = UIButton(frame: CGRect(x: 0, y: self.runTimeLab.bottom + 8, width: 40, height: 19))
        runTypeBtn.right = self.right - 16
        runTypeBtn.titleLabel?.font = UIFont(name: PingFangSCLight, size: 11)
        runTypeBtn.layer.cornerRadius = runTypeBtn.height / 2
        runTypeBtn.isUserInteractionEnabled = false
        runTypeBtn.setTitleColor(UIColor(DMNamespace.dm, light: UIColor(hexString: "#FF45B9", alpha: 1), dark: UIColor(hexString: "#FF45B9", alpha: 1)), for: .normal)
        runTypeBtn.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#FF45B9", alpha: 0.08), dark: UIColor(hexString: "#FF45B9", alpha: 0.08))
        return runTypeBtn
    }()
    // 校车图片名
    private lazy var busImgNameAry: [String] = {
        let busImgNameAry = ["PinkBus", "OrangeBus", "BlueBus", "GreenBus", "Compass"]
        return busImgNameAry
    }()
}
