//
//  ActiveMessageModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/29.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

///更改已读状态
let Discover_PUT_hasRead_API = CyxbsMobileBaseURL_1 + "message-system/user/msgHasRead"

///活动消息模型
class ActiveMessageModel {
    ///活动消息
    var activeMsgAry: [ActiveMessage] = []
    
    // MARK: - Life Cycle
    
    init(array: [[String: Any]]) {
        var ary: [ActiveMessage] = []
        for dic: [String: Any] in array {
            let message = ActiveMessage(dictionary: dic)
            ary.append(message)
        }
        self.activeMsgAry = ary
    }
    
    // MARK: - Method
    
    /// 先自己标为已读，再网络标为已读
    /// - Parameters:
    ///   - indexSet: 哪些需要，可以自动判断原先是否已读
    ///   - success: 标记成功，基本可以不用管
    ///   - failure: 标记失败，返回错误信息
    func requestReadFor(indexSet: NSIndexSet, success: (() -> Void)?, failure: ((Error) -> Void)?) {
        
        var idNums: [String] = []
        indexSet.enumerate { idx, stop in
            let message = self.activeMsgAry[idx]
            if let str = message.otherThings as String? {
                idNums.append(str)
            }
            message.hadRead = true
        }
        let parameter: [String: [String]] = ["ids": idNums]
        //网络请求:put 已读
        HttpTool.share().request(Discover_PUT_hasRead_API,
                                 type: .put,
                                 serializer: .JSON,
                                 bodyParameters: parameter,
                                 progress: nil,
                                 success: { task, respon in
                                    success?()
                                },
                                 failure: { task, error in
                                    failure?(error)
                                })
    }
}
