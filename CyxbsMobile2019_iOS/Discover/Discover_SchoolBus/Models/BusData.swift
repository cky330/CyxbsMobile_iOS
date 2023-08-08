//
//  BusData.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/18.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

/// 校车数据
class BusData {
    /// 当前校车的纬度
    var latitude: Double = 0.0
    /// 当前校车的经度
    var longitude: Double = 0.0
    /// 校车id
    var busID: Int = 0
    /// 校车线路
    var busLine: Int = 0
    
    // MARK: - Method
    
    // 字典转模型
    private static func busDataWithDic(_ dic: [String: Any]) -> BusData {
        let data = BusData()
        data.latitude = dic["lat"] as? Double ?? 0.0
        data.longitude = dic["lng"] as? Double ?? 0.0
        data.busID = dic["id"] as? Int ?? 0
        data.busLine = dic["type"] as? Int ?? 0
        
        return data
    }
    
    // MD5加密
    private static func md5(str: String) -> String {
        guard let cString = str.cString(using: .utf8) else {
            return ""
        }
        var result = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(cString, CC_LONG(strlen(cString)), &result)
        var mutableStr = String(repeating: "", count: Int(CC_MD5_DIGEST_LENGTH))
        for i in 0..<CC_MD5_DIGEST_LENGTH {
            mutableStr.append(String(format: "%02x", result[Int(i)]))
        }
        return mutableStr
    }
    
    /// 网络请求
    static func requestWith(success: (([Any]) -> Void)?, failure: (() -> Void)?) {
        // 当前时间转时间戳
        let nowDate = Date()
        var timeStamp = String(Int64(nowDate.timeIntervalSince1970 * 1000))
        timeStamp = String(timeStamp.prefix(10))
        
        let s = self.md5(str: timeStamp.appending(".Redrock"))
        let t = timeStamp
        let r = self.md5(str: String(Int(timeStamp)! - 1))
        
        HttpTool.share().form(Discover_POST_schoolBus_API,
                              type: .post,
                              parameters: nil,
                              bodyConstructing: { body in
            // 数据转二进制
            if let sData = s.data(using: .utf8),
               let tData = t.data(using: .utf8),
               let rData = r.data(using: .utf8) {
                // 作为表单数据添加到请求体中
                body.appendPart(withForm: sData, name: "s")
                body.appendPart(withForm: tData, name: "t")
                body.appendPart(withForm: rData, name: "r")
            }
        },
                              progress: nil,
                              success: { task, object in
            guard let obj = object as? [String: Any],
                  let dictionary = obj["data"] as? [String: Any],
                  let array = dictionary["data"] as? [Any] else {
                      return
                  }
            
            var mutableAry: [Any] = []
            
            for item in array {
                guard let dic = item as? [String: Any] else {
                    return
                }
                let data = self.busDataWithDic(dic)
                mutableAry.append(data)
            }
            
            success?(mutableAry)
        },
                              failure: { task, error in
            
        })
    }
}
