//
//  ContentView.swift
//  NewsApp
//
//  Created by Jungman Bae on 6/21/24.
//

import SwiftUI

struct NewsListView: View {
    @StateObject var viewModel = NewsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.newsItems) { item in
                    NavigationLink(destination: NewsDetailView(item: item)) {                    
                        NewsRow(item: item)
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

#Preview {
    NewsListView()
}
