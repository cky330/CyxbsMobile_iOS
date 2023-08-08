//
//  SchoolBusMapView.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/7/21.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

@objc protocol SchoolBusMapViewDelegate: AnyObject {
    func clickBackBtn()
    func schoolBusMapView(_ view: SchoolBusMapView, didSelectedAnnotation annotationView: MAAnnotationView)
}

/// 地图
class SchoolBusMapView: UIView, MAMapViewDelegate, AMapLocationManagerDelegate {
    
    /// 返回按钮的代理
    weak var delegate: SchoolBusMapViewDelegate?
    /// 站点位置数组
    var stationPointAry: [Any] = []
    
    var timer = Timer()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        MAMapView.updatePrivacyShow(.didShow, privacyInfo: .didContain)
        MAMapView.updatePrivacyAgree(.didAgree)
        setLocationRepresentation()
        refreshBusData()
        self.addSubview(mapView)
        self.addSubview(backBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        let pointReuseIndentifier = "pointReuseIndentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndentifier) as? MAPinAnnotationView
        if annotationView == nil {
            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndentifier)
        }
        // 通过返回nil，来告诉框架不需要为用户位置创建标注视图，从而保持默认的用户位置显示效果
        if annotation is MAUserLocation {
            return nil
        } else {
            annotationView?.canShowCallout = true
            annotationView?.animatesDrop = false
            annotationView?.isDraggable = false
            if annotation is StationMAPointAnnotation {
                annotationView?.image = UIImage(named: "station.purple")
                return annotationView
            } else if annotation is CircleMAPointAnnotation {
                switch annotation.subtitle {
                case "1号线":
                    annotationView?.image = UIImage(named: "circle.pink")
                case "2号线":
                    annotationView?.image = UIImage(named: "circle.orange")
                case "3号线":
                    annotationView?.image = UIImage(named: "circle.blue")
                case "4号线":
                    annotationView?.image = UIImage(named: "circle.green")
                default:
                    break
                }
                return annotationView
            } else if annotation is MAPointAnnotation {
                switch annotation.subtitle {
                case "1号线":
                    annotationView?.image = UIImage(named: "station.pink")
                case "2号线":
                    annotationView?.image = UIImage(named: "station.orange")
                case "3号线":
                    annotationView?.image = UIImage(named: "station.blue")
                case "4号线":
                    annotationView?.image = UIImage(named: "station.green")
                case "Line:1":
                    annotationView?.image = UIImage(named: "schoolbus.pink")
                case "Line:2":
                    annotationView?.image = UIImage(named: "schoolbus.orange")
                case "Line:3":
                    annotationView?.image = UIImage(named: "schoolbus.blue")
                case "Line:4":
                    annotationView?.image = UIImage(named: "schoolbus.green")
                default:
                    break
                }
                return annotationView
            }
        }
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        if let delegate = self.delegate {
            delegate.schoolBusMapView(self, didSelectedAnnotation: view)
        }
    }
    
    // MARK: - Method
    
    // 更新地图上的站点标记点
    func updateStationAnnotation(stationAry: [Any]) {
        self.mapView.removeAnnotations(self.stationPointAry)
        self.stationPointAry = stationAry
        self.mapView.addAnnotations(self.stationPointAry)
    }
    
    private func refreshBusData() {
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: YYWeakProxy(target: self), selector: #selector(setUpBusData), userInfo: nil, repeats: true)
    }
    
    // 将校车原始数据转换为地图上的标记点
    @objc private func setUpBusData() {
        BusData.requestWith { array in
            var mutableAry: [Any] = []
            for i in 0..<array.count {
                let busAnnotation = MAPointAnnotation()
                let data = array[i] as! BusData
                busAnnotation.coordinate = CLLocationCoordinate2DMake(data.latitude, data.longitude)
                busAnnotation.title = String(format: "BusID : %d", data.busID)
                busAnnotation.subtitle = String(format: "Line:%d", data.busLine + 1)
                mutableAry.append(busAnnotation)
            }
            self.busPointAry = mutableAry
        } failure: {
            
        }
    }
    
    // 设置用户位置显示样式
    private func setLocationRepresentation() {
        let representation = MAUserLocationRepresentation()
        representation.showsAccuracyRing = true
        representation.image = UIImage(named: "MyPosition")
        self.mapView.update(representation)
    }
    
    // MARK: - Lazy
    
    /// 地图视图
    lazy var mapView: MAMapView = {
        AMapServices.shared().apiKey = "0de229ab86861128f7fec123538aa109"
        AMapServices.shared().enableHTTPS = true
        let mapView = MAMapView(frame: self.bounds)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.zoomLevel = 17.4
        mapView.centerCoordinate = CLLocationCoordinate2DMake(29.529332, 106.607517)
        mapView.scaleOrigin = CGPoint(x: 50, y: STATUSBARHEIGHT + 10)
        mapView.showsCompass = false
        mapView.delegate = self
        // 如果已经启用了位置服务
        if CLLocationManager.locationServicesEnabled() {
            let locationManager = AMapLocationManager()
            locationManager.delegate = self
            // 是否允许后台定位。默认为NO。只在iOS 9.0及之后起作用。设置为YES的时候必须保证Background Modes中的Location updates处于选中状态，否则会抛出异常。由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果
            locationManager.allowsBackgroundLocationUpdates = false
            // 指定定位是否会被系统自动暂停。默认为NO
            locationManager.pausesLocationUpdatesAutomatically = false
            // 设定定位的最小更新距离。单位米，默认为kCLDistanceFilterNone，表示只要检测到设备位置发生变化就会更新位置信息
            locationManager.distanceFilter = 1
            // 设定期望的定位精度。单位米，默认为kCLLocationAccuracyBest
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            // 开始定位服务
            locationManager.stopUpdatingLocation()
        }
        return mapView
    }()
    
    /// 返回按钮
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .system)
        backBtn.frame = CGRect(x: 17, y: STATUSBARHEIGHT + 13, width: 19, height: 19)
        backBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        backBtn.setImage(UIImage(named: "我的返回"), for: .normal)
        backBtn.tintColor = UIColor.gray
        backBtn.addTarget(self.delegate, action: #selector(self.delegate?.clickBackBtn), for: .touchUpInside)
        return backBtn
    }()
    
    // MARK: - Setter
    
    /// 校车位置数组
    var busPointAry: [Any] = [] {
        //更新地图上的校车标记点
        didSet {
            if !self.busPointAry.isEmpty {
                //移除
                self.mapView.removeAnnotations(oldValue)
            }
            //添加
            self.mapView.addAnnotations(self.busPointAry)
        }
    }
}
