//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/27/24.
//

import SwiftUI

struct WeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    @State var headerOffset: CGFloat = 0
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section {
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                self.headerOffset = proxy.frame(in: .global).minY
                            }
                            .onChange(of: proxy.frame(in: .global).minY) { old, newValue in
                                self.headerOffset = newValue
                            }
                    }
                    .frame(height: 0)
                    
                    CardView {
                        Text("Cloudy conditions from 1AM-9AM, with showers expected at 9AM.")
                        Spacer()
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(0..<10) { index in
                                    HourlyForecastView()
                                }
                            }
                        }
                        .frame(height: 120)
                    }
                    
                    CardView(title: "10-DAY FORCAST", systemImage: "calendar") {
                        VStack(alignment: .leading) {
                            ForEach(0..<10) { index in
                                DailyForecastView()
                            }
                        }
                    }
                    
                } header: {
                    HeaderView(headerOffset: headerOffset)
                        .padding(.bottom, 20)
                }
            }
            .foregroundStyle(.white)
            .padding()
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    WeatherView()
}
