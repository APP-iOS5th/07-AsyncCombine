//
//  BottomNavigationView.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/27/24.
//

import SwiftUI

struct BottomNavigationView: View {
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
            HStack(alignment: .center) {
                Image(systemName: "location.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(.white)
                
                Image(systemName: "location.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(Color(UIColor.lightGray))
                
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(.white)
                
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(Color(UIColor.lightGray))
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
    BottomNavigationView()
        .preferredColorScheme(.dark)
}
