//
//  ToastView.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import UIKit

extension UIViewController {
    
    /// Displays toast with fade animation on the viewcontroller
    /// - Parameter message: toast message 
    func showToast(message: String) {
        let toastContainer = UIView(frame: .zero)
        toastContainer.backgroundColor = UIColor.darkText.withAlphaComponent(0.75)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 15;
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: .zero)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = .preferredFont(forTextStyle: .body)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        self.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toastLabel.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 10),
            toastLabel.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -10),
            toastLabel.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -10),
            toastLabel.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            toastContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 65),
            toastContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -65),
            toastContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
        ])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
