//
//  ContentView.swift
//  BookShelf
//
//  Created by Jungman Bae on 6/17/24.
//

import SwiftUI

struct ContentView: View {
    var books: [Book] = Book.sampleBooks
    
    var body: some View {
        List(books) { book in
            BookRowView(book: book)
        }
        .listStyle(.plain)
    }
}

#Preview {
    ContentView()
}

//이전코드
//struct ContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    ContentView()
//      .previewLayout(.sizeThatFits)
//  }
//}

struct BookRowView: View {
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
