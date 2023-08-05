//
//  MessageSettingVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/28.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

let USER_DEFAULT = UserDefaults.standard
/// 是否设置了（默认没设置）
let MineMessage_hadSettle_BOOL = "MineMessage_hadSettle"
/// 是否需要活动消息提醒（默认不需要）（静默？）
let MineMessage_needMsgWarn_BOOL = "MineMessage_needMsgWarn"
/// 是否需要签到提醒（默认不需要）（本地）
let MineMessage_needSignWarn_BOOL = "MineMessage_needSignWarn"
/// 签到的本地通知 identifier
let MineMessage_notificationRequest_identifier = "MineMessage_notificationRequest"

class MessageSettingVC: UIViewController,
                        UITableViewDelegate,
                        UITableViewDataSource,
                        MessageSettingCellDelegate {
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(red: 242 / 255, green: 243 / 255, blue: 248 / 255, alpha: 1), dark: UIColor(red: 29 / 255, green: 29 / 255, blue: 29 / 255, alpha: 1))
        self.view.addSubview(topView)
        self.view.addSubview(tableView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let center = UNUserNotificationCenter.current()
        
        if USER_DEFAULT.bool(forKey: MineMessage_needSignWarn_BOOL) {
            var components = DateComponents()
            components.hour = 18
            let content = UNMutableNotificationContent()
            content.title = "今日你签到了吗？"
            content.body = "一定要记得签到哟～"
            content.sound = UNNotificationSound.default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: MineMessage_notificationRequest_identifier, content: content, trigger: trigger)
            center.add(request, withCompletionHandler: nil)
        } else {
            center.removePendingNotificationRequests(withIdentifiers: [MineMessage_notificationRequest_identifier])
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 33
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        let label = UILabel(frame: CGRect(x: 10, y: 4, width: 282, height: 26))
        switch section {
        case 0:
            label.text = "关闭后不再显示活动消息"
        case 1:
            label.text = "打开后18点提醒签到（需要获取系统消息推送权限）"
        default:
            break
        }
        label.font = UIFont(name: PingFangSC, size: 12)
        label.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#15315B", alpha: 0.7), dark: UIColor(hexString: "#F0F0F0", alpha: 0.55))
        view.addSubview(label)
        return view
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageSettingCellReuseIdentifier, for: indexPath) as! MessageSettingCell
        cell.delegate = self
        
        var name: String = ""
        var shouldOn: Bool = false
        switch indexPath.section {
        case 0:
            name = "消息提醒"
            shouldOn = USER_DEFAULT.bool(forKey: MineMessage_needMsgWarn_BOOL)
        case 1:
            name = "签到提醒"
            shouldOn = USER_DEFAULT.bool(forKey: MineMessage_needSignWarn_BOOL)
        default:
            break
        }
        
        cell.draw(title: name, switchOn: shouldOn)
        return cell
    }
    
    // MARK: - MessageSettingCellDelegate
    
    func messageSettingCell(_ cell: MessageSettingCell, swipeSwitch aSwitch: UISwitch) {
        let indexPath = self.tableView.indexPath(for: cell)
        switch indexPath?.section {
        case 0:
            USER_DEFAULT.set(aSwitch.isOn, forKey: MineMessage_needMsgWarn_BOOL)
        case 1:
            USER_DEFAULT.set(aSwitch.isOn, forKey: MineMessage_needSignWarn_BOOL)
        default:
            break
        }
    }
    
    // MARK: - Method
    
    @objc private func messageSettingVC_pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Lazy
    
    //顶部视图
    private lazy var topView: SSRTopBarBaseView = {
        let topView = SSRTopBarBaseView(safeViewHeight: 44)
        topView.hadLine = false
        topView.addTitle("设置", withTitleLay: .left, withStyle: nil)
        topView.addBackButtonTarget(self, action: #selector(messageSettingVC_pop))
        return topView
    }()
    //设置的东西
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 16, y: self.topView.bottom, width: self.view.width - 2 * 16, height: self.view.height - self.topView.bottom), style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentSize = .zero
        tableView.register(MessageSettingCell.self, forCellReuseIdentifier: MessageSettingCellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}
