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
    func login() async throws -> SocialLoginCredential {
        guard let presentingViewController = UIApplication.shared.rootViewController else {
            throw SocialLoginError.missingRootViewController
        }
        
        let signInResult = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController
        )
        
        let user = signInResult.user
        
        guard let googleUserId = user.userID,
              let googleIDToken = user.idToken?.tokenString else {
            throw SocialLoginError.missingToken
        }
        
        return SocialLoginCredential(
            provider: .google,
            socialId: googleUserId,
            socialToken: googleIDToken
        )
    }
    
    func logout() {
        GIDSignIn.sharedInstance.signOut()
    }
}
