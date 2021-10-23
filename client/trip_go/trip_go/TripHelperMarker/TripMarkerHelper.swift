//
//  TripMarkerHelper.swift
//  trip_go
//
//  Created by Артем Стратиенко on 23.10.2021.
//
import NMAKit

extension TripGoController {
    
    open func distanceInRoute(_ routeIn : [NMAGeoCoordinates]?) -> Double {
            var allDistance = 0.0
            let segment = routeIn!.count
            for i in 0...segment - 2 {
                allDistance += distanceGeo(pointA: routeIn![i], pointB: routeIn![i + 1])
            }
            return allDistance
        }
    public func distanceGeo(pointA : NMAGeoCoordinates,pointB : NMAGeoCoordinates) -> Double {
        let toRad = Double.pi/180
        let radial = acos(sin(pointA.latitude*toRad)*sin(pointB.latitude*toRad) + cos(pointA.latitude*toRad)*cos(pointB.latitude*toRad)*cos((pointA.longitude - pointB.longitude)*toRad))
        let R = 6378.137//6371.11
        let D = (radial*R)*1000
        return D
    }
    func addMarkerStopPoi(_ positionAnchor : NMAGeoCoordinates, index : Int, markerUI : UIImage) {
        let marker = NMAMapMarker(geoCoordinates: positionAnchor, image: markerUI)
          marker.resetIconSize()
          marker.setSize(CGSize(width: 1, height: 1), forZoomRange: NSRange(location: 5,length: 20))
          clusterTemp.addMarker(marker)
          self.mapView.add(clusterLayer: clusterTemp)
          self.mapView.add(mapObject: marker)
      }
    public func createCircle(geoCoord : NMAGeoCoordinates, color : UIColor,rad : Int) {
            //create NMAMapCircle located at geo coordiate and with radium in meters
            mapCircle = NMAMapCircle(geoCoord, radius: Double(rad))
            //set fill color to be gray
            mapCircle?.fillColor = color
            //set border line width.
            mapCircle?.lineWidth = 12;
            //set border line color to be red.
            mapCircle?.lineColor = color
            //add Map Circel to map view
            
            _ = mapCircle.map{ mapView.add(mapObject: $0)
            
        }
    }
    func addRoute() {
        
        let routingMode = NMARoutingMode.init(
            routingType: NMARoutingType.fastest,
            transportMode: NMATransportMode.pedestrian,
            routingOptions: []
        )
        routingMode.resultLimit = 1

        // check if calculation completed otherwise cancel.
        if !(progress?.isFinished ?? false) {
            progress?.cancel()
        }

        // Use banned areas if needed
        //addBannedAreas(coreRouter);

        // store progress.
        progress = coreRouter.calculateRoute(withStops: route_points, routingMode: routingMode, { (routeResult, error) in
            if (error != NMARoutingError.none) {
                NSLog("Error in callback: \(error)")
                return
            }
            
            guard let route = routeResult?.routes?.first else {
                print("Empty Route result")
                return
            }
            
            guard let box = route.boundingBox, let mapRoute = NMAMapRoute.init(route) else {
                print("Can't init Map Route")
                return
            }
            
            if (self.mapRouts.count != 0) {
                for route in self.mapRouts {
                    self.mapView.remove(mapObject: route)
                }
                self.mapRouts.removeAll()
            }
            
            self.mapRouts.append(mapRoute)

            self.mapView.set(boundingBox: box, animation: NMAMapAnimation.linear)
            self.mapView.add(mapObject: mapRoute)
        })
    }
        func clearRoute() {
            for route in mapRouts {
                mapView.remove(mapObject: route)
            }
            
            mapView.zoomLevel = mapView.zoomLevel
        }
}
