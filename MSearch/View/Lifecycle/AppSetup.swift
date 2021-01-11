//
//  AppSetup.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import UIKit

class AppSetup {
    
    /// Initialises view heirarchy for the application
    /// - Parameter window: Application window 
    static func initViewHeirarchy(for window: UIWindow) {
        window.backgroundColor = .white
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .darkText
        
        let searchNavigationController = UINavigationController()
        searchNavigationController.title = Title.search
        let playlistNavigationController = UINavigationController()
        playlistNavigationController.title = Title.playlist
        
        tabBarController.viewControllers = [searchNavigationController, playlistNavigationController]
        tabBarController.tabBar.items?.last?.image = .playlist
        window.rootViewController = tabBarController
        
        let movieModel = MovieModel()
        let movieViewModel = MovieSearchViewModel(model: movieModel)
        searchNavigationController.viewControllers = [MovieSearchViewController(viewModel: movieViewModel)]
                
        window.makeKeyAndVisible()
    }
}
