//
//  NewsItem.swift
//  NewsApp
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
    var imageURL: String?

    enum CodingKeys: String, CodingKey {
        case title, link, originallink, description, pubDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = NewsItem.decodeHTMLString(try container.decode(String.self, forKey: .title))
        link = try container.decode(String.self, forKey: .link)
        originallink = try container.decode(String.self, forKey: .originallink)
        description = NewsItem.decodeHTMLString(try container.decode(String.self, forKey: .description))
        pubDate = try container.decode(String.self, forKey: .pubDate)
    }

    static func decodeURLEncodedString(_ string: String) -> String {
        return string.removingPercentEncoding ?? string
    }

    static func decodeHTMLString(_ htmlString: String) -> String {
        guard let data = htmlString.data(using: .utf8) else {
            return htmlString
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return htmlString
        }
        
        return attributedString.string
    }

}

struct NewsResponse: Codable {
    let total: Int
    let items: [NewsItem]
}
