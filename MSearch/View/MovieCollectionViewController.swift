//
//  MovieCollectionViewController.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import UIKit

/// MovieCollectionViewController manages movie CollectionView and related events
class MovieCollectionViewController: UIViewController {
    
    private let movieCollectionViewModel: MovieCollectionViewModel
    private let movieCellIdentifier = String(describing: MovieCollectionViewCell.self)
    
    private lazy var stateView: StateView = {
        let stateView = StateView(frame: .zero)
        stateView.translatesAutoresizingMaskIntoConstraints = false
        return stateView
    }()
    
    private lazy var movieCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = false
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: movieCellIdentifier)
        
        return collectionView
    }()
    
    private lazy var cellLabelHeight: CGFloat = {
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        let twoLineHeight = "\n".size(withAttributes: attrs).height
        return twoLineHeight
    }()
    
    override func loadView() {
        super.loadView()
        
        self.add(view: movieCollectionView)
        self.add(view: stateView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Update UI after loading the view.
        updateUI()
    }
    
    init(viewModel: MovieCollectionViewModel) {
        movieCollectionViewModel = viewModel
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSelectedItemsToPlaylist() {
        guard let selectedRows = movieCollectionView.indexPathsForSelectedItems?.map({ $0.row }),
              !selectedRows.isEmpty else {
            return
        }
        
        self.showToast(message: movieCollectionViewModel.toastMessage(for: selectedRows))
        movieCollectionViewModel.add(selectedRows)
    }
    
    func updateUI() {
        movieCollectionViewModel.state.bindAndFire { [unowned self] in
            switch $0 {
            case .loading, .empty, .error:
                stateView.isHidden = false
                stateView.setState(movieCollectionViewModel.state.value)
                
                self.movieCollectionView.reloadData()
            case .populated, .paging:
                stateView.isHidden = true
                
                // insertItems with performBatchUpdates seems more costlier than reloadData
                self.movieCollectionView.reloadData()
            }
        }
        
        movieCollectionViewModel.mode.bindAndFire { [unowned self] (mode) in
            switch mode {
            case .view:
                movieCollectionView.allowsSelection = false
            case .select:
                movieCollectionView.allowsMultipleSelection = true
            }
        }
    }
    
    /// Adds subview anchored with viewcontroller's view.
    private func add(view: UIView) {
        self.view.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK:- CollectionView Datasource
extension MovieCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return movieCollectionViewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: movieCellIdentifier,
                                               for: indexPath) as! MovieCollectionViewCell
        cell.update(image: nil)
        cell.update(text: movieCollectionViewModel.formattedTextForIndex(indexPath.row))
        return cell
    }
}

// MARK:- CollectionView Delegate
extension MovieCollectionViewController: UICollectionViewDelegate {
    // Fetch cell-image and pull data for pagination
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let movie = movieCollectionViewModel.itemAtIndex(indexPath.row)
        
        movieCollectionViewModel.image(for: movie) { [weak self] (result) in
            // The index path for the movie might have changed between the
            // time the request started and finished, so find the most
            // recent index path
            // Possible(rare) when we start searching something else.
            guard let self = self,
                  let movieIndex = self.movieCollectionViewModel.firstIndex(of: movie),
                  case let .success(image) = result else {
                    return
            }
            let movieIndexPath = IndexPath(item: movieIndex, section: 0)
        
            // When the request finishes, only update the cell if it's still visible
            if let cell = collectionView.cellForItem(at: movieIndexPath) as? MovieCollectionViewCell {
                cell.update(image: image)
            }
        }
        
        // Fetch data for next page, if required.
        if case let .paging(movies, query: query, next: page) = movieCollectionViewModel.state.value,
           indexPath.row == movies.count - 1 {
            movieCollectionViewModel.searchMovies(for: query, page: page)
        }
    }
}

// MARK:- FlowLayout Delegate
extension MovieCollectionViewController: UICollectionViewDelegateFlowLayout {
    // Compute cell-size for different orientations and size-classes
    // Self sizing cells i.e. preferredLayoutAttributesFitting is expensive, so it's better if we can calculate cell size ourself.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let horizontalSizeClass = self.traitCollection.horizontalSizeClass
        let verticalSizeClass = self.traitCollection.verticalSizeClass
        let isLandscape = UIDevice.current.orientation.isLandscape || UIApplication.shared.statusBarOrientation.isLandscape
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth, cellHeight: CGFloat
        
        switch (horizontalSizeClass, verticalSizeClass, isLandscape) {
        case (.regular, .regular, true):
            // iPad in landscape orientation
            cellWidth = floor((collectionView.bounds.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - 3 * flowLayout.minimumInteritemSpacing) / 4)
        case (.compact, _, _):
            // iPhones of all sizes in portrait orientation OR
            // iPhones with 4, 4.7, or 5.8-inch screens in landscape orientation
            cellWidth = floor((collectionView.bounds.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing) / 2)
        case (.regular, _, _):
            // iPhones with 5.5, 6.1, or 6.5-inch screens in landscape orientation OR
            // iPad in portrait orientation
            cellWidth = floor((collectionView.bounds.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - 2 * flowLayout.minimumInteritemSpacing) / 3)
        default:
            cellWidth = floor((collectionView.bounds.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing) / 2)
        }
        cellHeight = floor((3 * cellWidth) / 2 + cellLabelHeight + 16)

        return CGSize(width: cellWidth, height: cellHeight)
    }
}

