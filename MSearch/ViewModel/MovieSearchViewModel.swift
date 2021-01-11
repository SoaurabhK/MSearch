//
//  MovieSearchViewModel.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import Foundation
import UIKit.UIImage

/// Mode describes view or selected state
enum Mode {
    case view
    case select
}

/// MovieSearchViewModel holds presentation logic for the corresponding viewcontroller
class MovieSearchViewModel: NSObject {
    private let movieModel: MovieModel
    private(set) var mode: Dynamic<Mode>
    private(set) lazy var movieCollectionViewModel = MovieCollectionViewModel(model: self.movieModel, state: Dynamic(.empty(Constant.noMovies)), mode: Dynamic(.view))
    
    init(model: MovieModel, mode: Dynamic<Mode> = Dynamic(.view)) {
        movieModel = model
        self.mode = mode
    }
    
    func searchMovies(for query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        movieCollectionViewModel.searchMovies(for: query, page: 1)
    }
    
    func toggleMode() {
        mode.value = mode.value == .view ? .select : .view
        movieCollectionViewModel.toggleMode()
    }
    
    func addToPlaylistTapped() {
         mode.value = .view
    }
}
