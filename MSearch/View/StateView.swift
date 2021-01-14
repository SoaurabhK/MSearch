//
//  LoadingView.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import UIKit

/// StateView is used to show loading, empty or error views based on state.
class StateView: UIView {
    private var textLabel: UILabel = {
        let textLabel = UILabel(frame: .zero)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.font = .preferredFont(forTextStyle: .title3)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(frame: .zero)
        spinner.style = .whiteLarge
        spinner.color = .darkText
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
        ])
        
        self.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 16.0),
            self.trailingAnchor.constraint(greaterThanOrEqualTo: textLabel.trailingAnchor, constant: 16.0)
        ])
        
        spinner.isHidden = true
        textLabel.isHidden = true
    }
    
    func setState(_ state: State) {
        switch state {
        case .loading:
            spinner.startAnimating()
            textLabel.isHidden = !spinner.isHidden
        case let .error(error):
            spinner.stopAnimating()
            textLabel.isHidden = !spinner.isHidden
            textLabel.text = (error as? Describable)?.description ?? error.localizedDescription
        case let .empty(text):
            spinner.stopAnimating()
            textLabel.isHidden = !spinner.isHidden
            textLabel.text = text
        case .paging, .populated:
            break
        }
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
