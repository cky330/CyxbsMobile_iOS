//
//  SystemMessage.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/30.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

///一条我的消息类型
class SystemMessage: UserPublishModel<NSString> {
    
    ///是否已读
    var hadRead = Bool()
    
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
        self.author = dic["user_name"] as? String
        self.headURL = dic["user_head_url"] as? String
        self.content = dic["content"] as? String
        
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
