//
//  SocialLoginProvider.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

enum SocialLoginProvider: String, Encodable, Decodable, Sendable {
    
    case google = "GOOGLE"
    
    case kakao = "KAKAO"
    
    case apple = "APPLE"
}
