//
//  HeaderView.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/27/24.
//

import SwiftUI

struct HeaderView: View {
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
            Text("Seongnam-si")
                .font(.system(size: 40))
            ZStack(alignment: .top) {
                HStack {
                    Text("19°")
                    Text("|")
                    Text("흐림")
                }
                .font(.system(size: 23))
                .opacity(headerOffset < smallTextAppear ? 1 : 0)
                Text("21°")
                    .font(.system(size: 110, weight: .thin))
                    .opacity(headerOffset < largeTextEnd ?
                             (headerOffset - largeTextStart) / (largeTextEnd - largeTextStart) : 1)
            }
            Text("Partly Cloudy")
                .font(.system(size: 25))
                .opacity(headerOffset < partlyCloudyEnd ?
                         (headerOffset - partlyCloudyStart) / (partlyCloudyEnd - partlyCloudyStart) : 1)
            HStack {
                Text("H:29°")
                Text("L:15°")
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

#Preview {
    HeaderView(headerOffset: 0)
}
