//
//  LoginRequest.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

struct LoginRequest: Encodable {
    
    let provider: SocialLoginProvider
    
    let socialToken: String
}

struct SocialLoginCredential {
    
    let provider: SocialLoginProvider
    
    let socialId: String
    
    let socialToken: String
    
    var loginRequest: LoginRequest {
        LoginRequest(
            provider: provider,
            socialToken: socialToken
        )
    }
}
