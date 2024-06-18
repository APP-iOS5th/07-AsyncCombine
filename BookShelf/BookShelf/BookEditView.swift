//
//  BookEditView.swift
//  BookShelf
//
//  Created by Jungman Bae on 6/18/24.
//

import SwiftUI

struct BookEditView: View {
    @Binding var book: Book
    @State var isISBNValid = false
    
    var body: some View {
        Form {
            TextField("Book title", text: $book.title)
            Image(book.largeCoverImageName)
            TextField("Author", text: $book.author)
            VStack(alignment: .leading) {
                if !isISBNValid {
                    Text("ISBN is invalid")
                        .font(.caption)
                        .foregroundStyle(Color.red)
                }
                TextField("ISBN", text: $book.isbn)
            }
            TextField("Pages", value: $book.pages,
                      formatter: NumberFormatter())
            Toggle("Read", isOn: $book.isRead)
        }
        .onChange(of: book.isbn) {
            print("TEST \(self.isISBNValid)")
            print("isbn: \(book.isbn)")
            self.isISBNValid = checkISBN(isbn: book.isbn)
            
        }
    }
    
    func checkISBN(isbn: String) -> Bool {
      guard !isbn.isEmpty else {
        return false
      }
      
      let sum = isbn
        .compactMap { $0.wholeNumberValue }
        .enumerated()
        .map { $0.offset & 1 == 1 ? 3 * $0.element : $0.element }
        .reduce(0, +)
      
      return sum % 10 == 0
    }

}

#Preview {
    BookEditView(book: .constant(Book.sampleBooks[0]))
}
