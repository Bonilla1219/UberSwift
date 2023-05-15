//
//  LocationManager.swift
//  UberSwift
//
//  Created by Javier Bonilla on 5/6/23.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject{
    
    private let locationManager = CLLocationManager()
    
    override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else {return}
        //we call StopUpdatingLocation to allow for location to only update once when needed and not
        //have a constant update which and put lots of stress on the app
        locationManager.stopUpdatingLocation()
    }
}
