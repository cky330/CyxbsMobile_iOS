//
//  SchoolBusVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/23.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

@objcMembers
class SchoolBusVC: UIViewController,
                   SchoolBusBottomViewDelegate,
                   SchoolBusMapViewDelegate {

    // 授权定位
    private var locationManager = CLLocationManager()
    // 所有数据
    private var stationAry: [StationData] = []
    // 所有站的标记点
    private var stationPointAry: [Any] = []
    // 被选中标记点的线路数组
    private var selectedLineAry: [Any] = []
    // 被选中站点在线路中的位置数组
    private var selectedStationAry: [Any] = []
    // 被选中站点属于几条线路
    private var selectedIndex: Int = 0
    // 被选中校车 站点
    private var selectedName: String = ""
    // 被选中校车 站点经纬度
    private var selectedCoordinate = CLLocationCoordinate2D()
    // 被选中的是否是校车
    private var selectedIsBus: Bool = false

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLocationPermissionVerifcationWithController()
        self.setUpStationData()
        self.view.addSubview(mapView)
        self.mapView.addSubview(mapSideBarView)
        self.mapView.addSubview(bottomView)
        self.view.addSubview(busGuideBarView)
        self.view.addSubview(stationScrollView)
    }

    override func viewDidAppear(_ animated: Bool) {
        if !self.stationAry.isEmpty {
            self.stationScrollView.stationData = self.stationAry[0]
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.mapView.timer.invalidate()
    }

    // MARK: - SchoolBusBottomViewDelegate

    func schoolBusBottomView(_ view: SchoolBusBottomView, didSelectedBtnWithIndex index: Int, isSelected: Bool) {
        self.showLines(index: index, isSelected: isSelected)
        if !self.stationAry.isEmpty {
            // 第五个按钮不调用（index为0会越界
            if index > 0 {
                // 更新站点数据
                self.stationScrollView.stationData = self.stationAry[index - 1]
            }
            if isSelected == false && index > 0 {
                var mutableAry: [Any] = []
                let data = self.stationAry[index - 1]
                // 设置stationBar数据
                self.setGuideBarViewWithData(data)
                if self.selectedName != "" && self.selectedIsBus == true {
                    let circlePointAnnotation = CircleMAPointAnnotation()
                    circlePointAnnotation.title = self.selectedName
                    circlePointAnnotation.subtitle = data.lineName
                    circlePointAnnotation.coordinate = CLLocationCoordinate2D(latitude: self.selectedCoordinate.latitude, longitude: self.selectedCoordinate.longitude)
                    mutableAry.append(circlePointAnnotation)
                }
                for j in 0..<data.stationsAry.count {
                    let pointAnnotation = MAPointAnnotation()
                    guard let dic = data.stationsAry[j] as? [String: Any],
                          let str = dic["name"] as? String else {
                        return
                    }
                    pointAnnotation.title = str
                    pointAnnotation.subtitle = data.lineName
                    guard let dic = data.stationsAry[j] as? [String: Any],
                          let lat = dic["lat"] as? Double,
                          let lng = dic["lng"] as? Double else {
                        return
                    }
                    pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)

                    if self.selectedName == str {
                        let circlePointAnnotation = CircleMAPointAnnotation()
                        circlePointAnnotation.title = str
                        circlePointAnnotation.subtitle = data.lineName
                        circlePointAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        mutableAry.append(circlePointAnnotation)
                    }
                    mutableAry.append(pointAnnotation)
                }
                self.mapView.updateStationAnnotation(stationAry: mutableAry)

            } else {
                self.mapView.updateStationAnnotation(stationAry: self.stationPointAry)
                self.selectedName = ""
            }
            self.selectedIsBus = false
        }
    }

    // MARK: - SchoolBusMapViewDelegate

    func clickBackBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func schoolBusMapView(_ view: SchoolBusMapView, didSelectedAnnotation annotationView: MAAnnotationView) {
        
        let titleName = annotationView.annotation.title
        let subtitleName = annotationView.annotation.subtitle
        
        guard let titleName = titleName,
              let subtitleName = subtitleName else {
                  return
              }
        guard let titleName = titleName,
              let subtitleName = subtitleName else {
                  return
              }
        
        // 点击的是车辆
        if titleName.contains("BusID") {
            self.selectedIsBus = true
            self.selectedName = subtitleName
            self.selectedCoordinate = annotationView.annotation.coordinate
            if subtitleName.contains("1") {
                self.bottomView.busBtnControllerWithBtnTag(1)
            } else if subtitleName.contains("2") {
                self.bottomView.busBtnControllerWithBtnTag(2)
            } else if subtitleName.contains("3") {
                self.bottomView.busBtnControllerWithBtnTag(3)
            } else if subtitleName.contains("4") {
                self.bottomView.busBtnControllerWithBtnTag(4)
            }
        // 点击的是站点
        } else {
            self.selectedName = titleName
            var mutableLineAry: [Any] = []
            var mutableStationAry: [Any] = []
            for i in 0..<self.stationAry.count {
                let data: StationData = self.stationAry[i]
                for j in 0..<data.stationsAry.count {
                    guard let dic = data.stationsAry[j] as? [String: Any],
                          let str = dic["name"] as? String else {
                              return
                          }
                    if str == titleName {
                        mutableLineAry.append(data.lineID + 1)
                        mutableStationAry.append(j)
                    }
                }
            }
            self.selectedLineAry = mutableLineAry
            self.selectedStationAry = mutableStationAry
            self.showSelectedLineWithSelectedLineAry(mutableLineAry)
        }
    }

    // MARK: - Method

    // 定位授权
    private func getLocationPermissionVerifcationWithController() {
        // 检查是否开启位置服务
        let enable = CLLocationManager.locationServicesEnabled()
        // 获取位置权限状态
        let state = CLLocationManager.authorizationStatus().rawValue
        // 尚未授权位置权限
        if !enable || state < 2 {
            // 系统版本号大于8.0
            if Double(UIDevice.systemVersion()) >= 8 {
                // 系统位置权限授权弹窗
                self.locationManager = CLLocationManager()
//                self.locationManager.delegate = self
                // 使用该方法请求位置权限后，应用只能在前台使用位置服务
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    // 获取数据
    private func setUpStationData() {
        StationData.requestWith { array in
            self.stationAry = array
            var mutableAry: [Any] = []
            for i in 0..<array.count {
                let data = array[i]
                for j in 0..<data.stationsAry.count {
                    let pointAnnotation = StationMAPointAnnotation()
                    guard let dic = data.stationsAry[j] as? [String: Any],
                          let str = dic["name"] as? String else {
                              return
                          }
                    pointAnnotation.title = str
                    pointAnnotation.subtitle = data.lineName
                    pointAnnotation.ID = 0
                    guard let lat = dic["lat"] as? Double,
                          let lng = dic["lng"] as? Double else {
                              return
                          }
                    pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                    mutableAry.append(pointAnnotation)
                }
            }
            self.stationPointAry = mutableAry
            self.mapView.updateStationAnnotation(stationAry: mutableAry)
        } failure: {_ in

        }
    }
    // 展示BusGuide
    private func showLines(index: Int, isSelected: Bool) {
        if index > 0 && isSelected == false {
            // 向上平移
            UIView.animate(withDuration: 0.3) {
                self.mapView.mapView.transform = CGAffineTransform(translationX: 0, y: -159)
                self.bottomView.transform = CGAffineTransform(translationX: 0, y: -239)
                self.busGuideBarView.transform = CGAffineTransform(translationX: 0, y: -239)
                self.mapSideBarView.transform = CGAffineTransform(translationX: 0, y: -239)
                self.stationScrollView.transform = CGAffineTransform(translationX: 0, y: -239)
            }
        } else if index == 0 {
            // 恢复至原位
            UIView.animate(withDuration: 0.3) {
                self.mapView.mapView.transform = .identity
                self.bottomView.transform = .identity
                self.busGuideBarView.transform = .identity
                self.mapSideBarView.transform = .identity
                self.stationScrollView.transform = .identity
            }
            // 跳转
            let busGuideVC = BusGuideVC(stationsAry: self.stationAry)
            self.navigationController?.pushViewController(busGuideVC, animated: true)
        } else if isSelected == true {
            // 恢复至原位
            UIView.animate(withDuration: 0.3) {
                self.mapView.mapView.transform = .identity
                self.bottomView.transform = .identity
                self.busGuideBarView.transform = .identity
                self.mapSideBarView.transform = .identity
                self.stationScrollView.transform = .identity
            }
        }
    }
    // 设置stationBar数据
    private func setGuideBarViewWithData(_ data: StationData) {
        self.busGuideBarView.lineBtn.alpha = 0
        self.busGuideBarView.lineLab.text = data.lineName
        self.busGuideBarView.runTimeLab.alpha = 1
        self.busGuideBarView.runTimeLab.text = "运行时间：" + data.runTime
        self.busGuideBarView.runTypeBtn.alpha = 1
        self.busGuideBarView.runTypeBtn.setTitle(data.runType, for: .normal)
        self.busGuideBarView.sendTypeBtn.alpha = 1
        self.busGuideBarView.sendTypeBtn.setTitle(data.sendType, for: .normal)
    }
    // 放大地图
    @objc private func zoomInView() {
        self.mapView.mapView.zoomLevel += 1
    }
    // 缩小地图
    @objc private func zoomOutView() {
        self.mapView.mapView.zoomLevel -= 1
    }
    // 将地图视图的中心坐标设置为当前用户的位置坐标
    @objc private func locateUserPosition() {
        self.mapView.mapView.centerCoordinate = CLLocationCoordinate2D(latitude: self.mapView.mapView.userLocation.coordinate.latitude, longitude: self.mapView.mapView.userLocation.coordinate.longitude)
    }
    // 下一个站点
    @objc private func nextLine() {
        guard let tag = self.selectedLineAry[self.selectedIndex] as? Int else {
            return
        }
        self.selectedIndex = self.selectedIndex % self.selectedLineAry.count
        self.bottomView.busBtnControllerWithBtnTag(tag)
        self.busGuideBarView.lineBtn.alpha = 1
        self.busGuideBarView.lineLab.text = self.selectedName
        self.busGuideBarView.runTimeLab.alpha = 0
        self.busGuideBarView.runTypeBtn.alpha = 0
        self.busGuideBarView.sendTypeBtn.alpha = 0
        self.busGuideBarView.lineLab.text = String(format: "%@号线", tag)
        self.busGuideBarView.lineBtn.lineLab.textColor = UIColor.white
        self.busGuideBarView.lineBtn.setTitle("", for: .normal)
        let myIndex = self.selectedStationAry[self.selectedIndex] as! Int
        self.stationScrollView.stationsViewAry[myIndex].frontImgView.alpha = 1
        var hexStr: String = ""
        switch tag {
            case 1:
                hexStr = "FF45B9"
                break
            case 2:
                hexStr = "#FF8015"
                break
            case 3:
                hexStr = "#06A3FC"
                break
            case 4:
                hexStr = "#18D19A"
                break
            default:
                break
        }
        self.stationScrollView.stationsViewAry[myIndex].stationLab.textColor = UIColor(hexString: hexStr, alpha: 1)
        self.selectedIndex += 1
    }

    private func showSelectedLineWithSelectedLineAry(_ array: [Any]) {
        self.bottomView.busBtnControllerWithBtnTag(array[0] as! Int)
        self.selectedIndex = 1
        let myIndex = self.selectedStationAry[0] as? Int ?? 0
        self.stationScrollView.stationsViewAry[myIndex].frontImgView.alpha = 1
        var hexStr: String = ""
        switch array[0] as? Int ?? 0 {
            case 1:
                hexStr = "FF45B9"
                break
            case 2:
                hexStr = "#FF8015"
                break
            case 3:
                hexStr = "#06A3FC"
                break
            case 4:
                hexStr = "#18D19A"
                break
            default:
                break
        }
        self.stationScrollView.stationsViewAry[myIndex].stationLab.textColor = UIColor(hexString: hexStr, alpha: 1)
        self.busGuideBarView.lineLab.text = self.selectedName
        self.busGuideBarView.runTimeLab.alpha = 0
        self.busGuideBarView.runTypeBtn.alpha = 0
        self.busGuideBarView.sendTypeBtn.alpha = 0
        self.busGuideBarView.lineBtn.lineLab.text = String(format: "%d号线", array[0] as? Int ?? 0)
        self.busGuideBarView.lineBtn.setTitle("", for: .normal)
        self.busGuideBarView.lineBtn.alpha = 1
        // 有多条线路经过此站
        if self.selectedLineAry.count > 1 {
            self.busGuideBarView.lineBtn.isUserInteractionEnabled = true
            self.busGuideBarView.lineBtn.imgView.image = UIImage(named: "WhiteChangeArrow")
            self.busGuideBarView.lineBtn.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#2921D1", alpha: 1), dark: UIColor(hexString: "#2921D1", alpha: 1))
            self.busGuideBarView.lineBtn.lineLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#FFFFFF", alpha: 1), dark: UIColor(hexString: "#F0F0F0", alpha: 1))
            self.busGuideBarView.lineBtn.addTarget(self, action: #selector(nextLine), for: .touchUpInside)
        } else {
            self.busGuideBarView.lineBtn.isUserInteractionEnabled = false
            self.busGuideBarView.lineBtn.imgView.image = UIImage(named: "BlackChangeArrow")
            self.busGuideBarView.lineBtn.backgroundColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#E8F0FC", alpha: 1), dark: UIColor(hexString: "#C3D4EE", alpha: 0.1))
            self.busGuideBarView.lineBtn.lineLab.textColor = UIColor(DMNamespace.dm, light: UIColor(hexString: "#112C54", alpha: 1), dark: UIColor(hexString: "#F0F0F0", alpha: 1))
        }
    }

    // MARK: - Lazy

    // 地图view
    private lazy var mapView: SchoolBusMapView = {
        let mapView = SchoolBusMapView(frame: self.view.frame)
        mapView.delegate = self
        return mapView
    }()
    // 底部view
    private lazy var bottomView: SchoolBusBottomView = {
        let bottomView = SchoolBusBottomView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - 96, width: SCREEN_WIDTH, height: 336))
        bottomView.delegate = self
        return bottomView
    }()
    // 地图侧边控制栏
    private lazy var mapSideBarView: SchoolBusMapSideBarView = {
        let mapSideBarView = SchoolBusMapSideBarView(frame: CGRect(x: 0, y: 0, width: 70, height: 280))
        mapSideBarView.bottom = self.bottomView.top - 18
        mapSideBarView.right = self.mapView.superRight - 16
        mapSideBarView.zoomInBtn.addTarget(self, action: #selector(zoomInView), for: .touchUpInside)
        mapSideBarView.zoomOutBtn.addTarget(self, action: #selector(zoomOutView), for: .touchUpInside)
        mapSideBarView.orientateBtn.addTarget(self, action: #selector(locateUserPosition), for: .touchUpInside)
        return mapSideBarView
    }()
    // 站点信息bar
    private lazy var busGuideBarView: BusGuideBarView = {
        let busGuideBarView = BusGuideBarView(frame: CGRect(x: 0, y: KSCREEN_HEIGHT, width: KSCREEN_WIDTH, height: 63))
        return busGuideBarView
    }()
    // 最下面站点scrollView
    private lazy var stationScrollView: StationScrollView = {
        let stationScrollView = StationScrollView(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: 163))
        stationScrollView.top = self.busGuideBarView.bottom
        return stationScrollView
    }()
}
