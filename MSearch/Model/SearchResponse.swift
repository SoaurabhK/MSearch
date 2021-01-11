//
//  SearchResponse.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import Foundation

// MARK: - SearchResponse
enum SearchResponse: Decodable {
    case success(SearchResult)
    case error(SearchError)
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case movieCount = "totalResults"
        case response = "Response"
        case error = "Error"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let error = try? container.decode(String?.self, forKey: .error)
        let response = try container.decode(String.self, forKey: .response)
        
        if let error = error {
            self = .error(SearchError(error: error, response: response))
        } else {
            // movie objects are wrapped in Throwable to filter movies with invalid url
            let throwables = try container.decode([Throwable<Movie>].self, forKey: .movies)
            let movies = throwables.compactMap { try? $0.result.get() }
            let count = Int(try container.decode(String.self, forKey: .movieCount)) ?? 0
            self = .success(SearchResult(movies: movies, movieCount: count, response: response))
        }
    }
}

// MARK: - SearchResult
struct SearchResult {
    let movies: [Movie]
    let movieCount: Int
    let response: String
    
    var totalPages: Int {
        let quotient = movieCount / 10
        let remainder = movieCount % 10
        let totalPages = quotient + (remainder == 0 ? 0 : 1)
        return totalPages
    }
}

// MARK: - SearchError
struct SearchError {
    let error: String
    let response: String
}

