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
                    HStack {
                        if let imageURL = item.imageURL {
                            AsyncImage(url: URL(string: imageURL)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 90)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.pubDate)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
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
