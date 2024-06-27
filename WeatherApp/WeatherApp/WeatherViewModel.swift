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
    
    @Published var currentWeather: CurrentWeather?
    @Published var hourlyForecast: [HourWeather] = []
    @Published var dailyForecast: [DayWeather] = []
    @Published var error: Error?
    
    init(location: CLLocation) {
        self.location = location
        self.error = nil
    }
    
    func fetchWeather() async {
        do {
            let forecast = try await weatherService.weather(for: location)
            DispatchQueue.main.async {
                self.currentWeather = forecast.currentWeather
                self.hourlyForecast = Array(forecast.hourlyForecast.prefix(24))
                self.dailyForecast = Array(forecast.dailyForecast.prefix(10))
            }
        } catch {
            self.error = error
        }
    }
}
