//
//  ImageCache.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import Foundation
import UIKit.UIImage

/// ImageCache is used to cache decoded images in-memory and disk
final class ImageCache: CacheType {
    static let shared = ImageCache()
    private init() {}
    
    private let memoryCache = MemoryCache()
    private let diskCache = DiskCache()
    
    func image(forKey key: String) -> UIImage? {
        // check image from memoryCache
        if let image = memoryCache.image(forKey: key) {
            return image
        }
        
        // check image from diskCache
        guard let image = diskCache.image(forKey: key) else {
            return nil
        }
        
        // insert image in memoryCache
        memoryCache.insertImage(image, forKey: key)
        
        return image
    }
    
    func insertImage(_ image: UIImage, forKey key: String) {
        // insert decoded image in memoryCache
        let decodedImage = image.decodedImage()
        memoryCache.insertImage(decodedImage, forKey: key)
        
        // insert decoded image in diskCache
        diskCache.insertImage(decodedImage, forKey: key)
    }
    
    func removeImage(forKey key: String) {
        // Remove image from memoryCache
        memoryCache.removeImage(forKey: key)
        
        // Remove image from diskCache
        diskCache.removeImage(forKey: key)
    }
}

// MARK:- Image Decoding
fileprivate extension UIImage {
    // Decode the image on background queue explicitly
    // Image and Graphics Best Practices: https://developer.apple.com/videos/play/wwdc2018/219/
    func decodedImage() -> UIImage {
        guard let cgImage = cgImage else { return self }
        
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(data: nil, width: cgImage.width, height: cgImage.height, bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let decodedImage = context?.makeImage() else { return self }
        
        return UIImage(cgImage: decodedImage)
    }
}
