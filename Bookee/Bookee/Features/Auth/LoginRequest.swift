//
//  LoginRequest.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

struct LoginRequest: Encodable {
    
    let provider: SocialLoginProvider

    let providerToken: String
}
