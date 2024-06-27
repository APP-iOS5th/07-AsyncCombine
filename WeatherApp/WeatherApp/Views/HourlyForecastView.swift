//
//  HourlyForecastView.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/27/24.
//

import SwiftUI
import WeatherKit

struct HourlyForecastView: View {
    let forecast: HourWeather
    
    var body: some View {
        VStack {
            Text(formatHour(forecast.date))
            Spacer()
            Image(systemName: forecast.symbolName)
                .font(.largeTitle)
            Spacer()
            Text("\(Int(forecast.temperature.value))°")
                .font(.system(size: 21, weight: .semibold))
        }
    }
    
    func formatHour(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: date)
    }

}
