//
//  LoginResponse.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

struct SocialLoginResponse: Decodable {
    
    let accessToken: String
    
    let refreshToken: String
    
    let user: UserInfo?
}
