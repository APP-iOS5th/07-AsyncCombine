//
//  BooksListView.swift
//  ListView
//
//  Created by Jungman Bae on 6/17/24.
//

import SwiftUI

private class BooksViewModel: ObservableObject {
    @Published var books: [Book] = Book.samples
}

struct BooksListView: View {
    @StateObject fileprivate var viewModel = BooksViewModel()
    
    var body: some View {
        List(viewModel.books) { book in
            BookRowView(book: book)
        }
    }
}

private struct BookRowView: View {
  var book: Book
  
  var body: some View {
    HStack(alignment: .top) {
      Image(book.mediumCoverImageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 90)
      VStack(alignment: .leading) {
        Text(book.title)
          .font(.headline)
        Text("by \(book.author)")
          .font(.subheadline)
        Text("\(book.pages) pages")
          .font(.subheadline)
      }
      Spacer()
    }
  }
}

#Preview {
    BooksListView()
}
