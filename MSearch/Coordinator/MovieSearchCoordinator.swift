//
//  AppCoordinator.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 14/01/21.
//

import UIKit

final class MovieSearchCoordinator: NavCoordinator {
    weak var parentCoordinator: (Coordinator & AddToPlaylistCoordinatorDelegate)?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.title = Title.search
        self.navigationController.tabBarItem.image = .search
    }
    
    func start() {
        let movieModel = MovieModel()
        let movieViewModel = MovieSearchViewModel(model: movieModel)
        movieViewModel.coordinatorDelegate = self
        navigationController.viewControllers = [MovieSearchViewController(viewModel: movieViewModel)]
    }
}

extension MovieSearchCoordinator: AddToPlaylistCoordinatorDelegate {
    func add(movies: [Movie]) {
        parentCoordinator?.add(movies: movies)
    }
}
