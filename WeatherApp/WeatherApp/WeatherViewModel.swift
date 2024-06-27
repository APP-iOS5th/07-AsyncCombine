//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/25/24.
//

import Foundation
import CoreLocation
import WeatherKit

class WeatherViewModel: ObservableObject {
    private let weatherService = WeatherService.shared
    
    let location: CLLocation
    
    @Published var error: Error?
    
    init(location: CLLocation) {
        self.location = location
        self.error = nil
    }
    
    func fetchWeather() async {
        do {
            let forcast = try await weatherService.weather(for: location, including: .current)
            dump(forcast)
        } catch {
            self.error = error
        }
    }
}
