//
//  LoginViewModel.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var pendingSignup: PendingSignup?
    
    func login(provider: SocialLoginProvider) async {
        isLoading = true
        errorMessage = nil
        pendingSignup = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let loginRequest = try await SocialLoginService.shared.login(
                provider: provider
            )
            
            do {
                let response = try await requestSocialLogin(loginRequest)
                
                TokenStorage.shared.save(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken
                )
                
            } catch let error as APIError {
                if error.code == "AUTH-005" {
                    pendingSignup = PendingSignup(
                        provider: loginRequest.provider,
                        socialId: loginRequest.socialId
                    )
                } else {
                    errorMessage = error.errorDescription
                }
            }
            
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
        }
    }
    
    private func requestSocialLogin(
        _ request: LoginRequest
    ) async throws -> SocialLoginResponse {
        
        try await APIClient.shared.request(
            endpoint: AuthEndpoint.socialLogin(request),
            responseType: SocialLoginResponse.self
        )
    }
}
