//
//  LocationManager.swift
//  iUber
//
//  Created by Sage Turner on 11/19/24.
//

import Foundation
import CoreLocation

// Location manager (the thing that gets called to do geolocation)
class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else { return }
//        print(locations.first)
        locationManager.stopUpdatingLocation()
    }
}
