//
//  MovieCollectionViewModel.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import Foundation
import UIKit.UIImage

/// State describes current state of the view
enum State {
  case loading
  case paging([Movie], query: String, next: Int)
  case populated([Movie])
  case empty(String)
  case error(Error)
  
  var currentMovies: [Movie] {
    switch self {
    case .paging(let movies, _, _):
      return movies
    case .populated(let movies):
      return movies
    case .loading, .empty, .error:
      return []
    }
  }
}

/// MovieCollectionViewModel holds presentation logic for the corresponding viewcontroller
class MovieCollectionViewModel: NSObject {
    private let movieModel: MovieModel
    let mode: Dynamic<Mode>
    let state: Dynamic<State>
    
    init(model: MovieModel, state: Dynamic<State>, mode: Dynamic<Mode>) {
        self.movieModel = model
        self.state = state
        self.mode = mode
    }
    
    // MARK: Fetch Movies
    func searchMovies(for query: String, page: Int) {
        if page == 1 {
            state.value = .loading
        }
        movieModel.seachMovies(for: query, page: page) { [weak self] (searchResponse) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.update(response: searchResponse, query: query, page: page)
            }
        }
    }
        
    func image(for movie: Movie,
               completion: @escaping (Result<UIImage, Error>) -> Void) {
        movieModel.getImage(for: movie.imageURL) { (imageResult) in
            DispatchQueue.main.async {
                completion(imageResult)
            }
        }
    }
    
    private func update(response: Result<SearchResponse, Error>, query: String, page: Int) {
        switch response {
        case let .success(searchResponse):
            switch searchResponse {
            case let .success(searchResult):
                var allMovies = state.value.currentMovies
                allMovies.append(contentsOf: searchResult.movies)
                guard !allMovies.isEmpty else {
                    state.value = .empty(Constant.noResults)
                    return
                }
                
                if searchResult.totalPages > page {
                    state.value = .paging(allMovies, query: query, next: page + 1)
                } else {
                    state.value = .populated(allMovies)
                }
            case .error(_):
                // No or too many results found for a given query
                state.value = .empty(Constant.noResults)
            }
        case let .failure(error):
            state.value = .error(error)
        }
    }
    
    // MARK: Add to Playlist
    func add(_ selectedRows: [Int],
                       to playlistViewModel: MovieCollectionViewModel) {
        mode.value = .view
        let selectedMovies = selectedRows.map{ state.value.currentMovies[$0] }
        
        // Better: Delegate this to navigation co-ordinator which will set state to populated
        if case let .populated(existingMovies) = playlistViewModel.state.value {
            playlistViewModel.state.value = .populated((existingMovies + selectedMovies).uniques)
        } else {
            playlistViewModel.state.value = .populated(selectedMovies)
        }
    }
    
    func toastMessage(for selectedRows: [Int]) -> String {
        guard !selectedRows.isEmpty else { return String() }
        let count = selectedRows.count
        let message = "\(count) movie\(count > 1 ? "s" : "") added to playlist!"
        return message
    }
    
    func toggleMode() {
        mode.value = mode.value == .view ? .select : .view
    }
}

// MARK:- CollectionView Data
extension MovieCollectionViewModel {
    var numberOfItems: Int {
        return state.value.currentMovies.count
    }
    
    func itemAtIndex(_ index: Int) -> Movie {
        return state.value.currentMovies[index]
    }
    
    func formattedTextForIndex(_ index: Int) -> String {
        let movie = self.itemAtIndex(index)
        return movie.year + ", " + movie.title + "\n"
    }
    
    func firstIndex(of movie: Movie) -> Int? {
        return state.value.currentMovies.firstIndex(of: movie)
    }
}
