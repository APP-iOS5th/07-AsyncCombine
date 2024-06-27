//
//  BottomNavigationView.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/27/24.
//

import SwiftUI

struct BottomNavigationView: View {
    let selectedIndex: Int
    let count: Int
    
    var body: some View {
        HStack {
            Button {
                print("지도 출력")
            } label: {
                Image(systemName: "map")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .tint(.white)
            }
            Spacer()
            HStack {
                ForEach(0..<count, id: \.self) { index in
                    Image(systemName: index == 0 ? "location.fill" : "circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 8, height: 8)
                        .foregroundStyle(.white)
                        .foregroundStyle(selectedIndex == index ? Color.white : Color(UIColor.lightGray))
                }
            }
            Spacer()
            Button {
                print("목록 출력")
            } label: {
                Image(systemName: "list.bullet")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .tint(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .padding(.bottom, 22)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    BottomNavigationView(selectedIndex: 0, count: 2)
        .preferredColorScheme(.dark)
}
