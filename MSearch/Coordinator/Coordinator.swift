//
//  Coordinator.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 14/01/21.
//

import UIKit

protocol Coordinator: class {
    func start()
}

protocol NavCoordinator: Coordinator {
    var navigationController: UINavigationController { get set}
    
    func start()
}
