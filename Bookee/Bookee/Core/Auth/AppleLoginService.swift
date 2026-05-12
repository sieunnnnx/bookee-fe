//
//  AppleLoginService.swift
//  Bookee
//
//  Created by sieunnnx on 5/11/26.
//

import Foundation
import UIKit
import AuthenticationServices

final class AppleLoginService: NSObject {
    
    static let shared = AppleLoginService()
    
    private override init() {}
    
    private var continuation: CheckedContinuation<SocialLoginCredential, Error>?
    private var presentationWindow: ASPresentationAnchor?
    
    func login() async throws -> SocialLoginCredential {
        try await withCheckedThrowingContinuation { continuation in
            
            guard let window = Self.findPresentationWindow() else {
                continuation.resume(
                    throwing: SocialLoginError.missingWindowScene
                )
                return
            }
            
            self.continuation = continuation
            self.presentationWindow = window
            
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(
                authorizationRequests: [request]
            )
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
    
    private static func findPresentationWindow() -> ASPresentationAnchor? {
        let windowScene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
        
        if let keyWindow = windowScene?
            .windows
            .first(where: { $0.isKeyWindow }) {
            return keyWindow
        }
        
        if #available(iOS 26.0, *),
           let windowScene {
            return ASPresentationAnchor(windowScene: windowScene)
        }
        
        return nil
    }
    
    private func clear() {
        continuation = nil
        presentationWindow = nil
    }
}

extension AppleLoginService: ASAuthorizationControllerDelegate {
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(
                throwing: SocialLoginError.socialLoginFailed
            )
            clear()
            return
        }
        
        guard let identityToken = credential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8) else {
            continuation?.resume(
                throwing: SocialLoginError.missingToken
            )
            clear()
            return
        }
        
        let socialCredential = SocialLoginCredential(
            provider: .apple,
            socialId: credential.user,
            socialToken: tokenString
        )
        
        continuation?.resume(returning: socialCredential)
        clear()
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        if let authError = error as? ASAuthorizationError,
           authError.code == .canceled {
            continuation?.resume(
                throwing: SocialLoginError.socialLoginCancelled
            )
        } else {
            continuation?.resume(
                throwing: error
            )
        }
        
        clear()
    }
}

extension AppleLoginService: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(
        for controller: ASAuthorizationController
    ) -> ASPresentationAnchor {
        
        if let presentationWindow {
            return presentationWindow
        }
        
        guard let window = Self.findPresentationWindow() else {
            preconditionFailure(
                SocialLoginError.missingWindowScene.localizedDescription
            )
        }
        
        return window
    }
}
