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
    
    func signup() async {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let response = try await APIClient.shared.request(
                endpoint: AuthEndpoint.signup(signupRequest),
                responseType: SocialLoginResponse.self
            )
            
            TokenStorage.shared.save(
                accessToken: response.accessToken,
                refreshToken: response.refreshToken
            )
            
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
        }
    }
}
