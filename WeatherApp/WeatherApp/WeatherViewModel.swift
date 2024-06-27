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
    
    @Published var location: CLLocation?
    @Published var error: Error?
    
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
}
