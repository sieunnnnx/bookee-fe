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
    
    private var continuation: CheckedContinuation<String, Error>?
    private var presentationWindow: ASPresentationAnchor?
    
    func login() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            
            guard let window = Self.findPresentationWindow() else {
                continuation.resume(throwing: SocialLoginError.missingWindowScene)
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
}

extension AppleLoginService: ASAuthorizationControllerDelegate {
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = credential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8) else {
            continuation?.resume(throwing: SocialLoginError.missingToken)
            continuation = nil
            presentationWindow = nil
            return
        }
        
        continuation?.resume(returning: tokenString)
        continuation = nil
        presentationWindow = nil
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        if let authError = error as? ASAuthorizationError,
           authError.code == .canceled {
            continuation?.resume(throwing: SocialLoginError.socialLoginCancelled)
        } else {
            continuation?.resume(throwing: error)
        }
        
        continuation = nil
        presentationWindow = nil
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
            preconditionFailure("활성화된 화면 정보를 찾을 수 없습니다.")
        }
        
        return window
    }
}
