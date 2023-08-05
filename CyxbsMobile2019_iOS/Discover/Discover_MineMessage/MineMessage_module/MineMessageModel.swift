//
//  MineMessageModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/31.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

///获取所有信息
let Discover_GET_allMsg_API = CyxbsMobileBaseURL_1 + "message-system/user/allMsg"

///整体，在这里进行网络请求
class MineMessageModel {
    
    ///系统消息传递
    var systemMsgModel = SystemMsgModel(array: [])
    ///活动消息传递
    var activeMsgModel = ActiveMessageModel(array: [])
    
    // MARK: - Method
    
    ///网络请求
    func request(success: (() -> Void)?, failure: ((Error) -> Void)?) {
        HttpTool.share().request(Discover_GET_allMsg_API,
                                 type: .get,
                                 serializer: .HTTP,
                                 bodyParameters: nil,
                                 progress: nil,
                                 success: { task, object in
                                    if let object = object as? [String: Any],
                                       let data = object["data"] as? [String: Any],
                                       let systemAry = data["system_msg"] as? [[String: Any]],
                                       let activeAry = data["active_msg"] as? [[String: Any]] {
                                        self.systemMsgModel = SystemMsgModel(array: systemAry)
                                        self.activeMsgModel = ActiveMessageModel(array: activeAry)
                                    }
                                    success?()
                                },
                                 failure: { task, error in
                                    print("🔴\(#fileID):\n\(error)")
                                    failure?(error)
                                })
    }
}
