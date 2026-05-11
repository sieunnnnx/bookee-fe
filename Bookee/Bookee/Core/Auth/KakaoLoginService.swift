//
//  KakaoLoginService.swift
//  Bookee
//
//  Created by sieunnnx on 5/11/26.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth

final class KakaoLoginService {
    
    static let shared = KakaoLoginService()
    
    private init() {}
    
    func login() async throws -> LoginRequest {
        let kakaoAccessToken = try await requestKakaoAccessToken()
        
        return LoginRequest(
            provider: .kakao,
            socialId: kakaoAccessToken
        )
    }
    
    private func requestKakaoAccessToken() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    guard let accessToken = oauthToken?.accessToken else {
                        continuation.resume(throwing: SocialLoginError.missingToken)
                        return
                    }
                    
                    continuation.resume(returning: accessToken)
                }
                
            } else {
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    guard let accessToken = oauthToken?.accessToken else {
                        continuation.resume(throwing: SocialLoginError.missingToken)
                        return
                    }
                    
                    continuation.resume(returning: accessToken)
                }
            }
        }
    }
}
