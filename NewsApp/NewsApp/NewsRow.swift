//
//  NewsRow.swift
//  NewsApp
//
//  Created by Jungman Bae on 6/21/24.
//

import SwiftUI

struct NewsRow: View {
    let item: NewsItem

    var body: some View {
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
}
