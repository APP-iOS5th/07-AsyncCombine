//
//  NewsItem.swift
//  NewsApp2
//
//  Created by Jungman Bae on 6/21/24.
//

import Foundation

struct NewsItem: Codable, Identifiable {
    let id = UUID()
    let title: String
    let link: String
    let originallink: String
    let description: String
    let pubDate: String

    enum CodingKeys: String, CodingKey {
        case title, link, originallink, description, pubDate
    }
}

struct  NewsResponse: Codable {
    let total: Int
    let items: [NewsItem]
}
