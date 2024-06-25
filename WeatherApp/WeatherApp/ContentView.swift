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
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    Text("Seongnam-si")
                        .font(.system(size: 40))
                    Text("21°")
                        .font(.system(size: 110, weight: .thin))
                    Text("Partly Cloudy")
                        .font(.system(size: 25))
                    HStack {
                        Text("H:29°")
                        Text("L:15°")
                    }
                    .font(.system(size: 23))
                    Text("")
                        .padding(.top)
                    Text("Cloudy conditions from 1AM-9AM, with showers expected at 9AM.")
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(0..<10) { index in
                                VStack {
                                    Text("\(index)PM")
                                    Spacer()
                                    Image(systemName: "cloud.fill")
                                        .font(.largeTitle)
                                    Spacer()
                                    Text("21°")
                                        .font(.system(size: 21, weight: .semibold))
                                }
                            }
                        }
                    }
                    .frame(height: 120)
                    
                    Section {
                        VStack(alignment: .leading) {
                            ForEach(0..<10) { index in
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
                    } header: {
                        HStack {
                            Label("10-DAY FORCAST", systemImage: "calendar")
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .foregroundStyle(.white)
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
