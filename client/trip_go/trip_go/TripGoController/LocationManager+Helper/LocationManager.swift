//
//  LocationManager.swift
//  trip_go
//
//  Created by Артем Стратиенко on 24.10.2021.
//

import NMAKit
import CoreLocation

extension TripGoController  {
    // MARK 1
    func initLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
    }
    // MARK 2
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            print("Warning: No last location found")
            return
        }
        tempPosition = lastLocation.coordinate
        //checkerPointInCircle(xlat: tempPosition.latitude, ylot: tempPosition.longitude)
        print(lastLocation)
    }
    // MARK 3
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
  //      print("magneticHeading \(newHeading.magneticHeading)")
    }
    // MARK 4
    func startLocation() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    // MARK 5
    func stopLocation() {
        locationManager.stopUpdatingLocation()
    }
}
