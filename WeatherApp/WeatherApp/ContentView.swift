//
//  ContentView.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/25/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // GeometryReader: 디바이스 크기를 가져와서 화면에 맞춰줌
            GeometryReader { proxy in
                Image("sky")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
            }
            TabView {
                WeatherView()
                WeatherView()
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            VStack(spacing: 0) {
                Spacer()
                Divider()
                BottomNavigationView()
            }
            .edgesIgnoringSafeArea(.all)

        }
    }
}

#Preview {
    ContentView()
}
