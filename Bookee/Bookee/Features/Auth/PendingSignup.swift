//
//  PendingSignup.swift
//  Bookee
//
//  Created by sieunnnx on 5/11/26.
//

import Foundation

struct PendingSignup: Identifiable {
    
    let id = UUID()
    
    let provider: SocialLoginProvider
    
    let socialId: String
}
