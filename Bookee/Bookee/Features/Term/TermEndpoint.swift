//
//  TermEndpoint.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

enum TermEndpoint: APIEndpoint {
    case terms
    
    var path: String {
        switch self {
        case .terms:
            return "/terms"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var requiresAuth: Bool {
        false
    }
}
