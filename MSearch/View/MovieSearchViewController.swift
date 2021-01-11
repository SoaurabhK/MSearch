//
//  MovieSearchViewController.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//
//

import UIKit

/// MovieSearchViewController is the main view-controller of the app to manage movie search and listing.
class MovieSearchViewController: UIViewController {
    private let movieSearchViewModel: MovieSearchViewModel
    
    private lazy var movieSearchController: UISearchController = {
        let movieSearchController = UISearchController(searchResultsController: nil)
        movieSearchController.obscuresBackgroundDuringPresentation = false
        movieSearchController.searchBar.delegate = self
        movieSearchController.searchBar.autocapitalizationType = .none
        movieSearchController.searchBar.autocorrectionType = .no
        movieSearchController.searchBar.placeholder = "Search Movies"
        
        movieSearchController.searchBar.tintColor = .darkText
        movieSearchController.searchBar.barTintColor = .darkText
        
        let whiteTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText]
        let textFieldInSearchBar = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        textFieldInSearchBar.defaultTextAttributes = whiteTitleAttributes
        return movieSearchController
    }()
    
    private lazy var selectBarButtonItem: UIBarButtonItem = {
        let selectBarButtonItem = UIBarButtonItem.imageButton(self, action: #selector(selectBarButtonItemTapped(_:)), image: .select)
        selectBarButtonItem.tintColor = .darkText
        return selectBarButtonItem
    }()
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        let addBarButtonItem = UIBarButtonItem.imageButton(self, action: #selector(addBarButtonItemTapped(_:)), image: .add)
        addBarButtonItem.tintColor = .darkText
        return addBarButtonItem
    }()
    
    private lazy var movieCollectionViewController: MovieCollectionViewController = {
        let movieCollectionViewController = MovieCollectionViewController(viewModel: movieSearchViewModel.movieCollectionViewModel)
        return movieCollectionViewController
    }()
    
    init(viewModel: MovieSearchViewModel) {
        movieSearchViewModel = viewModel
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
        
        // Update and style UI after loading the view.
        styleUI()
        updateUI()
    }
    
    func styleUI() {
        title = Title.search
        
        navigationItem.searchController = movieSearchController
        navigationItem.rightBarButtonItem = selectBarButtonItem
        
        tabBarItem = UITabBarItem(title: Title.search, image: .search, tag: 0)
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        let whiteTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText, NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        navigationController?.navigationBar.titleTextAttributes = whiteTitleAttributes
    }
    
    func updateUI() {
        movieSearchViewModel.mode.bindAndFire { [unowned self] (mode) in
            switch mode {
            case .view:
                navigationItem.leftBarButtonItem = nil
                (selectBarButtonItem.customView as? UIButton)?.setImage(.select, for: .normal)
            case .select:
                navigationItem.leftBarButtonItem = addBarButtonItem
                (selectBarButtonItem.customView as? UIButton)?.setImage(.cancel, for: .normal)
            }
        }
    }
    
    @objc func selectBarButtonItemTapped(_ buttonItem: UIBarButtonItem) {
        // toggle selection mode
        movieSearchViewModel.toggleMode()
    }
    
    @objc func addBarButtonItemTapped(_ buttonItem: UIBarButtonItem) {
        // handle addToPlaylist
        movieSearchViewModel.addToPlaylistTapped()
        movieCollectionViewController.addSelectedItemsToPlaylist()
    }
    
    @objc private func searchMovies(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        movieSearchViewModel.searchMovies(for: query)
    }
}

//MARK:- SearchBar delegate
extension MovieSearchViewController: UISearchBarDelegate  {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchMovies(_:)), object: searchBar)
        perform(#selector(self.searchMovies(_:)), with: searchBar, afterDelay: 0.5)
    }
}
