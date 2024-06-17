//
//  ContentView.swift
//  BookShelf
//
//  Created by Jungman Bae on 6/17/24.
//

import SwiftUI

struct BookListView: View {
    var books: [Book] = Book.sampleBooks
    
    var body: some View {
        List(books) { book in
            BookRowView(book: book)
        }
        .listStyle(.plain)
    }
}

#Preview {
    BookListView()
}

//이전코드
//struct ContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    ContentView()
//      .previewLayout(.sizeThatFits)
//  }
//}
