//
//  DailyForecastView.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/27/24.
//

import SwiftUI

struct DailyForecastView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Mon")
                Image(systemName: "sun.max.fill")
                Text("15°")
                    .foregroundStyle(.gray)
                ProgressView(value: 0.5)
                    .tint(Color.orange)
                Text("29°")
            }
        }
        .padding(4)
        .font(.system(size: 21, weight: .semibold))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    DailyForecastView()
}
