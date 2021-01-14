//
//  MainTabBarController.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 14/01/21.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let movieSearchCoordinator: NavCoordinator
    private let playlistCoordinator: NavCoordinator
    
    init(movieSearchCoordinator: NavCoordinator, playlistCoordinator: NavCoordinator) {
        self.movieSearchCoordinator = movieSearchCoordinator
        self.playlistCoordinator = playlistCoordinator
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = .darkText
        self.viewControllers = [movieSearchCoordinator.navigationController, playlistCoordinator.navigationController]
    }
}
