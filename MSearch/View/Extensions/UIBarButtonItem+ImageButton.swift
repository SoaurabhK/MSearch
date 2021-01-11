//
//  UIBarButtonItem+ImageButton.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import UIKit

extension UIBarButtonItem {
    
    /// imageButton creates a UIBarButtonItem wrapping system UIButton type
    /// - Parameters:
    ///   - target: target to recieve UIBarButtonItem touch events
    ///   - action: selector to be called on the target
    ///   - imageName: image for UIBarButtonItem available in Bundle resources
    /// - Returns: UIBarButtonItem instance
    static func imageButton(_ target: Any?, action: Selector, image: UIImage?) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.tintColor = .darkText

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 19).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 19).isActive = true

        return menuBarItem
    }
}
