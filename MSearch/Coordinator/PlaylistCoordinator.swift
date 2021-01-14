//
//  PlaylistCoordinator.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 14/01/21.
//

import UIKit

final class PlaylistCoordinator: NavCoordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    private var playlistViewModel: MovieCollectionViewModel!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.title = Title.playlist
        self.navigationController.tabBarItem.image = .playlist
    }
    
    func start() {
        let movieModel = MovieModel()
        playlistViewModel = MovieCollectionViewModel(model: movieModel, state: Dynamic(.empty(Constant.noPlaylist)), mode: Dynamic(.view))
        let playlistViewController = PlaylistViewController(viewModel: playlistViewModel)
        navigationController.viewControllers = [playlistViewController]
    }
}

extension PlaylistCoordinator: AddToPlaylistCoordinatorDelegate {
    func add(movies: [Movie]) {
        if case let .populated(existingMovies) = playlistViewModel.state.value {
            playlistViewModel.state.value = .populated((existingMovies + movies).uniques)
        } else {
            playlistViewModel.state.value = .populated(movies)
        }
    }
}
