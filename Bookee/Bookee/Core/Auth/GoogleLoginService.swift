//
//  GoogleLoginService.swift
//  Bookee
//
//  Created by sieunnnx on 5/11/26.
//

import Foundation
import UIKit
import GoogleSignIn

final class GoogleLoginService {
    
    static let shared = GoogleLoginService()
    
    private init() {}
    
    @MainActor
    func login() async throws -> LoginRequest {
        guard let presentingViewController = UIApplication.shared.rootViewController else {
            throw SocialLoginError.missingRootViewController
        }
        
        let signInResult = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController
        )
        
        let user = signInResult.user
        
        guard let idToken = user.idToken?.tokenString else {
            throw SocialLoginError.missingToken
        }
        
        return LoginRequest(
            provider: .google,
            socialId: idToken
        )
    }
    
    func logout() {
        GIDSignIn.sharedInstance.signOut()
    }
}
