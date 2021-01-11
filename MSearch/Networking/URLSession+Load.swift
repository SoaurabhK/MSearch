//
//  URLSession+Load.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import Foundation
import UIKit.UIImage

extension URLSession {
    /// Loads an endpoint by creating (and directly resuming) a data task.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint.
    ///   - onComplete: The completion handler.
    /// - Returns: The data task.
    @discardableResult
    func load<A>(_ endpoint: Endpoint<A>, onComplete: @escaping (Result<A, Error>) -> ()) -> URLSessionDataTask {
        let request = endpoint.request
        let task = dataTask(with: request, completionHandler: { data, resp, err in
            if let err = err {
                onComplete(.failure(err))
                return
            }
            
            guard let response = resp as? HTTPURLResponse else {
                onComplete(.failure(UnknownError()))
                return
            }
            
            guard endpoint.expectedStatusCode(response.statusCode) else {
                onComplete(.failure(WrongStatusCodeError(statusCode: response.statusCode, response: response, responseBody: data)))
                return
            }
            
            onComplete(endpoint.parse(data, resp))
        })
        task.resume()
        return task
    }
    
    /// Return image from either cache or network for a given endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint.
    ///   - onComplete: The completion handler.
    /// - Returns: The data task.
    func load(_ endpoint: Endpoint<UIImage>, onComplete: @escaping (Result<UIImage, Error>) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // check if there is a cached image for a given cacheKey
            if let cacheKey = endpoint.request.url?.lastPathComponent,
               let cachedImage = ImageCache.shared.image(forKey: cacheKey) {
                onComplete(.success(cachedImage))
                return
            }
            
            let task = self.dataTask(with: endpoint.request, completionHandler: { data, resp, err in
                if let err = err {
                    onComplete(.failure(err))
                    return
                }
                
                guard let response = resp as? HTTPURLResponse else {
                    onComplete(.failure(UnknownError()))
                    return
                }
                
                guard endpoint.expectedStatusCode(response.statusCode) else {
                    onComplete(.failure(WrongStatusCodeError(statusCode: response.statusCode, response: response, responseBody: data)))
                    return
                }
                
                onComplete(endpoint.parse(data, resp))
            })
            task.resume()
        }
    }
}

