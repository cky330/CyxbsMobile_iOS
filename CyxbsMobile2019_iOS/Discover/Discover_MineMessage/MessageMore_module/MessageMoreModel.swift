//
//  MessageMoreModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/29.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class MessageMoreModel {
    ///图片
    var msgImg = UIImage()
    ///文字
    var msgStr: String = ""
    
    // MARK: - Life Cycle
    
    init(msgImg img: UIImage, title: String) {
        self.msgImg = img
        self.msgStr = title
    }
    
    // MARK: - Method
    
    ///初始化system模型
    static func systemModels() -> [MessageMoreModel] {
        return [
            MessageMoreModel(msgImg: UIImage(named: "hadread_d")!, title: "一键已读"),
            MessageMoreModel(msgImg: UIImage(named: "delete_read")!, title: "删除已读"),
            MessageMoreModel(msgImg: UIImage(named: "setting")!, title: "设置")
        ]
    }
    
    ///初始化active模型
    static func activeModels() -> [MessageMoreModel] {
        return [
            MessageMoreModel(msgImg: UIImage(named: "hadread_d")!, title: "一键已读"),
            MessageMoreModel(msgImg: UIImage(named: "setting")!, title: "设置")
        ]
    }
}
