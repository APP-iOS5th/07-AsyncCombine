//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/27/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let manager = CLLocationManager()

    @Published var error: Error?
    @Published var currentLocation: CLLocation?
    @Published var saveLocations: [CLLocation] = [
        CLLocation(latitude: 37.56661, longitude: 126.978388)
    ]
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        manager.requestLocation()
    }

    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        print("location: \(currentLocation?.description ?? "-")")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        self.error = error
    }

}
