//
//  CacheType.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import Foundation
import UIKit.UIImage

/// CacheType represents an interface for in-memory or disk image-cache
protocol CacheType: class {
    // Returns the image associated with a given key
    func image(forKey key: String) -> UIImage?
    // Inserts the image of the specified key in the cache
    func insertImage(_ image: UIImage, forKey key: String)
    // Removes the image of the specified key from the cache
    func removeImage(forKey key: String)
}
