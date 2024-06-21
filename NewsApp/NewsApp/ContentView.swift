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
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.newsItems) { item in
                        HStack {
                            if let imageURL = item.imageURL {
                                AsyncImage(url: URL(string: imageURL)) { image in
                                    image.resizable()
                                        .frame(width: 90, height: 60)
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 90, height: 60, alignment: .center)
                                }
                            }
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.headline)
                                Text(item.pubDate)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                    if viewModel.hasMoreData, !viewModel.isLoading {
                        ProgressView()
                            .onAppear {
                                viewModel.loadMore()
                            }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("뉴스 검색 (\(viewModel.newsItems.count) 건)")
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
