//
//  PlaylistViewController.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import UIKit

/// PlaylistViewController wraps MovieCollectionViewController as a child to show user's playlist
class PlaylistViewController: UIViewController {
    let playlistViewModel: MovieCollectionViewModel
    
    private lazy var movieCollectionViewController: MovieCollectionViewController = {
        let movieCollectionViewController = MovieCollectionViewController(viewModel: playlistViewModel)
        return movieCollectionViewController
    }()
    
    init(viewModel: MovieCollectionViewModel) {
        playlistViewModel = viewModel
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.add(movieCollectionViewController)
        movieCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieCollectionViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            movieCollectionViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            movieCollectionViewController.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            movieCollectionViewController.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Update UI after loading the view.
        title = Title.playlist
        tabBarItem = UITabBarItem(title: Title.playlist, image: .playlist, tag: 1)
    }
}
