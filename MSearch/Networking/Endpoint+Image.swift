//
//  Endpoint+Image.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import Foundation
import UIKit.UIImage

extension Endpoint where A == UIImage {
    /// Loads image corresponding to a given url
    /// - Parameter imageURL: URL of the image resource
    init(imageURL: URL) {
        self = Endpoint(.get, url: imageURL) { data, _  in
            Result {
                guard let data = data,
                      let image = UIImage(data: data) else {
                    throw ImageError()
                }
                ImageCache.shared.insertImage(image, forKey: imageURL.lastPathComponent)
                return image
            }
        }
    }
}
