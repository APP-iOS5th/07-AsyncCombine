//
//  BookDetailView.swift
//  BookShelf
//
//  Created by Jungman Bae on 6/17/24.
//

import SwiftUI

struct BookDetailView: View {
    @Binding var book: Book
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    BookDetailView(book: .constant(Book(title: "test", author: "test", isbn: "test", pages: 0)))
}
