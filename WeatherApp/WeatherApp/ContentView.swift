//
//  ContentView.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/25/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                print("get location")
                viewModel.requestLocation()
            } label: {
                Text("Get Location")
            }
            Button {
                print("get weather")
                Task {
                    if let location = viewModel.location {
                        await viewModel.fetchWeather(for: location)
                    } else {
                        print("no location")
                    }
                }
            } label: {
                Text("Get Weather")
            }
            if let error = viewModel.error {
                Text("\(error)")
                    .foregroundStyle(.red)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
