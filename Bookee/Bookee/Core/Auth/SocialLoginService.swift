//
//  SocialLoginService.swift
//  Bookee
//
//  Created by sieunnnx on 5/11/26.
//

import Foundation

final class SocialLoginService {
    
    static let shared = SocialLoginService()
    
    private init() {}
    
    func login(provider: SocialLoginProvider) async throws -> LoginRequest {
        switch provider {
            
        case .kakao:
            return try await KakaoLoginService.shared.login()
            
        case .google:
            return try await GoogleLoginService.shared.login()
            
        case .apple:
            return try await AppleLoginService.shared.login()
        }
    }
}
