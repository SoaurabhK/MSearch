//
//  UIViewController+Child.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import UIKit

extension UIViewController {
    
    /// Adds a child viewcontroller,  called on a parent viewcontroller
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    // Removes child viewcontroller from parent, called on child viewcontroller
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
