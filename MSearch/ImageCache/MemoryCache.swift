//
//  MemoryCache.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import Foundation
import UIKit.UIImage

/// MemoryCache is used to cache decoded images in-memory, with default memory-limit of 100 MB
final class MemoryCache: CacheType {
    // we can add, remove, and query items in the cache from different threads without having to lock the cache ourself.
    private lazy var cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = memoryLimit
        return cache
    }()
    
    private let memoryLimit: Int // default is 100 MB
    
    init(memoryLimit: Int = 1024 * 1024 * 100) {
        self.memoryLimit = memoryLimit
    }
    
    func image(forKey key: String) -> UIImage? {
        // check if there is a image in memory
        if let image = cache.object(forKey: key as NSString) {
            return image
        }
        
        return nil
    }
    
    func insertImage(_ image: UIImage, forKey key: String) {
        // insert image in cache
        cache.setObject(image, forKey: key as NSString, cost: image.diskSize)
    }
    
    func removeImage(forKey key: String) {
        // Remove image from the cache
        cache.removeObject(forKey: key as NSString)
    }
}

// MARK:- Image DiskSize
fileprivate extension UIImage {
    // Rough estimation of how much memory image uses in bytes
    var diskSize: Int {
        guard let cgImage = cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }
}
