//
//  Movie.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import Foundation

// MARK: - Movie
struct Movie: Codable, Hashable {
    let id: String
    let year: String
    let title: String
    let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case id = "imdbID"
        case imageURL = "Poster" // valid url or "N/A"
    }
    
    init(id: String, year: String, title: String, imageURL: URL) {
        self.id = id
        self.year = year
        self.title = title
        self.imageURL = imageURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(String.self, forKey: .id)
        let year = try container.decode(String.self, forKey: .year)
        let title = try container.decode(String.self, forKey: .title)
        let url = try container.decode(String.self, forKey: .imageURL)
        let comps = URLComponents(string: url)
        
        guard let components = comps,
              let scheme = components.scheme,
              let imageURL = components.url,
              (scheme == "http" || scheme == "https") else {
            // we are not catching this error up the call stack, instead wrapping Movie objects in Throwable
            throw NSError(domain: "Bad Image URL", code: -1, userInfo: nil)
        }
        
        self.init(id: id, year: year, title: title, imageURL: imageURL)
    }
}
