//
//  Error.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import Foundation

protocol Describable {
    var description: String { get }
}

/// Signals that a response's data was unexpectedly nil.
struct NoDataError: Error, Describable {
    init() { }
    
    var description: String {
        return "Couldn't get response data"
    }
}

/// An unknown error
struct UnknownError: Error, Describable {
    init() { }
    
    var description: String {
        return "An unknown error occured"
    }
}

/// Signals that a response's status code was wrong.
struct WrongStatusCodeError: Error, Describable {
    let statusCode: Int
    let response: HTTPURLResponse?
    let responseBody: Data?
    init(statusCode: Int, response: HTTPURLResponse?, responseBody: Data?) {
        self.statusCode = statusCode
        self.response = response
        self.responseBody = responseBody
    }
    
    var description: String {
        return "Couldn't get status OK"
    }
}

