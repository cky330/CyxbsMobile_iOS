//
//  StationScrollView.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/22.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class StationScrollView: UIScrollView {
    
    var stationsViewAry: [StationView] = []
    
    // MARK: - Method
    
    private func addStationsView() {
        var mutableAry: [StationView] = []
        let data = self.stationData
        let count = data.stationsAry.count
        self.contentSize = CGSize(width: count * 46, height: 163)
        for i in 0..<count {
            let view = StationView(frame: CGRect(x: i * 46, y: 0, width: 46, height: 163))
            guard let dic = data.stationsAry[i] as? [String: Any],
                  let str = dic["name"] as? String else {
                      return
                  }
            view.stationLab.text = str
            view.stationLab.tag = i
            if let string = view.stationLab.text {
                view.stationLab.height = string.height(for: view.stationLab.font, width: view.stationLab.width)
            }
            if i == 0 {
                view.frontImgView.image = UIImage(named: "originstation")
                view.backImgView.frame = CGRect(x: 27, y: 8, width: 19, height: 6)
            } else if i == count - 1 {
                view.frontImgView.image = UIImage(named: "terminalstation")
                view.backImgView.frame = CGRect(x: 0, y: 8, width: 25, height: 6)
            }
            view.frontImgView.alpha = 1
            view.backImgView.image = UIImage(named: "busline")
            self.addSubview(view)
            mutableAry.append(view)
        }
        self.stationsViewAry = mutableAry
    }
    
    // MARK: - Setter
    
    var stationData = StationData() {
        didSet {
            self.removeAllSubviews()
            self.addStationsView()
        }
    }
}
