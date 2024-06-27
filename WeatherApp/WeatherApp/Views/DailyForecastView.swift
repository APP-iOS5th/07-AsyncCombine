//
//  DailyForecastView.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/27/24.
//

import SwiftUI
import WeatherKit

struct DailyForecastView: View {
    let forecast: DayWeather
    
    var body: some View {
        VStack {
            HStack {
                Text(formatDay(forecast.date))
                    .frame(width: 64)
                Image(systemName: forecast.symbolName)
                Spacer()
                Text("\(Int(forecast.lowTemperature.value))°")
                    .foregroundStyle(.gray)
                ProgressView(value: normalizeTemperature(low: forecast.lowTemperature.value, high: forecast.highTemperature.value))
                    .frame(width: 120)
                    .tint(Color.orange)
                Text("\(Int(forecast.highTemperature.value))°")
            }
        }
        .padding(4)
        .font(.system(size: 21, weight: .semibold))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
    }
    
    func formatDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    func normalizeTemperature(low: Double, high: Double) -> Double {
        // Assuming a temperature range of -10°C to 40°C
        let minTemp: Double = -10
        let maxTemp: Double = 40
        let range = maxTemp - minTemp
        return (high - low) / range
    }

}
