//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/25/24.
//

import Foundation
import CoreLocation
import WeatherKit

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let weatherService = WeatherService.shared
    
    @Published var location: CLLocation?
    @Published var error: Error?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func fetchWeather(for location: CLLocation) async {
        guard let location = self.location else {
            print("Location 정보 없음")
            return
        }
        do {
            let forcast = try await weatherService.weather(for: location, including: .current)
            dump(forcast)
        } catch {
            self.error = error
        }
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
        print("location: \(location?.description ?? "-")")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        self.error = error
    }
}
