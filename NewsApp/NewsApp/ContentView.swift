//
//  ContentView.swift
//  NewsApp
//
//  Created by Jungman Bae on 6/21/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = NewsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.newsItems) { item in
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.headline)
                        Text(item.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(item.pubDate)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("뉴스 검색")
            .searchable(text: $viewModel.searchQuery, prompt: "검색어를 입력하세요")
            .overlay(
                Group {
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
