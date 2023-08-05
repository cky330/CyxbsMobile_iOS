//
//  DiscoverMineMessageVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/8/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import sqlcipher

///是否有未读消息
let Discover_GET_userHadRead_API = CyxbsMobileBaseURL_1 + "message-system/user/msgHasRead"

///发现首页顶部中消息按钮的小VC
@objcMembers
class DiscoverMineMessageVC: UIViewController {
    
    ///是否需要小红点
    var hadRead = Bool() {
        willSet {
            if hadRead == newValue {
                return
            }
            if newValue {
                self.messageBtn.setImage(UIImage(named: "message_s"), for: .normal)
            } else {
                self.messageBtn.setImage(UIImage(named: "message_d"), for: .normal)
            }
        }
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let cap = 24.0 / 20.0
        self.view.frame = CGRect(x: 0, y: 0, width: 24 * cap, height: 24)
        self.view.addSubview(messageBtn)
        self.hadRead = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    // MARK: - Method
    
    ///刷新，会网络请求
    func reloadData() {
        HttpTool.share().request(Discover_GET_userHadRead_API,
                                 type: .get,
                                 serializer: .HTTP,
                                 bodyParameters: nil,
                                 progress: nil,
                                 success: { task, object in
                                    if let object = object as? [String: Any],
                                       let data = object["data"] as? [String: Any],
                                       let hadRead = data["has"] as? Bool {
                                        self.hadRead = hadRead
                                    }
                                },
                                 failure: { task, error in
                                })
    }
    
    @objc private func discoverMinePushToMineMessage() {
        let vc = MineMessageVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Lazy
    
    private lazy var messageBtn: UIButton = {
        let messageBtn = UIButton(frame: self.view.superFrame)
        messageBtn.setImage(UIImage(named: "message_d"), for: .normal)
        messageBtn.addTarget(self, action: #selector(discoverMinePushToMineMessage), for: .touchUpInside)
        return messageBtn
    }()
}
