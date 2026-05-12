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
    
    func login() async throws -> SocialLoginCredential {
        let kakaoAccessToken = try await loginWithKakao()
        let kakaoUserId = try await requestKakaoUserId()
        
        return SocialLoginCredential(
            provider: .kakao,
            socialId: kakaoUserId,
            socialToken: kakaoAccessToken
        )
    }
    
    private func loginWithKakao() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            let completion: (OAuthToken?, Error?) -> Void = { oauthToken, error in
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
            
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk(completion: completion)
            } else {
                UserApi.shared.loginWithKakaoAccount(completion: completion)
            }
        }
    }
    
    private func requestKakaoUserId() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.me { user, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let userId = user?.id else {
                    continuation.resume(throwing: SocialLoginError.missingToken)
                    return
                }
                
                continuation.resume(returning: String(userId))
            }
        }
    }
}
