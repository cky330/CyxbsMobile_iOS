//
//  StationData.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/20.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

/// 站点数据
class StationData {
    /// 线路id（x
    var lineID: Int = 0
    /// 线路名称（x号线
    var lineName: String = ""
    /// 运营时间
    var runTime: String = ""
    /// 发车方式（单向/双向
    var sendType: String = ""
    /// 运行方式（往返/环线
    var runType: String = ""
    /// 站点
    var stationsAry: [Any] = []
    
    // MARK: - Method
    
    private static func stationDataWithDic(_ dic: [String: Any]) -> StationData {
        let data = StationData()
        data.lineID = dic["id"] as? Int ?? 0
        data.lineName = dic["name"] as? String ?? ""
        data.runTime = dic["run_time"] as? String ?? ""
        data.sendType = dic["send_type"] as? String ?? ""
        data.runType = dic["run_type"] as? String ?? ""
        
        var mutableAry: [Any] = []
        guard let stations = dic["stations"] as? [String: Any] else {
            return data
        }
        for station in stations {
            mutableAry.append(station)
        }
        
        data.stationsAry = mutableAry
        
        return data
    }
    
    /// 网络请求
    static func requestWith(success: (([StationData]) -> Void)?, failure: ((Error) -> Void)?) {
        HttpTool.share().request(Discover_GET_schoolStation_API,
                                 type: .get,
                                 serializer: .HTTP,
                                 bodyParameters: nil,
                                 progress: nil,
                                 success: { task, object in
            guard let obj = object as? [String: Any],
                  let dictionary = obj["data"] as? [String: Any],
                  let array = dictionary["lines"] as? [Any] else {
                      return
                  }
            
            var mutableAry: [StationData] = []
            
            for item in array {
                guard let dic = item as? [String: Any] else {
                    return
                }
                let data = self.stationDataWithDic(dic)
                mutableAry.append(data)
            }
            
            success?(mutableAry)
        },
                                 failure: { task, error in
            failure?(error)
        })
    }
}
