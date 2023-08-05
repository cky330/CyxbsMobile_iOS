//
//  ActiveMessageVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/30.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

protocol ActiveMessageVCDelegate: AnyObject {
    ///全部已读的回调
    func activeMessageVC_hadReadAllMessage(vc: ActiveMessageVC)
}

///活动通知控制器
class ActiveMessageVC: UIViewController,
                       UITableViewDelegate,
                       UITableViewDataSource {
    
    weak var delegate: ActiveMessageVCDelegate?
    ///模型
    var sysModel: ActiveMessageModel
    
    // MARK: - Life Cycle
    
    init() {
        fatalError("init() is unavailable")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 根据模型和frame做，如果有模型直接上的那种，但网络请求后，需要手动加载sysModel
    /// - Parameters:
    ///   - model: 暴露的唯一模型
    ///   - frame: 视图大小
    init(activeMessage model: ActiveMessageModel, frame: CGRect) {
        self.sysModel = model
        super.init(nibName: nil, bundle: nil)
        self.view.frame = frame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addSubview(tableView)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let str = self.sysModel.activeMsgAry[indexPath.row].content as NSString? {
            return ActiveMessageCell.heightFor(content: str, width: tableView.width - 2 * 17)
        }
        return .zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sysModel.requestReadFor(indexSet: NSIndexSet(index: indexPath.row)) {
            
        } failure: { error in
            
        }
        
        let message = self.sysModel.activeMsgAry[indexPath.row]
        message.hadRead = true
        let cell = tableView.cellForRow(at: indexPath) as! ActiveMessageCell
        cell.hadRead = true
        
        var needBall = false
        for msg in self.sysModel.activeMsgAry {
            needBall = needBall || !msg.hadRead
        }
        if let delegate = delegate {
            if !needBall {
                delegate.activeMessageVC_hadReadAllMessage(vc: self)
            }
        }
        
        let vc = MessageDetailVC(url: message.articleURL!, useSpecialModel: {
            return (message as UserPublishModel<NSString> as! UserPublishModel<AnyObject>)
        }, moreURL: message.redirectURL)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sysModel.activeMsgAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.sysModel.activeMsgAry[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ActiveMessageCellReuseIdentifier, for: indexPath) as! ActiveMessageCell
        cell.draw(title: message.title!, headURL: message.headURL!, author: message.author!, date: message.uploadDate!, content: message.content!, imageURL: message.picURL)
        cell.hadRead = message.hadRead
        return cell
    }
    
    // MARK: - Method
    
    ///手动刷新所有可能的情况，多用于第一次网络请求
    func hadReadAfterReloadData() -> Bool {
        self.tableView.reloadData()
        var needBall = false
        for msg in self.sysModel.activeMsgAry {
            needBall = needBall || !msg.hadRead
        }
        return needBall
    }
    
    ///全部标为已读，会触发一次代理
    func readAllMessage() {
        let set = NSIndexSet(indexesIn: NSRange(location: 0, length: self.sysModel.activeMsgAry.count))
        self.sysModel.requestReadFor(indexSet: set) {
            //什么都不用干
        } failure: { error in
            // -- 没有网络，请连接网络再次尝试 --
        }
        self.tableView.reloadData()
        if let delegate = delegate {
            delegate.activeMessageVC_hadReadAllMessage(vc: self)
        }
    }
    
    // MARK: - Lazy
    
    //展示信息的tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.superFrame, style: .plain)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#F2F3F8", alpha: 0.8), dark: UIColor(hexString: "#676767", alpha: 0.8))
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(ActiveMessageCell.self, forCellReuseIdentifier: ActiveMessageCellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}
