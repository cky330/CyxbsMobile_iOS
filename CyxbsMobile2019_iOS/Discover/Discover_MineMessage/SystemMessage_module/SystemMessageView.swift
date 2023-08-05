//
//  SystemMessageView.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/30.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

protocol SystemMessageViewDelegate: UITableViewDataSource {
    ///被选中了，执行跳转（其他的情况会自己处理），还会触发标为已读
    func systemMessageTableView(_ view: UITableView, didSelectedAtIndex index: Int)
    ///视图将要删（应该给弹窗确认，yes将掉用删除）
    func systemMessageTableView(_ view: UITableView, willDeletePathWithIndexSet set: IndexSet, showPresent needCancel: @escaping (Bool) -> Void)
    ///应该要删哪些东西
    func systemMessageTableView(_ view: UITableView, mustDeletePathWithIndexSet set: IndexSet)
    ///触发为已读
    func systemMessageTableView(_ view: UITableView, hadReadForIndex index: Int)
}

///系统消息页面
class SystemMessageView: UIView, UITableViewDelegate {
    
    weak var delegate: SystemMessageViewDelegate? {
        willSet {
            if let newValue = newValue {
                self.mainTableView.dataSource = newValue
            }
        }
    }
    ///转发tableView的edit
    var isEditing: Bool {
        get {
            return self.mainTableView.isEditing
        }
        set {
            newValue ? openEdit() : closeEdit()
        }
    }
    
    // MARK: - Life Cycle
    
    init() {
        fatalError("init() is unavailable")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mainTableView)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section != 0) ? 26 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return tableView.isEditing ? .insert : .delete
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteRowAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            self.deleteMsgWith(indexSet: IndexSet(integer: indexPath.section), warn: true)
            completionHandler(true)
        }
        deleteRowAction.image = UIImage(named: "垃圾桶")
        deleteRowAction.backgroundColor = UIColor(red: 74 / 255, green: 68 / 255, blue: 288 / 255, alpha: 1)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteRowAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //没开启编辑时才做跳转，开启编辑则系统
        if !tableView.isEditing {
            if let delegate = delegate {
                //通知已读
                delegate.systemMessageTableView(self.mainTableView, hadReadForIndex: indexPath.section)
                //选中
                delegate.systemMessageTableView(self.mainTableView, didSelectedAtIndex: indexPath.section)
            }
        }
    }
    
    // MARK: - Method
    
    func reloadData() {
        closeEdit()
        mainTableView.reloadData()
    }
    
    private func openEdit() {
        if !self.mainTableView.isEditing {
            self.mainTableView.setEditing(true, animated: true)
            self.addSubview(cancelBtn)
            self.addSubview(deleteBtn)
            self.mainTableView.contentInset = UIEdgeInsets(top: self.mainTableView.contentInset.top, left: 0, bottom: 128, right: 0)
        }
    }
    
    @objc private func closeEdit() {
        self.mainTableView.setEditing(false, animated: true)
        self.cancelBtn.removeFromSuperview()
        self.deleteBtn.removeFromSuperview()
        self.mainTableView.contentInset = UIEdgeInsets(top: self.mainTableView.contentInset.top, left: 0, bottom: 0, right: 0)
    }
    
    @objc private func messageViewLongPress(_ longPress: UILongPressGestureRecognizer) {
        //长按开启编辑
        if longPress.state == .began {
            self.openEdit()
        }
    }
    
    @objc private func clickDeleteBtn(_ btn: UIButton) {
        if self.mainTableView.isEditing {
            if let _ = delegate {
                //将选中的indexPaths转为indexSet
                let set = NSMutableIndexSet()
                if let selectedIndexPaths = self.mainTableView.indexPathsForSelectedRows {
                    for indexPath in selectedIndexPaths {
                        set.add(indexPath.section)
                    }
                }
                //询问是否需要删，要删则官方动画删除
                self.deleteMsgWith(indexSet: set as IndexSet, warn: true)
            }
        }
    }
    
    private func deleteMessageWithIndexSet(_ set: IndexSet) {
        if let delegate = delegate {
            self.mainTableView.beginUpdates()
            delegate.systemMessageTableView(self.mainTableView, mustDeletePathWithIndexSet: set)
            self.mainTableView.deleteSections(set, with: .left)
            self.mainTableView.endUpdates()
            closeEdit()
        }
    }
    
    ///删除信息并确定要不要弹窗
    func deleteMsgWith(indexSet: IndexSet, warn hadWarn: Bool) {
        if let delegate = delegate {
            if hadWarn {
                delegate.systemMessageTableView(self.mainTableView, willDeletePathWithIndexSet: indexSet) { cancel in
                    if !cancel {
                        self.deleteMessageWithIndexSet(indexSet)
                    }
                }
            } else {
                self.deleteMessageWithIndexSet(indexSet)
            }
        }
    }
    
    // MARK: - Lazy
    
    private lazy var mainTableView: UITableView = {
        let mainTableView = UITableView(frame: self.superFrame, style: .plain)
        mainTableView.backgroundColor = UIColor.clear
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        mainTableView.separatorStyle = .none
        mainTableView.register(SystemMessageCell.self, forCellReuseIdentifier: SystemMessageCellReuseIdentifier)
        mainTableView.delegate = self
        mainTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        //长按触发多选
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(messageViewLongPress))
        mainTableView.addGestureRecognizer(longPress)
        return mainTableView
    }()
    //取消多选按钮
    private lazy var cancelBtn: UIButton = {
        let gap = (self.width - 2 * 120) / 3
        let cancelBtn = UIButton(frame: CGRect(x: gap, y: 0, width: 120, height: 40))
        cancelBtn.bottom = self.superBottom - 64
        cancelBtn.layer.cornerRadius = cancelBtn.height / 2
        cancelBtn.clipsToBounds = true
        cancelBtn.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#C3D4EE", alpha: 1), dark: UIColor(hexString: "#484848", alpha: 1))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font = UIFont(name: PingFangSC, size: 18)
        cancelBtn.titleLabel?.textColor = UIColor.white
        cancelBtn.addTarget(self, action: #selector(closeEdit), for: .touchUpInside)
        return cancelBtn
    }()
    //删除多选按钮
    private lazy var deleteBtn: UIButton = {
        let gap = (self.width - 2 * 120) / 3
        let deleteBtn = UIButton(frame: CGRect(x: 0, y: self.cancelBtn.top, width: 120, height: 40))
        deleteBtn.right = self.superRight - gap
        deleteBtn.layer.cornerRadius = deleteBtn.height / 2
        deleteBtn.clipsToBounds = true
        deleteBtn.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#4A44E4", alpha: 1), dark: UIColor(hexString: "#5852FF", alpha: 1))
        deleteBtn.setTitle("删除", for: .normal)
        deleteBtn.titleLabel?.font = UIFont(name: PingFangSC, size: 18)
        deleteBtn.titleLabel?.textColor = UIColor.white
        deleteBtn.addTarget(self, action: #selector(clickDeleteBtn), for: .touchUpInside)
        return deleteBtn
    }()
}
