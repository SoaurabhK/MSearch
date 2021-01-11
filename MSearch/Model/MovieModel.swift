//
//  SearchMoviesModel.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import Foundation
import UIKit.UIImage

/// MovieModel acts as a service to query movies, images from OMDB API
class MovieModel {
    private enum OMDBAPI {
        static let baseURL = "http://omdbapi.com/"
        static let key = "c12bbaf4"
        static let type = "movie"
    }
    
    func seachMovies(for searchTerm: String,
                     page: Int = 1,
                     completion: @escaping(Result<SearchResponse, Error>) -> Void) {
        
        let searchEndpoint = Endpoint<SearchResponse>(json: .get,
                                                      url: URL(string: OMDBAPI.baseURL)!,
                                                      query: ["s": searchTerm, "type": OMDBAPI.type, "apikey": OMDBAPI.key, "page": String(page)])
        
        URLSession.shared.load(searchEndpoint) { (result) in
            completion(result)
        }
    }
    
    func getImage(for url: URL, completion: @escaping(Result<UIImage, Error>) -> Void) {
        let imageEndpoint = Endpoint<UIImage>(imageURL: url)
            
        URLSession.shared.load(imageEndpoint) { (imageResult) in
            completion(imageResult)
        }
    }
}
