//
//  SystemMessageVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/31.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

protocol SystemMessageVCDelegate: AnyObject {
    func systemMessageVC_hadReadAllMsg(vc: SystemMessageVC)
}

///系统消息
class SystemMessageVC: UIViewController,
                       UITableViewDataSource,
                       SystemMessageViewDelegate {
    
    var sysMsgModel: SystemMsgModel
    weak var delegate: SystemMessageVCDelegate?
    
    override var isEditing: Bool {
        get {
            return self.messageView.isEditing
        }
        set {
            self.messageView.isEditing = newValue
        }
    }
    
    // MARK: - Life Cycle
    
    init() {
        fatalError("init() is unavailable")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///根据模型传入，如果模型未加载，请手动reloadData
    init(systemMessage model: SystemMsgModel, frame: CGRect) {
        self.sysMsgModel = model
        super.init(nibName: nil, bundle: nil)
        self.view.frame = frame
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(messageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.messageView.isEditing = false
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sysMsgModel.msgAry.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.sysMsgModel.msgAry[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: SystemMessageCellReuseIdentifier, for: indexPath) as! SystemMessageCell
        cell.draw(title: model.title!, content: model.content!, date: model.uploadDate!)
        cell.hadRead = model.hadRead
        return cell
    }
    
    // MARK: - SystemMessageViewDelegate
    
    func systemMessageTableView(_ view: UITableView, didSelectedAtIndex index: Int) {
        let message = self.sysMsgModel.msgAry[index]
        let vc = MessageDetailVC(url: message.articleURL!, useSpecialModel: {
            message.hadRead = Bool()
            message.author = ""
            return (message as UserPublishModel<NSString> as! UserPublishModel<AnyObject>)
        }, moreURL: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func systemMessageTableView(_ view: UITableView, willDeletePathWithIndexSet set: IndexSet, showPresent needCancel: @escaping (Bool) -> Void) {
        //是否需要删
        let ary = set.map { self.sysMsgModel.msgAry[$0] }
        var notReadCount = 0
        for message in ary {
            if !message.hadRead {
                notReadCount += 1
            }
        }
        //PC
        let pc = MessagePresentController()
        if notReadCount == 0 {
            //0: 确定要删除选中ary.count条信息吗
            pc.addDetail("确定要删除选中\(ary.count)条信息吗")
        } else if notReadCount == 1 && ary.count == 1 {
            //1: 此条消息未读\n确定删除此消息吗
            pc.addTitle("此条消息未读", titleColor: UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#DFDFE3", alpha: 1)))
            pc.addDetail("确认删除此消息吗")
        } else {
            //♾️: 选中的信息包含notReadCount条未读信息，\n确定删除选中的ary.count条消息吗
            pc.addTitle("选中的信息包含\(notReadCount)条未读信息,", titleColor: UIColor(DMNamespace.dm, light: UIColor(hexString: "#4944E3", alpha: 1), dark: UIColor(hexString: "#9A97FF", alpha: 1)))
            pc.addDetail("确定删除选中的\(ary.count)条消息吗？")
        }
        pc.addDismiss(touchCancel: needCancel)
        self.navigationController?.present(pc, animated: false, completion: nil)
    }
    
    func systemMessageTableView(_ view: UITableView, mustDeletePathWithIndexSet set: IndexSet) {
        //直接删
        self.sysMsgModel.requestRemoveFor(indexSet: set as NSIndexSet) {
            
        } failure: { error in
            
        }
    }
    
    func systemMessageTableView(_ view: UITableView, hadReadForIndex index: Int) {
        //直接已读
        self.sysMsgModel.requestReadFor(indexSet: NSIndexSet(index: index)) {
            
        } failure: { error in
            
        }
        var needBall = false
        for message in self.sysMsgModel.msgAry {
            needBall = needBall || !message.hadRead
        }
        if !needBall {
            if let delegate = delegate {
                delegate.systemMessageVC_hadReadAllMsg(vc: self)
            }
        }
        let cell = view.cellForRow(at: IndexPath(row: 0, section: index)) as! SystemMessageCell
        cell.hadRead = true
    }
    
    // MARK: - Method
    
    ///手动刷新，刷新所有可能的情况，多用于第一次网络请求
    func hadReadAfterReloadData() -> Bool {
        self.messageView.reloadData()
        var needBall = false
        for message in self.sysMsgModel.msgAry {
            needBall = needBall || !message.hadRead
        }
        return needBall
    }
    
    ///全部标为已读，会触发一次代理
    func readAllMessage() {
        let set = NSIndexSet(indexesIn: NSRange(location: 0, length: self.sysMsgModel.msgAry.count))
        self.sysMsgModel.requestReadFor(indexSet: set) {
            NewQAHud.show(with: "已全部已读", add: self.view)
        } failure: { error in
            NewQAHud.show(with: "无法连接网络", add: self.view)
        }
        self.messageView.reloadData()
        if let delegate = delegate {
            delegate.systemMessageVC_hadReadAllMsg(vc: self)
        }
    }
    
    ///删除所有信息
    func deleteAllReadMessage() {
        let pc = MessagePresentController()
        pc.addDetail("确定删除所有已读信息吗")
        self.navigationController?.present(pc, animated: false, completion: nil)
        pc.addDismiss { cancel in
            //不是取消（那就删）
            if !cancel {
                var set = IndexSet()
                for i in 0..<self.sysMsgModel.msgAry.count {
                    if self.sysMsgModel.msgAry[i].hadRead {
                        set.insert(i)
                    }
                }
                self.messageView.deleteMsgWith(indexSet: set, warn: false)
            }
        }
    }
    
    // MARK: - Lazy
    
    private lazy var messageView: SystemMessageView = {
        let messageView = SystemMessageView(frame: self.view.superFrame)
        messageView.delegate = self
        return messageView
    }()
}
