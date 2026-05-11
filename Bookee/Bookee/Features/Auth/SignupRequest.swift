//
//  SignupRequest.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

struct SignupRequest: Encodable {
    
    var termAgreements: [TermAgreement]
    
    var provider: SocialLoginProvider
    
    var socialId: String
    
    var profileImgUrl: String?
    
    var nickname: String
    
    var birthday: String
    
    var email: String
}
