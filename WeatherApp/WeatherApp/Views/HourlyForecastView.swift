//
//  HourlyForecastView.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/27/24.
//

import SwiftUI

struct HourlyForecastView: View {
    var body: some View {
        VStack {
            Text("10PM")
            Spacer()
            Image(systemName: "cloud.fill")
                .font(.largeTitle)
            Spacer()
            Text("21°")
                .font(.system(size: 21, weight: .semibold))
        }
    }
}

#Preview {
    HourlyForecastView()
}
