//
//  ActiveMessage.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/29.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

let CyxbsMobileBaseURL_1 = UserDefaults.standard.object(forKey: "baseURL") as! String
///单个md文档转为h5
let Discover_HTML_md_API: (String) -> String = { msgID in
    return CyxbsMobileBaseURL_1 + "message-system/user/html/" + msgID
}

///活动消息
class ActiveMessage: UserPublishModel<NSString> {
    ///第二层级跳转URL
    var redirectURL: String = ""
    ///在外部的一个图片URL
    var picURL: String = ""
    ///是否已读
    var hadRead = Bool()
    ///消息唯一id
    var msgID: Int = 0

    // MARK: - Life Cycle

    override init() {
        fatalError("init() is unavailable")
    }
    
    init(dictionary dic: [String: Any]) {
        super.init()
        
        self.otherThings = dic["id"] as? NSString
        if let str = self.otherThings as String? {
            self.articleURL = Discover_HTML_md_API(str)
        }
        self.identify = dic["stu_num"] as? String
        self.hadRead = dic["has_read"] as! Bool
        self.title = dic["title"] as? String
        self.picURL = dic["pic_url"] as! String
        self.author = dic["user_name"] as? String
        self.headURL = dic["user_head_url"] as? String
        self.content = dic["content"] as? String
        self.redirectURL = dic["redirect_url"] as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let string = dic["date"] as! String
        let dateStr = string.prefix(10)
        if let date = dateFormatter.date(from: String(dateStr)) {
            let uploadDateFormatter = DateFormatter()
            uploadDateFormatter.dateFormat = "yyyy-M-d"
            self.uploadDate = uploadDateFormatter.string(from: date)
        }
    }
}
