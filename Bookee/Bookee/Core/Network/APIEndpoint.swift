//
//  APIEndpoint.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    var requiresAuth: Bool { get }
}

extension APIEndpoint {
    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var body: Data? {
        nil
    }
    
    var requiresAuth: Bool {
        true
    }
}
