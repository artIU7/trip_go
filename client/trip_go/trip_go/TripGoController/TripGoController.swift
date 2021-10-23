//
//  TripGoControllerViewController.swift
//  trip_go
//
//  Created by Артем Стратиенко on 23.10.2021.
//

import UIKit
import NMAKit
import SnapKit

var clusterTemp = NMAClusterLayer()
var mapCircle : NMAMapCircle?


class TripGoController: UIViewController {
    
    //property's
    let mapView = NMAMapView()

    // grab
    var grabCoordinate = NMAGeoCoordinates()
    // route array
    var route_points = [NMAGeoCoordinates]()
    // searchingAdressLabel
    let serachingAdress = UILabel()
    // routing config
    let routingConfigView = UIView()
    // layer button
    let layerButton = UIButton(type: .system)
    // plus zoom
    let plusButton = UIButton(type: .system)
    // minus zoom
    let minusButton = UIButton(type: .system)
    // location zoom
    let locationButton = UIButton(type: .system)
    // fromPoint
    let fromPointButton = UIButton(type: .system)
    // toPoint
    let toPointButton = UIButton(type: .system)
    // additional poiny
    let addPointButton = UIButton(type: .system)
    // reset point
    let resetRouteButton = UIButton(type: .system)
    
    var coreRouter: NMACoreRouter!
    var mapRouts = [NMAMapRoute]()
    var progress: Progress? = nil
    
    // custom tint tab bar
    var tabBarTag: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Trip Go"
        
        self.loadUIMap()
        self.mapInit()
        self.initValues()
        self.addLayerConfig()
        
        // delegate
        self.mapView.gestureDelegate = self


        // Do any additional setup after loading the view.
    }
    
    func loadUIMap() {
        view.addSubview(mapView)
        self.mapView.snp.makeConstraints { (marker) in
            marker.top.equalTo(self.view).inset(0)
            marker.left.right.equalTo(self.view).inset(0)
            marker.bottom.equalTo(self.view).inset(0)
        }
    }
    func mapInit() {
        self.mapView.positionIndicator.isVisible = true
        self.mapView.positionIndicator.tracksCourse = true
        let accuracyColor = #colorLiteral(red: 0.4004088239, green: 0.9419217957, blue: 0.8626950897, alpha: 0.4428563784)
        self.mapView.positionIndicator.isAccuracyIndicatorVisible = true
        self.mapView.positionIndicator.accuracyIndicatorColor = accuracyColor
        mapView.mapScheme = NMAMapSchemeNormalNightTransit
        //
        mapView.transitDisplayMode = .everything//NMAMapTransitDisplayModeEverything;
        let fakePosition = CLLocationCoordinate2D(latitude: 55.790534, longitude: 38.438964)
        //
        self.mapView.set(geoCenter: NMAGeoCoordinates(latitude: fakePosition.latitude, longitude: fakePosition.longitude), zoomLevel: 25, orientation: 0, tilt: 15, animation: .linear)
    }
    func initValues() {
        coreRouter = NMACoreRouter()
        mapView.set(
            geoCenter: NMAGeoCoordinates(latitude: 52.406425, longitude:13.193975),
            zoomLevel: 10, animation: NMAMapAnimation.none
        )
        route_points.append(NMAGeoCoordinates(latitude: 52.406425, longitude:13.193975))
    }
    
    func addLayerConfig() {
        let colorButton = #colorLiteral(red: 0.5709930015, green: 0.6242560656, blue: 0.7402895111, alpha: 0.7)
        // layer
        layerButton.setImage(UIImage(named: "layer_nf_x"), for: .normal)
        layerButton.tintColor = .white
        layerButton.backgroundColor = colorButton
        layerButton.layer.cornerRadius = 20
        view.addSubview(layerButton)
        layerButton.addTarget(self, action: #selector(self.layerAction(_:)), for: .touchUpInside)
        layerButton.snp.makeConstraints { (marker) in
            marker.height.equalTo(42.5)
            marker.width.equalTo(42.5)
            marker.top.equalToSuperview().inset(40)
            marker.rightMargin.equalToSuperview().inset(5)
        }
        // plus
        plusButton.setImage(UIImage(named: "plus_nf_x"), for: .normal)
        plusButton.tintColor = .white
        plusButton.backgroundColor = colorButton
        plusButton.layer.cornerRadius = 20
        view.addSubview(plusButton)
        plusButton.addTarget(self, action: #selector(self.plusAction(_:)), for: .touchUpInside)
        plusButton.snp.makeConstraints { (marker) in
            marker.height.equalTo(42.5)
            marker.width.equalTo(42.5)
            //marker.top.equalTo(layerButton).inset(200)//equalToSuperview().inset(40)
            marker.topMargin.equalTo(layerButton).inset(200)
            marker.rightMargin.equalToSuperview().inset(5)
        }
        // minus
        minusButton.setImage(UIImage(named: "minus_nf_x"), for: .normal)
        minusButton.tintColor = .white
        minusButton.backgroundColor = colorButton
        minusButton.layer.cornerRadius = 20
        view.addSubview(minusButton)
        minusButton.addTarget(self, action: #selector(self.minusAction(_:)), for: .touchUpInside)
        minusButton.snp.makeConstraints { (marker) in
            marker.height.equalTo(42.5)
            marker.width.equalTo(42.5)
            //marker.top.equalTo(plusButton).inset(100)//equalToSuperview().inset(40)
            marker.topMargin.equalTo(plusButton).inset(100)
            marker.rightMargin.equalToSuperview().inset(5)
        }
        // location
        locationButton.setImage(UIImage(named: "location_nf_x"), for: .normal)
        locationButton.tintColor = .white
        locationButton.backgroundColor = colorButton
        locationButton.layer.cornerRadius = 20
        view.addSubview(locationButton)
        locationButton.addTarget(self, action: #selector(self.locationAction(_:)), for: .touchUpInside)
        locationButton.snp.makeConstraints { (marker) in
            marker.height.equalTo(42.5)
            marker.width.equalTo(42.5)
            //marker.top.equalTo(minusButton).inset(100)//equalToSuperview().inset(40)
            marker.topMargin.equalTo(minusButton).inset(200)
            marker.rightMargin.equalToSuperview().inset(5)
        }
        // routing config
        view.addSubview(routingConfigView)
        routingConfigView.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.2039215686, blue: 0.2745098039, alpha: 1)//#colorLiteral(red: 0.1676526818, green: 0.1903925995, blue: 0.2580723713, alpha: 1)
        routingConfigView.layer.cornerRadius = 15
        routingConfigView.snp.makeConstraints { (marker) in
            marker.bottom.equalToSuperview().inset(-10)
            marker.width.equalTo(self.view.frame.width)
            marker.height.equalTo(self.view.frame.height/4)
            marker.right.left.equalToSuperview().inset(0)
        }
        routingConfigView.isHidden = true
        
        // serachingAdress
        serachingAdress.font = UIFont.systemFont(ofSize: 16)
        serachingAdress.numberOfLines = 0
        serachingAdress.textColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        serachingAdress.layer.borderWidth = 0.5
        serachingAdress.layer.cornerRadius = 10
        serachingAdress.layer.borderColor = #colorLiteral(red: 0.4929717093, green: 0.4929717093, blue: 0.4929717093, alpha: 1)
        serachingAdress.textAlignment  = .center
        routingConfigView.addSubview(serachingAdress)
       
        serachingAdress.snp.makeConstraints { (marker) in
            marker.bottomMargin.equalToSuperview().inset(5)
            marker.top.equalToSuperview().inset(10)
            marker.height.equalTo(30)
            marker.width.equalTo(routingConfigView.frame.width - 10)
            marker.left.right.equalToSuperview().inset(10)
            marker.centerX.equalToSuperview()
        }
        
        // from point
        fromPointButton.setTitle("From", for: .normal)
        fromPointButton.setTitleColor(.white, for: .normal)
        fromPointButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        fromPointButton.tintColor = .white
        fromPointButton.backgroundColor = #colorLiteral(red: 0.2130090282, green: 0.2321631757, blue: 0.2820363943, alpha: 1)//#colorLiteral(red: 0.1676526818, green: 0.1903925995, blue: 0.2580723713, alpha: 1)
        fromPointButton.layer.cornerRadius = 10
        fromPointButton.layer.shadowRadius = 1.5
        fromPointButton.layer.shadowColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        fromPointButton.addTarget(self, action: #selector(self.fromPointAction(_:)), for: .touchUpInside)
        routingConfigView.addSubview(fromPointButton)
       
        fromPointButton.snp.makeConstraints { (marker) in
            marker.bottomMargin.equalToSuperview().inset(5)
            marker.top.equalTo(serachingAdress).inset(45)
            marker.height.equalTo(35)
            marker.width.equalTo(75)
            marker.left.equalToSuperview().inset(20)
        }
        fromPointButton.isHidden = false
        // to point
        toPointButton.setTitle("To", for: .normal)
        toPointButton.setTitleColor(.white, for: .normal)
        toPointButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        toPointButton.tintColor = .white
        toPointButton.backgroundColor = #colorLiteral(red: 0.2130090282, green: 0.2321631757, blue: 0.2820363943, alpha: 1)//#colorLiteral(red: 0.1676526818, green: 0.1903925995, blue: 0.2580723713, alpha: 1)
        toPointButton.layer.cornerRadius = 10
        toPointButton.layer.shadowRadius = 1.5
        toPointButton.layer.shadowColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        routingConfigView.addSubview(toPointButton)
        toPointButton.addTarget(self, action: #selector(self.toPointAction(_:)), for: .touchUpInside)
        toPointButton.snp.makeConstraints { (marker) in
            marker.bottomMargin.equalToSuperview().inset(5)
            marker.top.equalTo(serachingAdress).inset(45)
            marker.height.equalTo(35)
            marker.width.equalTo(75)
            marker.left.equalTo(fromPointButton).inset(100)
        }
        // additionak point
        addPointButton.setTitle("Transit", for: .normal)
        addPointButton.setTitleColor(.white, for: .normal)
        addPointButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        addPointButton.tintColor = .white
        addPointButton.backgroundColor = #colorLiteral(red: 0.7173891844, green: 0.8862745166, blue: 0.5983562226, alpha: 0.8498047077)//#colorLiteral(red: 0.1676526818, green: 0.1903925995, blue: 0.2580723713, alpha: 1)
        addPointButton.layer.cornerRadius = 10
        addPointButton.layer.shadowRadius = 1.5
        addPointButton.layer.shadowColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        routingConfigView.addSubview(addPointButton)
        addPointButton.addTarget(self, action: #selector(self.additionalPoint(_:)), for: .touchUpInside)

        addPointButton.snp.makeConstraints { (marker) in
            marker.bottomMargin.equalToSuperview().inset(5)
            marker.top.equalTo(serachingAdress).inset(45)
            marker.height.equalTo(35)
            marker.width.equalTo(75)
            marker.left.equalTo(toPointButton).inset(100)
        }
        // reset route
        resetRouteButton.setTitle("Маршрут", for: .normal)
        resetRouteButton.setTitleColor(.white, for: .normal)
        resetRouteButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        resetRouteButton.tintColor = .white
        resetRouteButton.backgroundColor = #colorLiteral(red: 0.8862745166, green: 0.3911112265, blue: 0.4140587326, alpha: 0.8498047077)//#colorLiteral(red: 0.1676526818, green: 0.1903925995, blue: 0.2580723713, alpha: 1)
        resetRouteButton.layer.cornerRadius = 10
        resetRouteButton.layer.shadowRadius = 1.5
        resetRouteButton.layer.shadowColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        routingConfigView.addSubview(resetRouteButton)
        resetRouteButton.addTarget(self, action: #selector(self.resetRouteAction(_:)), for: .touchUpInside)

        resetRouteButton.snp.makeConstraints { (marker) in
            marker.bottomMargin.equalToSuperview().inset(5)
            marker.top.equalTo(serachingAdress).inset(45)
            marker.height.equalTo(35)
            marker.width.equalTo(40)
            marker.left.equalTo(addPointButton).inset(100)
        }
        resetRouteButton.isHidden = false
    }
    // layer action
    @objc func layerAction(_ sender:UIButton) {
        //let layerController = LayerViewController()
        //layerController.modalPresentationStyle = .formSheet
            //layerController.modalTransitionStyle = .crossDissolve
        //show(layerController, sender: self)
        //present(layerController, animated: true, completion: nil)
    }
    // plus action
    @objc func plusAction(_ sender:UIButton) {
        
    }
    // minus action
    @objc func minusAction(_ sender:UIButton) {
        
    }
    // location action
    @objc func locationAction(_ sender:UIButton) {
        
    }
    // fromButton action
    @objc func fromPointAction(_ sender:UIButton) {
        if (route_points.isEmpty == true) {
            route_points.append(grabCoordinate)
            fromPointButton.backgroundColor = #colorLiteral(red: 0.2207934925, green: 0.4795336441, blue: 1, alpha: 1)
            grabCoordinate = NMAGeoCoordinates()
        } else {
            //
        }
    }
    // toButton action
    @objc func toPointAction(_ sender:UIButton) {
            route_points.append(grabCoordinate)
            toPointButton.backgroundColor = #colorLiteral(red: 0.2207934925, green: 0.4795336441, blue: 1, alpha: 1)
            grabCoordinate = NMAGeoCoordinates()
            print(route_points)
        resetRouteButton.isHidden = false
    }
    // addItionaal action
    @objc func additionalPoint(_ sender:UIButton) {
            route_points.append(grabCoordinate)
            addPointButton.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            grabCoordinate = NMAGeoCoordinates()
            //addRoute()
    }
    @objc func resetRouteAction(_ sender : UIButton) {
        //route_points.removeAll()
        fromPointButton.backgroundColor = #colorLiteral(red: 0.2130090282, green: 0.2321631757, blue: 0.2820363943, alpha: 1)
        toPointButton.backgroundColor = #colorLiteral(red: 0.2130090282, green: 0.2321631757, blue: 0.2820363943, alpha: 1)
        addPointButton.backgroundColor =  #colorLiteral(red: 0.7173891844, green: 0.8862745166, blue: 0.5983562226, alpha: 0.8498047077)
        
        addRoute()

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
          
           if tabBarTag == true {
               self.tabBarController?.tabBar.tintColor = UIColor.yellow
                self.tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 0.1156016763, green: 0.1961770704, blue: 0.3223885175, alpha: 1)//UIColor.cyan

           } else {
               self.tabBarController?.tabBar.tintColor = UIColor.white
           }
    }
}

extension TripGoController : NMAMapGestureDelegate,NMAMapViewDelegate,NMATransitManagerDelegate {
    
}
extension TripGoController : CLLocationManagerDelegate {
    
}
