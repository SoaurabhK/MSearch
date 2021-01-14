//
//  AppSetup.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import UIKit

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private var playlistCoordinator: PlaylistCoordinator!
    private var movieSearchCoordinator: MovieSearchCoordinator!
    
    init(window: UIWindow) {
        self.window = window
        self.window.backgroundColor = .white
    }
    
    /// Initialises view heirarchy for the application
    func start() {
        playlistCoordinator = PlaylistCoordinator(navigationController: UINavigationController())
        playlistCoordinator.parentCoordinator = self
        playlistCoordinator.start()
        
        
        movieSearchCoordinator = MovieSearchCoordinator(navigationController: UINavigationController())
        movieSearchCoordinator.parentCoordinator = self
        movieSearchCoordinator.start()
        
        self.window.rootViewController = MainTabBarController(movieSearchCoordinator: movieSearchCoordinator, playlistCoordinator: playlistCoordinator)
        
        self.window.makeKeyAndVisible()
    }
}

extension AppCoordinator: AddToPlaylistCoordinatorDelegate {
    func add(movies: [Movie]) {
        playlistCoordinator.add(movies: movies)
    }
}
