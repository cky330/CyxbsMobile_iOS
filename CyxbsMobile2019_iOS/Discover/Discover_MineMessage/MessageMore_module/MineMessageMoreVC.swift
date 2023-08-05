//
//  MineMessageMoreVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/29.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

protocol MineMessageMoreVCDelegate: AnyObject {
    func mineMessageMoreVC(_ vc: MineMessageMoreVC, selectedTitle title: String)
}

///小控制器
class MineMessageMoreVC: UIViewController,
                         UITableViewDelegate,
                         UITableViewDataSource,
                         UIPopoverPresentationControllerDelegate {
    
    weak var delegate: MineMessageMoreVCDelegate?
    //模型
    private var moreModel: [MessageMoreModel] = []
    //临时保存的size
    private var mainSize: CGSize = .zero
    
    // MARK: - Life Cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        //设置弹出的控制器的显示样式
        self.modalPresentationStyle = .popover
        //弹出模式
        self.modalTransitionStyle = .flipHorizontal
        self.preferredContentSize = self.view.size
        
        let popVC = self.popoverPresentationController
        popVC?.canOverlapSourceViewRect = false
        popVC?.permittedArrowDirections = .up
        popVC?.delegate = self
        popVC?.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#F2F2F1", alpha: 1), dark: UIColor(hexString: "#1D1D1D", alpha: 1))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.size = CGSize(width: 120, height: 40)
        self.preferredContentSize = self.view.size
        self.view.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //询问size
        let popVC = self.popoverPresentationController
        let view = popVC?.value(forKeyPath: "popoverView") as! UIView
        view.subviews.first?.removeFromSuperview()
        //询问tag
        let tagValue = popVC?.sourceView?.tag
        var height: CGFloat = 0
        height = tagValue == 0 ? 120 : 80
        self.mainSize = CGSize(width: self.view.width, height: height)
        self.view.size = self.mainSize
        
        self.moreModel = popVC?.sourceView?.tag == 0 ? MessageMoreModel.systemModels() : MessageMoreModel.activeModels()
        self.view.addSubview(tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.preferredContentSize = self.mainSize
        }
        self.tableView.size = self.mainSize
        self.tableView.bottom = self.view.superBottom
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //如果是设置，则取消小红点（之后可以封装）
        let model = self.moreModel[indexPath.row]
        if model.msgStr == "设置" {
            let cell = tableView.cellForRow(at: indexPath) as! MessageMoreCell
            cell.needBall = false
        }
        self.dismiss(animated: true, completion: nil)
        if let delegate = self.delegate {
            delegate.mineMessageMoreVC(self, selectedTitle: model.msgStr)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moreModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.moreModel[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageMoreCellReuseIdentifier, for: indexPath) as! MessageMoreCell
        
        cell.draw(img: model.msgImg, title: model.msgStr)
        if model.msgStr == "设置" {
            cell.needBall = !USER_DEFAULT.bool(forKey: MineMessage_hadSettle_BOOL)
        }
        return cell
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: - Lazy
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 13, width: 120, height: 60), style: .plain)
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(MessageMoreCell.self, forCellReuseIdentifier: MessageMoreCellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#FFFFFF", alpha: 1), dark: UIColor(hexString: "#2C2C2C", alpha: 1))
        return tableView
    }()
}
