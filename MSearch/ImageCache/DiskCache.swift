//
//  DiskCache.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import Foundation
import UIKit.UIImage

/// DiskCache is used to cache decoded images on disk, i.e. documentDirectory
final class DiskCache: CacheType {
    func image(forKey key: String) -> UIImage? {
        // check if there is an image on the disk
        let diskURL = self.diskURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: diskURL.path) else {
            return nil
        }
        return imageFromDisk
    }
    
    func insertImage(_ image: UIImage, forKey key: String) {
        // Turn original image into JPEG data and write to disk
        let diskURL = self.diskURL(forKey: key)
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: diskURL)
        }
    }
    
    func removeImage(forKey key: String) {
        // Remove image from the disk
        let diskURL = self.diskURL(forKey: key)
        try? FileManager.default.removeItem(at: diskURL)
    }
    
    private func diskURL(forKey key: String) -> URL {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
}
