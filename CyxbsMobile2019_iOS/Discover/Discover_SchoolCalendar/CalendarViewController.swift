//
//  CalendarViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/26.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

let STATUSBARHEIGHT = UIApplication.shared.statusBarFrame.height
let MAIN_SCREEN_W = UIScreen.main.bounds.width

@objcMembers
class CalendarViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(scrollView)
        self.view.addSubview(backBtn)
        self.scrollView.addSubview(imgView)
        self.view.backgroundColor = UIColor.white
    }

    // MARK: - Method

    @objc private func clickBackBtn() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Lazy

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: STATUSBARHEIGHT, width: self.view.bounds.width, height: self.view.bounds.height - STATUSBARHEIGHT))
        return scrollView
    }()
    //返回按钮
    private lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .system)
        backBtn.frame = CGRect(x: self.view.left + 15, y: self.view.top + STATUSBARHEIGHT + 15, width: 9, height: 19)
        backBtn.setImage(UIImage(named: "calendar_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        return backBtn
    }()
    //校历图片
    private lazy var imgView: UIImageView = {
        let url = URL(string: Discover_schoolCalendar_API)
        let imgView = UIImageView()
        imgView.sd_setImage(with: url) { image, error, cacheType, imageURL in
            guard let image = image else {
                NewQAHud.show(with: "加载失败～", add: self.view)
                return
            }
            imgView.frame = CGRect(x: 0, y: 0, width: MAIN_SCREEN_W, height: image.size.height / image.size.width * MAIN_SCREEN_W)
            self.scrollView.contentSize = CGSize(width: 0, height: imgView.height)
        }
        return imgView
    }()
}
