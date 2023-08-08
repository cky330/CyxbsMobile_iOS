//
//  BusGuideVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/23.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

let KSCREEN_WIDTH = YYScreenSize().width
let KSCREEN_HEIGHT = YYScreenSize().height

class BusGuideVC: TopBarBasicViewController {
    
    private var stationsAry: [StationData] = []
    private var tableView = UITableView()
    
    // MARK: - Life Cycle
    
    init(stationsAry: [StationData]) {
        super.init(nibName: nil, bundle: nil)
        self.stationsAry = stationsAry
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBusGuideView()
        self.view.addSubview(scrollView)
        
        self.vcTitleStr = "校车指南"
        self.titlePosition = .left
        self.isSplitLineHidden = true
        self.titleFont = UIFont(name: PingFangSCBold, size: 22)!
        self.titleColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#F0F0F0", alpha: 1))
        self.view.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#F8F9FC", alpha: 1), dark: UIColor(hexString: "#1D1D1D", alpha: 1))
    }
    
    // MARK: - Method
    
    private func addBusGuideView() {
        for i in 0..<self.stationsAry.count {
            let busGuideView = BusGuideView(frame: CGRect(x: 0, y: 272 * i, width: Int(KSCREEN_WIDTH), height: 256), andStationData: self.stationsAry[i])
            busGuideView.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#F8F9FC", alpha: 1), dark: UIColor(hexString: "#1D1D1D", alpha: 1))
            let intervalView = UIView(frame: CGRect(x: 0, y: busGuideView.bottom, width: KSCREEN_WIDTH, height: 8))
            intervalView.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#F2F3F8", alpha: 1), dark: UIColor(hexString: "#000000", alpha: 1))
            self.scrollView.addSubview(busGuideView)
            self.scrollView.addSubview(intervalView)
        }
    }
    
    // MARK: - Lazy
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: self.topBarView.bottom, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - self.topBarView.bottom))
        scrollView.bottom = self.view.bottom
        scrollView.contentSize = CGSize(width: KSCREEN_WIDTH, height: CGFloat(264 * self.stationsAry.count))
        return scrollView
    }()
}
