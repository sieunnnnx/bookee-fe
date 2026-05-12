//
//  SocialLoginError.swift
//  Bookee
//
//  Created by sieunnnx on 5/11/26.
//

import Foundation

enum SocialLoginError: Error, LocalizedError {
    
    case missingToken
    case socialLoginCancelled
    case socialLoginFailed
    case sdkNotInstalled
    case missingWindowScene
    case missingRootViewController
    case serverError(code: String, message: String)
    
    var errorDescription: String? {
        switch self {
        
        case .missingToken:
            return "소셜 로그인 토큰을 가져오지 못했습니다."
            
        case .socialLoginCancelled:
            return "소셜 로그인이 취소 되었습니다."
            
        case .socialLoginFailed:
            return "소셜 로그인에 실패했습니다."
            
        case .sdkNotInstalled:
            return "소셜 로그인 SDK가 설치되지 않았습니다."
        
        case .missingWindowScene:
            return "활성화된 화면 정보를 찾을 수 없습니다."
        
        case .missingRootViewController:
            return "로그인 화면을 표시할 수 없습니다."
        
        case .serverError(code: _, message: let message):
            return message
        }
    }
}
