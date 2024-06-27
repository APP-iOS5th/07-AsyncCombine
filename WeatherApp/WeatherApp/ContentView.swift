//
//  ContentView.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/25/24.
//

import SwiftUI

//
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

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CardView<Content: View>: View {
    let title: String
    let content: Content
    
    @State var minY: CGFloat = 0
    @State var maxY: CGFloat = 0
    @State var height: CGFloat = 0
    
    private let maxOffset: CGFloat = 150 // 스크롤시 도달하는 최대 높이 (상단 오프셋)

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
        
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 10, style: .continuous)
            )
            .offset(y: min(maxOffset, max(0, -minY + maxOffset)))
            .opacity(opacity)
            .background(
                GeometryReader { proxy -> Color in
                    let min = proxy.frame(in: .global).minY
                    let max = proxy.frame(in: .global).maxY
                    
                    DispatchQueue.main.async {
                        self.minY = min
                        self.maxY = max
                        self.height = proxy.size.height
                    }
                    return Color.clear
                }
            )
        }
    }

    private var opacity: CGFloat {
        max(0, min(1, (maxY - maxOffset) / height))
    }
}

struct ContentView: View {
    @StateObject var viewModel = WeatherViewModel()
    @State var headerOffset: CGFloat = 0
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            GeometryReader { proxy in
                Image("sky")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
            }
            
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
                        CardView(title: "TEST") {
                            Text("Cloudy conditions from 1AM-9AM, with showers expected at 9AM.")
                            Text("Cloudy conditions from 1AM-9AM, with showers expected at 9AM.")
                            
                        }
                        
                        CardView(title: "TEST1") {
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
                        }
                        
                        
                        HStack {
                            Label("10-DAY FORCAST", systemImage: "calendar")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        CardView(title: "TEST2") {
                            Text("Cloudy conditions from 1AM-9AM, with showers expected at 9AM.")
                            Text("Cloudy conditions from 1AM-9AM, with showers expected at 9AM.")
                            
                        }
                        
                        VStack(alignment: .leading) {
                            ForEach(0..<20) { index in
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
                        HeaderView(headerOffset: headerOffset)
                            .padding(.bottom, 20)
                    }
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
