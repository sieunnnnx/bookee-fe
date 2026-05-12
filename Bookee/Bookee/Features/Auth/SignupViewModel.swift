//
//  SignupViewModel.swift
//  Bookee
//
//  Created by sieunnnx on 5/11/26.
//

import Foundation
import Combine

@MainActor
final class SignupViewModel: ObservableObject {
    
    @Published var signupRequest: SignupRequest
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(pendingSignup: PendingSignup) {
        self.signupRequest = SignupRequest(
            termAgreements: [],
            provider: pendingSignup.provider,
            socialId: pendingSignup.socialId,
            socialToken: pendingSignup.socialToken,
            profileImgUrl: nil,
            nickname: "",
            birthday: "",
            email: ""
        )
    }
    
    func updateTerms(_ agreements: [TermAgreement]) {
        signupRequest.termAgreements = agreements
    }
    
    func updateProfile(
        nickname: String,
        profileImgUrl: String?,
        birthday: String
    ) {
        signupRequest.nickname = nickname
        signupRequest.profileImgUrl = profileImgUrl
        signupRequest.birthday = birthday
    }
    
    func updateEmail(_ email: String) {
        signupRequest.email = email
    }
    
    func signup() async -> Bool {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            try await APIClient.shared.requestVoid(
                endpoint: AuthEndpoint.signup(signupRequest)
            )
            return true
            
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
            return false
        }
    }
    
    func loginAfterSignup() async -> Bool {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let response = try await APIClient.shared.request(
                endpoint: AuthEndpoint.socialLogin(
                    LoginRequest(
                        provider: signupRequest.provider,
                        socialToken: signupRequest.socialToken
                    )
                ),
                responseType: SocialLoginResponse.self
            )
            
            TokenStorage.shared.save(
                accessToken: response.accessToken,
                refreshToken: response.refreshToken
            )
            return true
            
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
            return false
        }
    }
}
