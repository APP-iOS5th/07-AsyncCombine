//
//  WordDetailView.swift
//  WordBrowser
//
//  Created by Jungman Bae on 6/24/24.
//

import SwiftUI

struct WordDetailView: View {
    @State var word: String
    @StateObject var viewModel = WordDetailViewModel()
    var body: some View {
        ZStack {
            if viewModel.isSearching {
                ProgressView("Fetching...")
            } else {
                List {
                    Section("Definitions") {
                        ForEach(viewModel.definitions) { definition in
                            HStack {
                              VStack(alignment: .leading) {
                                Text("(\(definition.partOfSpeech))")
                                  .font(.caption)
                                Text(definition.definition)
                              }
                              Spacer()
                            }
                        }
                    }
                    .lineLimit(2)
                }
            }
        }
        .navigationTitle(word)
        .task {
            await viewModel.executeQuery(for: word)
        }
    }
}

#Preview {
    NavigationStack {
        WordDetailView(word: "Swift")
    }
}
