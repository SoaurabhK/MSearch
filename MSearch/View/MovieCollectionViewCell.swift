//
//  MovieCollectionViewCell.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import UIKit

/// MovieCollectionViewCell represents a collectionViewCell for movie posters
class MovieCollectionViewCell: UICollectionViewCell {
    private var textLabelTrailingConstraint: NSLayoutConstraint!
    
    private var movieImageView: UIImageView = {
        let movieImageView = UIImageView(frame: .zero)
        movieImageView.backgroundColor = .clear
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        return movieImageView
    }()
    
    private var textLabel: UILabel = {
        let textLabel = UILabel(frame: .zero)
        textLabel.textAlignment = .left
        textLabel.numberOfLines = 2
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.font = .preferredFont(forTextStyle: .body)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(frame: .zero)
        spinner.style = .white
        spinner.color = .darkText
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private var selectIndicator: UIImageView = {
        let selectIndicator = UIImageView(frame: .zero)
        selectIndicator.image = .select
        selectIndicator.contentMode = .scaleAspectFill
        selectIndicator.clipsToBounds = true
        selectIndicator.isHidden = true
        selectIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return selectIndicator
    }()
    
    override var isSelected: Bool {
      didSet {
        selectIndicator.isHidden = !isSelected
        textLabelTrailingConstraint.constant = isSelected ? -30 : -8
      }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(movieImageView)
        self.contentView.addSubview(textLabel)
        self.contentView.addSubview(spinner)
        self.contentView.addSubview(selectIndicator)
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.white.cgColor
        
        // Activate all layoutConstraint together for batch layout update.
        textLabelTrailingConstraint = textLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8.0)
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: self.textLabel.topAnchor, constant: -8.0),
            movieImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0),
            textLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0),
            textLabelTrailingConstraint,
            spinner.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            selectIndicator.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0),
            selectIndicator.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8.0),
            selectIndicator.widthAnchor.constraint(equalToConstant: 19.0),
            selectIndicator.heightAnchor.constraint(equalToConstant: 19.0),
        ])
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    func update(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            movieImageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            movieImageView.image = nil
        }
    }
    
    func update(text: String) {
        textLabel.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fatalError("Interface Builder is not supported!")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fatalError("Interface Builder is not supported!")
    }
}
