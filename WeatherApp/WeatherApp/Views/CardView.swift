//
//  CardView.swift
//  WeatherApp
//
//  Created by Jungman Bae on 6/27/24.
//

import SwiftUI

struct CardView<Content: View>: View {
    let title: String
    let systemImage: String
    let content: Content
    
    @State var minY: CGFloat = 0
    @State var maxY: CGFloat = 0
    @State var height: CGFloat = 0
    
    private let maxOffset: CGFloat = 150 // 스크롤시 도달하는 최대 높이 (상단 오프셋)
    
    init(@ViewBuilder content: () -> Content) {
        self.init(title: "", systemImage: "", content: content)
    }
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.init(title: title, systemImage: "", content: content)
    }

    init(title: String, systemImage: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.systemImage = systemImage
        self.content = content()
    }
        
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 4) {
                if !title.isEmpty, !systemImage.isEmpty {
                    Label(title, systemImage: systemImage)
                } else if !title.isEmpty {
                    Text(title)
                }
                content
            }
            .padding([.top, .bottom], 8)
            .padding([.leading, .trailing], 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 10, style: .continuous)
            )
            .preferredColorScheme(.dark)
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

#Preview {
    CardView()
}
