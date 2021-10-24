//
//  TripGeocoder+Helper.swift
//  trip_go
//
//  Created by Артем Стратиенко on 24.10.2021.
//

import Foundation
import NMAKit

extension TripGoController {
    
    func parseResultFromReverseGeocodeRequest(request: NMARequest?, requestData data: Any?, error: Error?) {

            if error != nil {
                print("error \(error!.localizedDescription)")
                return
            }
            
            if (!(request is NMAReverseGeocodeRequest)) {
                print("invalid type returned")
                return
            }
            
            guard let arr = data as? NSArray, arr.count != 0 else {
                return
            }
            
            if let address = (arr.object(at: 0) as? NMAReverseGeocodeResult)?.location?.address?.formattedAddress {
                //locationLabel.text = address
            }
        }
        
        func parseResultFromGeocodeRequest(request: NMARequest?, requestData data: Any?, error: Error?) {
            
            if error != nil {
                print("error \(error!.localizedDescription)")
                return
            }
            
            if (!(request is NMAGeocodeRequest)) {
                print("invalid type returned")
                return
            }
            
            guard let arr = data as? NSArray, arr.count != 0 else {
                return
            }
            
            let tempPosition = (arr.object(at: 0) as? NMAGeocodeResult)?.location?.position
            search_point = tempPosition!
            self.mapView.set(geoCenter: search_point, zoomLevel: 10, animation: .linear)
            self.addMarkerStopPoi(search_point, index: 3, markerUI: UIImage(named: "custom_poi")!)
            route_points.append(search_point)
            
            let city_url = ya_get_city+"&"+lat+"\(search_point.latitude)"+"&"+lng+"\(search_point.longitude)"+"&"+distance+"\(5)"

            /*
            let planer_url =
                ya_get_planner+"&"+transport_types+"plane"+"&"+from+"\(model_uid.first_uid)"+"&"+to+"\(model_uid.finish_uid)"+"&"+limit+"\(1)"+data+"24.02"
            */
            fetch_ya_api(urlString: city_url)
            
            //fetch_ya_api_planer(urlString: <#T##String#>)
            model_uid.finish_uid = temp_uid_city
            
            

            /*
            if let tempPosition = (arr.object(at: 0) as? NMAGeocodeResult)?.location?.position {
                position = tempPosition
                print("geo pos : \(tempPosition)")
                mapView.set(geoCenter: NMAGeoCoordinates(latitude: tempPosition.latitude, longitude: tempPosition.longitude), animation: .linear)
                self.route.append(NMAGeoCoordinates(latitude: tempPosition.latitude, longitude: tempPosition.longitude))
                //locationLabel.text = "Lat: \(tempPosition.latitude) \n Long: \(tempPosition.longitude)"
            }*/
        }
}
