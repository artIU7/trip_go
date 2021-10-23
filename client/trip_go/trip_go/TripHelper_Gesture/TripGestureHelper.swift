//
//  TripGestureHelper.swift
//  trip_go
//
//  Created by Артем Стратиенко on 23.10.2021.
//

import Foundation
import UIKit
import NMAKit

extension TripGoController  {
    // add touch in map and draw rote to point
    func mapView(_ mapView: NMAMapView, didReceiveLongPressAt location: CGPoint) {
        let plks = String(describing: mapView.geoCoordinates(from: location))//mapView.geoCoordinates(from: location))
        print(plks)
        UIView.animate(withDuration: 1) { [self] in
            routingConfigView.alpha = 1
            routingConfigView.isHidden = false
            //self.mapView.remove(clusterLayer: clusterTemp)
            let checkPoint = mapView.geoCoordinates(from: location)!
            grabCoordinate = checkPoint
            
            self.addMarkerStopPoi(mapView.geoCoordinates(from: location)!, index: 3, markerUI: UIImage(named: "custom_poi")!)
            self.createCircle( geoCoord: checkPoint, color: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 0.63) , rad: 115 )

        }
    }
    // one tap
    func mapView(_ mapView: NMAMapView, didReceiveTapAt location: CGPoint) {
        let objStruct = mapView.objects(at: location)
        if (routingConfigView.isHidden) {
        } else {
            routingConfigView.isHidden = true
            locationButton.isHidden = false
        }

        let setCenter = mapView.geoCoordinates(from: location)
        self.mapView.set(geoCenter: setCenter!, zoomLevel: self.mapView.zoomLevel, animation: .linear)
    }
    // *LongPress* touch to detected point in poly
       
    func mapView(_ mapView: NMAMapView, didReceiveDoubleTapAt location: CGPoint) {
        var getCoordinate = mapView.geoCoordinates(from: location)
    }

}
