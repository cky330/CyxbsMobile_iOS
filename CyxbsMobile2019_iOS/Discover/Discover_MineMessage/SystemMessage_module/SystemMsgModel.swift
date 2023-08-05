//
//  SystemMsgModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/30.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

///删除消息
let Discover_DELETE_sysMsg_API = CyxbsMobileBaseURL_1 + "message-system/user/msg"

class SystemMsgModel {
    
    ///信息集合
    var msgAry: [SystemMessage] = []
    
    // MARK: - Life Cycle
    
    init(array: [[String: Any]]) {
        var mutableAry: [SystemMessage] = []
        for dic in array {
            let message = SystemMessage(dictionary: dic)
            mutableAry.append(message)
        }
        self.msgAry = mutableAry
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
            let message = self.msgAry[idx]
            if let str = message.otherThings as String? {
                idNums.append(str)
            }
            message.hadRead = true
        }
        let parameter: [String: [String]] = ["ids": idNums]
        
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

    /// 先直接删除，再网络请求删除
    /// - Parameters:
    ///   - indexSet: 哪些需要，也作为删除的set标记
    ///   - success: 成功删除
    ///   - failure: 删除失败
    func requestRemoveFor(indexSet: NSIndexSet, success: (() -> Void)?, failure: ((Error) -> Void)?) {
        
        var idNums: [String] = []
        indexSet.enumerate { idx, stop in
            if let str = self.msgAry[idx].otherThings as String? {
                idNums.append(str)
            }
        }
        var ary = self.msgAry
        for set in indexSet.sorted().reversed() {
            ary.remove(at: set)
        }
        self.msgAry = ary
        let parameter: [String: [String]] = ["ids": idNums]
        
        HttpTool.share().request(Discover_DELETE_sysMsg_API,
                                 type: .delete,
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
