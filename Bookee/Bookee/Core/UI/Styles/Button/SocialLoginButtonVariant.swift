//
//  SocialLoginButtonVariant.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import SwiftUI

enum SocialLoginButtonVariant {
    case kakao
    case google
    case apple
    
    var title: LocalizedStringKey {
        switch self {
            
        case .google:
            return "구글계정으로 계속하기"
            
        case .kakao:
            return "카카오톡으로 계속하기"
            
        case .apple:
            return "Apple 계정으로 계속하기"
        }
    }
    
    var iconName: String {
        switch self {
            
        case .google:
            return "icon-sns-google"
            
        case .kakao:
            return "icon-sns-kakao"
            
        case .apple:
            return "icon-sns-apple"
        }
    }
    
    var backgroundColor: Color {
        switch self {
            
        case .google:
            return Color.loginBtnBgGoogle
            
        case .kakao:
            return Color.loginBtnBgKakao
            
        case .apple:
            return Color.loginBtnBgApple
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .kakao:
            return Color.loginBtnTextGoogle
            
        case .google:
            return Color.loginBtnTextKakao
            
        case .apple:
            return Color.loginBtnTextApple
        }
    }
}
