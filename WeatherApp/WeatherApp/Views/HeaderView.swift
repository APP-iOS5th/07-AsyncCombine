//
//  HeaderView.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/27/24.
//

import SwiftUI
import CoreLocation

struct HeaderView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    let locationName: String
    let headerOffset: CGFloat
    
    private let totalHeight: CGFloat = 260
    
    // 각 요소의 상대적 위치를 계산하는 computed properties
    private var smallTextAppear: CGFloat { totalHeight - 95 }  // 260 - 95 = 165
    private var largeTextStart: CGFloat { totalHeight - 95 }   // 260 - 95 = 165
    private var largeTextEnd: CGFloat { totalHeight - 35 }     // 260 - 35 = 225
    private var partlyCloudyStart: CGFloat { totalHeight - 35 } // 260 - 35 = 225
    private var partlyCloudyEnd: CGFloat { totalHeight - 5 }    // 260 - 5 = 255
    private var tempRangeStart: CGFloat { totalHeight - 5 }     // 260 - 5 = 255
    private var tempRangeEnd: CGFloat { totalHeight + 15 }      // 260 + 15 = 275

    var body: some View {
        VStack {
            Text(locationName)
                .font(.system(size: 40))
            ZStack(alignment: .top) {
                HStack {
                    Text("\(Int(viewModel.currentWeather?.temperature.value ?? 0))°")
                    Text("|")
                    Text(viewModel.currentWeather?.condition.description ?? "")
                }
                .font(.system(size: 23))
                .opacity(headerOffset < smallTextAppear ? 1 : 0)
                Text("\(Int(viewModel.currentWeather?.temperature.value ?? 0))°")
                    .font(.system(size: 110, weight: .thin))
                    .opacity(headerOffset < largeTextEnd ?
                             (headerOffset - largeTextStart) / (largeTextEnd - largeTextStart) : 1)
            }
            Text(viewModel.currentWeather?.condition.description ?? "")
                .font(.system(size: 25))
                .opacity(headerOffset < partlyCloudyEnd ?
                         (headerOffset - partlyCloudyStart) / (partlyCloudyEnd - partlyCloudyStart) : 1)
            HStack {
                if !viewModel.dailyForecast.isEmpty  {
                    Text("H:\(Int(viewModel.dailyForecast[0].highTemperature.value))°")
                    Text("L:\(Int(viewModel.dailyForecast[0].lowTemperature.value))°")
                }
            }
            .font(.system(size: 23))
            .opacity(headerOffset < tempRangeEnd ?
                     (headerOffset - tempRangeStart) / (tempRangeEnd - tempRangeStart) : 1)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: totalHeight)
    }
}
