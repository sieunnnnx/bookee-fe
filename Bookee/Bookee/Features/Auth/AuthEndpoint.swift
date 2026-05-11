//
//  AuthEndpoint.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

enum AuthEndpoint: APIEndpoint {
    case socialLogin(LoginRequest)
    case signup(SignupRequest)
    
    var path: String {
        switch self {
            
        case .socialLogin:
            return "/auth/login"
            
        case .signup:
            return "/auth/signup"
        }
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var body: Data? {
        switch self {
            
        case .socialLogin(let request):
            return try? JSONEncoder().encode(request)
            
        case .signup(let request):
            return try? JSONEncoder().encode(request)
        }
    }
    
    var requiresAuth: Bool {
        false
    }
}
