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
var tempPosition : CLLocationCoordinate2D!
var search_point = NMAGeoCoordinates()

//
var temp_uid_city = String();

var model_uid = ModelRouteUID()

let ya_get_city = "https://api.rasp.yandex.net/v3.0/nearest_settlement/?apikey=0a5bc7a5-f976-4f84-be5c-1ed18dc66e87"
let lat         = "lat=";
let lng         = "lng=";
let distance    = "distance="

class TripGoController: UIViewController,UITextFieldDelegate {
    
    // lm
    let locationManager = CLLocationManager()

    //property's
    let mapView = NMAMapView()
    let bottomSheetVC = ViewDetailRouteController()
    // grab
    var grabCoordinate = NMAGeoCoordinates()
    // route array
    var route_points = [NMAGeoCoordinates]()
    // searchingAdressLabel
    let serachingAdress = UILabel()
    // close subView
    let closeView = UIButton(type: .system)
    // routing config
    let routingConfigView = UIView()
    // detailRoute
    let detail_view = UIView()
    // search view
    let search_view   = UIView()
    let search_field  = UITextField()
    let search_action = UIButton(type: .system)
    let search_hide   = UIButton(type: .system)
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
    
    //
    var stackDetail = UIStackView()
    var scrollView  = UIScrollView()
    var viewDetail  = UIView()

    //
    
    var coreRouter: NMACoreRouter!
    var mapRouts = [NMAMapRoute]()
    var progress: Progress? = nil
    
    // geocoder block
    var address = ""
    let searchCenter = NMAGeoCoordinates(latitude: 55.757682, longitude: 37.661171) //55.757682, 37.661171
    let searchRadius = 3000
    var position: NMAGeoCoordinates?
    
    // custom tint tab bar
    var tabBarTag: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Trip Go"
    
        // delegate
        self.mapView.gestureDelegate = self
        self.search_field.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2) ) { [self] in
            initLocationManager()
            startLocation()
            loadUIMap()
            mapInit()
            addLayerConfig()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [self] in
                        initValues()
                }
        }
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
        mapView.mapScheme = NMAMapSchemeReducedNight
        //
        mapView.transitDisplayMode = .everything//NMAMapTransitDisplayModeEverything;
        let fakePosition = CLLocationCoordinate2D(latitude: 55.790534, longitude: 38.438964)
        //
        self.mapView.set(geoCenter: NMAGeoCoordinates(latitude: fakePosition.latitude, longitude: fakePosition.longitude), zoomLevel: 25, orientation: 0, tilt: 15, animation: .linear)
    }
    func initValues() {
        coreRouter = NMACoreRouter()
        mapView.set(
            geoCenter: NMAGeoCoordinates(latitude: tempPosition.latitude, longitude: tempPosition.longitude),
            zoomLevel: 10, animation: .linear
        )
        //        route_points.append(NMAGeoCoordinates()

    }
    
    func addLayerConfig() {
        
        // search config
        view.addSubview(search_view)
        search_view.backgroundColor =  #colorLiteral(red: 0.2237831238, green: 0.2655357666, blue: 0.3620206546, alpha: 0.85) //#colorLiteral(red: 0.1676526818, green: 0.1903925995, blue: 0.2580723713, alpha: 1)
        search_view.layer.cornerRadius = 15
        search_view.layer.shadowRadius = 10
        search_view.layer.shadowColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        search_view.layer.shadowOffset = CGSize(width: 0, height: 10)
        search_view.layer.borderColor  = #colorLiteral(red: 0.1176306968, green: 0.1395778051, blue: 0.1902946975, alpha: 0.85)
        search_view.layer.borderWidth  = 0.5

        search_view.snp.makeConstraints { (marker) in
            marker.height.equalTo(50)
            marker.width.equalTo(self.view.frame.width - 20)
            marker.top.equalToSuperview().inset(40)
            marker.rightMargin.equalToSuperview().inset(5)
            marker.leftMargin.equalToSuperview().inset(5)
            marker.centerX.equalToSuperview()

        }
        search_view.isHidden = false
        
        // search
        
        // layer
        search_action.setImage(UIImage(named: "search_icon"), for: .normal)
        search_action.tintColor = .white
        search_action.backgroundColor = .clear
        search_action.layer.cornerRadius = 5
        search_view.addSubview(search_action)
        search_action.addTarget(self, action: #selector(self.coderAction(_:)), for: .touchUpInside)
        search_action.snp.makeConstraints { (marker) in
            marker.height.equalTo(40)
            marker.width.equalTo(40)
            marker.topMargin.bottomMargin.equalToSuperview().inset(5)
            marker.leftMargin.equalToSuperview().inset(5)
        }
        
        // field
        
        // layer5=-fdcp0o
        search_field.tintColor = .white
        search_field.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.2039215686, blue: 0.2745098039, alpha: 1) //
        search_field.layer.cornerRadius = 10
        search_field.textAlignment = .left
        search_field.font = UIFont.boldSystemFont(ofSize: 16)
        search_field.placeholderRect(forBounds: CGRect(x: 30, y : 0, width: search_field.frame.width - 10, height: search_field.frame.width))
        search_field.placeholder = "Укажите направление"
        search_view.addSubview(search_field)
       
        search_field.snp.makeConstraints { (marker) in
            marker.height.equalTo(40)
            marker.width.equalTo(self.view.frame.width - 60 - 40 - 20   )
            marker.topMargin.bottomMargin.equalToSuperview().inset(5)
            marker.centerX.equalToSuperview()
        }
        
        
        search_hide.setImage(UIImage(named: "search_custom"), for: .normal)
        search_hide.tintColor = .white
        search_hide.backgroundColor = .clear
        search_hide.layer.cornerRadius = 5
        
        search_view.addSubview(search_hide)
        
        search_hide.addTarget(self, action: #selector(self.coderAction(_:)), for: .touchUpInside)
        search_hide.snp.makeConstraints { (marker) in
            marker.height.equalTo(40)
            marker.width.equalTo(40)
            marker.topMargin.bottomMargin.equalToSuperview().inset(5)
            marker.rightMargin.equalToSuperview().inset(5)
        }
        
        
        let colorButton = #colorLiteral(red: 0.3275199153, green: 0.365426504, blue: 0.5, alpha: 0.9)
        // layer
        layerButton.setImage(UIImage(named: "layer_nf_x"), for: .normal)
        layerButton.tintColor = .white
        layerButton.backgroundColor = colorButton
        layerButton.layer.cornerRadius = 5
        view.addSubview(layerButton)
        layerButton.addTarget(self, action: #selector(self.layerAction(_:)), for: .touchUpInside)
        layerButton.snp.makeConstraints { (marker) in
            marker.height.equalTo(40)
            marker.width.equalTo(40)
            marker.topMargin.equalTo(search_view).inset(60)
            marker.rightMargin.equalToSuperview().inset(5)
        }
        // plus
        plusButton.setImage(UIImage(named: "plus_nf_x"), for: .normal)
        plusButton.tintColor = .white
        plusButton.backgroundColor = colorButton
        plusButton.layer.cornerRadius = 5
        view.addSubview(plusButton)
        plusButton.addTarget(self, action: #selector(self.plusAction(_:)), for: .touchUpInside)
        plusButton.snp.makeConstraints { (marker) in
            marker.height.equalTo(40)
            marker.width.equalTo(40)
            //marker.top.equalTo(layerButton).inset(200)//equalToSuperview().inset(40)
            marker.topMargin.equalTo(layerButton).inset(100)
            marker.rightMargin.equalToSuperview().inset(5)
        }
        // minus
        minusButton.setImage(UIImage(named: "minus_nf_x"), for: .normal)
        minusButton.tintColor = .white
        minusButton.backgroundColor = colorButton
        minusButton.layer.cornerRadius = 5
        view.addSubview(minusButton)
        minusButton.addTarget(self, action: #selector(self.minusAction(_:)), for: .touchUpInside)
        minusButton.snp.makeConstraints { (marker) in
            marker.height.equalTo(40)
            marker.width.equalTo(40)
            //marker.top.equalTo(plusButton).inset(100)//equalToSuperview().inset(40)
            marker.topMargin.equalTo(plusButton).inset(50)
            marker.rightMargin.equalToSuperview().inset(5)
        }
        // location
        locationButton.setImage(UIImage(named: "location_nf_x"), for: .normal)
        locationButton.tintColor = .white
        locationButton.backgroundColor = colorButton
        locationButton.layer.cornerRadius = 5
        view.addSubview(locationButton)
        locationButton.addTarget(self, action: #selector(self.locationAction(_:)), for: .touchUpInside)
        locationButton.snp.makeConstraints { (marker) in
            marker.height.equalTo(40)
            marker.width.equalTo(40)
            //marker.top.equalTo(minusButton).inset(100)//equalToSuperview().inset(40)
            marker.topMargin.equalTo(minusButton).inset(100)
            marker.rightMargin.equalToSuperview().inset(5)
        }
        // routing config
        view.addSubview(routingConfigView)
        routingConfigView.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.2039215686, blue: 0.2745098039, alpha: 1)//#colorLiteral(red: 0.1676526818, green: 0.1903925995, blue: 0.2580723713, alpha: 1)
        routingConfigView.layer.cornerRadius = 15
        routingConfigView.snp.makeConstraints { (marker) in
            marker.bottom.equalToSuperview().inset(-10)
            marker.width.equalTo(self.view.frame.width)
            marker.height.equalTo(self.view.frame.height/3)
            marker.right.left.equalToSuperview().inset(0)
        }
        routingConfigView.isHidden = true
        
        // serachingAdress
        serachingAdress.font = UIFont.systemFont(ofSize: 16)
        serachingAdress.numberOfLines = 0
        serachingAdress.textColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        serachingAdress.layer.borderWidth = 1.5
        serachingAdress.layer.cornerRadius = 10
        serachingAdress.layer.borderColor = #colorLiteral(red: 0.4929717093, green: 0.4929717093, blue: 0.4929717093, alpha: 1)
        serachingAdress.textAlignment  = .center
        routingConfigView.addSubview(serachingAdress)
       
        serachingAdress.snp.makeConstraints { (marker) in
            //marker.bottomMargin.equalToSuperview().inset(5)
            marker.top.equalToSuperview().inset(10)
            marker.height.equalTo(30)
            //marker.width.equalTo( self.view.frame.width - 60)
            marker.trailingMargin.width.equalTo( self.view.frame.width - 60 )
            marker.left.equalToSuperview().inset(10)
        }
        // close view
        closeView.setImage(UIImage(named: "closeDetail"), for: .normal)
        closeView.tintColor = .white
        closeView.backgroundColor = #colorLiteral(red: 0.2130090282, green: 0.2321631757, blue: 0.2820363943, alpha: 1)//#colorLiteral(red: 0.1676526818, green: 0.1903925995, blue: 0.2580723713, alpha: 1)
        closeView.layer.cornerRadius = 10
        closeView.layer.shadowRadius = 1.5
        closeView.layer.shadowColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        closeView.addTarget(self, action: #selector(self.closeViewAction(_:)), for: .touchUpInside)
        
        routingConfigView.addSubview(closeView)
        closeView.snp.makeConstraints { (marker) in
            marker.top.equalToSuperview().inset(10)
            marker.height.equalTo(30)
            marker.width.equalTo(30)
            marker.right.equalToSuperview().inset(10)
            marker.leftMargin.equalTo(serachingAdress)
        }
        /*
        fromPointButton.isHidden = false
       
        
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
        
        //routingConfigView.addSubview(fromPointButton)
       
        fromPointButton.snp.makeConstraints { (marker) in
            //marker.bottomMargin.equalToSuperview().inset(5)
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
        
        //routingConfigView.addSubview(toPointButton)
        
        toPointButton.addTarget(self, action: #selector(self.toPointAction(_:)), for: .touchUpInside)
        
        toPointButton.snp.makeConstraints { (marker) in
            //marker.bottomMargin.equalToSuperview().inset(5)
            marker.top.equalTo(serachingAdress).inset(45)
            marker.height.equalTo(35)
            marker.width.equalTo(75)
            marker.left.equalTo(fromPointButton).inset(100)
        }
        toPointButton.isHidden = false
         */
        // additionak point
        addPointButton.setTitle("Добавить точку", for: .normal)
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
            //marker.bottomMargin.equalToSuperview().inset(5)
            marker.top.equalTo(serachingAdress).inset(45)
            marker.height.equalTo(35)
            marker.width.equalTo(75)
            marker.left.equalToSuperview().inset(20)
        }
        addPointButton.isHidden = false
        
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
            //marker.bottomMargin.equalToSuperview().inset(-8)
            marker.top.equalTo(serachingAdress).inset(45)
            marker.height.equalTo(35)
            marker.width.equalTo(100)
            marker.left.equalTo(addPointButton).inset(100)
        }
        resetRouteButton.isHidden = false
        
        routingConfigView.addSubview(viewDetail)
        viewDetail.backgroundColor = .clear//#colorLiteral(red: 0.1676526818, green: 0.1903925995, blue: 0.2580723713, alpha: 1)
        viewDetail.layer.cornerRadius = 0
        viewDetail.snp.makeConstraints { (marker) in
            marker.top.equalTo(resetRouteButton).inset(45)
            marker.bottom.equalToSuperview().inset(-10)

            //marker.width.equalTo(self.view.frame.width)
            //marker.height.equalTo(self.view.frame.height/4)
            marker.right.left.equalToSuperview().inset(0)
        }
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        viewDetail.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (marker) in
            marker.edges.equalToSuperview()
        }
        
        stackDetail.translatesAutoresizingMaskIntoConstraints = false
        stackDetail.axis = .horizontal
        stackDetail.alignment = .bottom
        stackDetail.spacing = 20
        scrollView.addSubview(stackDetail)
               
        stackDetail.snp.makeConstraints { (marker) in
            marker.edges.equalToSuperview()
        }
        
        for i in 1 ..< 40 {
            let vw = UIButton(type: .system)
            vw.setTitle("Маршрут", for: .normal)
            vw.setTitleColor(.white, for: .normal)
            vw.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            vw.tintColor = .white
            vw.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)//#colorLiteral(red: 0.1676526818, green: 0.1903925995, blue: 0.2580723713, alpha: 1)
            vw.layer.cornerRadius = 10
            vw.layer.shadowRadius = 1.5
            vw.layer.shadowColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            
            stackDetail.addArrangedSubview(vw)
            
            vw.snp.makeConstraints { (marker) in
                marker.height.equalTo(40)
                marker.width.equalTo(100)
            }
        }
        /// ***
        /// add stack view
        // routing config
        /*routingConfigView.addSubview(routeChoice)
        
        
        
        routeChoice.distribution = .equalSpacing
        routeChoice.alignment = .fill
        routeChoice.axis = .vertical
        routeChoice.spacing = 10
        routeChoice.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)//#colorLiteral(red: 0.1676526818, green: 0.1903925995, blue: 0.2580723713, alpha: 1)
        routeChoice.layer.cornerRadius = 15
        routeChoice.snp.makeConstraints { (marker) in
            marker.top.equalTo(resetRouteButton).inset(10)
            marker.width.equalTo(routingConfigView.frame.width)
            marker.height.equalTo(routingConfigView.frame.height/4)
            marker.right.left.equalToSuperview().inset(0)
            marker.bottomMargin.equalToSuperview().inset(10)
        }
        // add cell to stackview
        routeChoice.addArrangedSubview(detail_view)
        detail_view.layer.cornerRadius = 20
        detail_view.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        
        
        /// *** end stack view
        */
    }
    // layer action
    @objc func layerAction(_ sender:UIButton) {

        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.setViewHide(hidden: false)

        //layerController.modalPresentationStyle = .formSheet
            //layerController.modalTransitionStyle = .crossDissolve
        //show(layerController, sender: self)
        //present(layerController, animated: true, completion: nil)
    }
    // closeview action
    @objc func closeViewAction(_ sender:UIButton) {
        setTabBar(hidden: false)
        routingConfigView.isHidden = true
        clearRoute()
        route_points.removeAll()
        mapView.remove(clusterLayer: clusterTemp)
    }
    // plus action
    @objc func plusAction(_ sender:UIButton) {
        
        self.mapView.set(zoomLevel: self.mapView.zoomLevel + 2, animation: .linear)
        
    }
    // minus action
    @objc func minusAction(_ sender:UIButton) {
        
        self.mapView.set(zoomLevel: self.mapView.zoomLevel - 2, animation: .linear)

        
    }
    // location action
    @objc func locationAction(_ sender:UIButton) {
        
        //self.mapView.set(geoCenter: , zoomLevel: 15, animation: .linear)
        
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
            
        route_points.insert(grabCoordinate, at: route_points.count - 1)
            addPointButton.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            grabCoordinate = NMAGeoCoordinates()
            //setTabBar(hidden: true)
            addRoute()
    }
    @objc func resetRouteAction(_ sender : UIButton) {
        //route_points.removeAll()
        fromPointButton.backgroundColor     = #colorLiteral(red: 0.2130090282, green: 0.2321631757, blue: 0.2820363943, alpha: 1)
        toPointButton.backgroundColor       = #colorLiteral(red: 0.2130090282, green: 0.2321631757, blue: 0.2820363943, alpha: 1)
        addPointButton.backgroundColor     =  #colorLiteral(red: 0.7173891844, green: 0.8862745166, blue: 0.5983562226, alpha: 0.8498047077)
        
        addRoute()
        //setTabBar(hidden: false)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        addressGeocoder()
        routingConfigView.isHidden = false
        route_points.removeAll()
        //
        route_points.append(NMAGeoCoordinates(latitude: tempPosition.latitude, longitude: tempPosition.longitude))
        model_uid.first_uid = temp_uid_city
     
        let city_url = ya_get_city+"&"+lat+"\(tempPosition.latitude)"+"&"+lng+"\(tempPosition.longitude)"+"&"+distance+"\(5)"

        
        fetch_ya_api(urlString: city_url)
        
        model_uid.first_uid = temp_uid_city
        
        return false
    }
    func startGeoCoding() {
        NMAGeocoder.sharedInstance().createGeocodeRequest(query: address, searchRadius: searchRadius, searchCenter: searchCenter).start(
                    parseResultFromGeocodeRequest(request:requestData:error:)
                )
    }
    @objc func coderAction(_ sender : UIButton)  {
         addressGeocoder()
    }
    func addressGeocoder()
    {
        if search_field.text != "" {
            address = search_field.text!
        }
        startGeoCoding()
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
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            //addBottomSheetView()
        }


        func addBottomSheetView() {
                        
            self.addChild(bottomSheetVC)
            self.view.addSubview(bottomSheetVC.view)
            bottomSheetVC.didMove(toParent: self)

            let height = view.frame.height
            let width  = view.frame.width
            bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
            
        }
    
    func setTabBar(hidden:Bool) {
        guard let frame = self.tabBarController?.tabBar.frame else {return }
        if hidden {
            //UIView.animate(withDuration: 0.3, animations: {
                self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: frame.height)
            //})
        }else {

            //UIView.animate(withDuration: 0.3, animations: {
                self.tabBarController?.tabBar.frame = UITabBarController().tabBar.frame
            //})
        }
    }
    
}

extension TripGoController : NMAMapGestureDelegate,NMAMapViewDelegate,NMATransitManagerDelegate {
    
}
extension TripGoController : CLLocationManagerDelegate {
    
}
