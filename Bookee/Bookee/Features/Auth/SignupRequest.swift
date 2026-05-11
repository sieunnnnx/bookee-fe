//
//  SignupRequest.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

struct SignupRequest: Encodable {
    
    let termAgreements: [TermAgreement]
    
    let provider: SocialLoginProvider
    
    let socialId: String
    
    let profileImgUrl: String?
    
    let nickname: String
    
    let birthday: String
    
    let email: String
}
