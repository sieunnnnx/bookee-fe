//
//  SignupFlowView.swift
//  Bookee
//
//  Created by Codex on 5/12/26.
//

import SwiftUI

struct SignupFlowView: View {
    
    enum Step {
        case terms
        case profile
        case email
        case complete
    }
    
    @StateObject private var signupViewModel: SignupViewModel
    @State private var step: Step = .terms
    
    let onStart: () -> Void
    
    init(
        pendingSignup: PendingSignup,
        onStart: @escaping () -> Void
    ) {
        self.onStart = onStart
        _signupViewModel = StateObject(
            wrappedValue: SignupViewModel(pendingSignup: pendingSignup)
        )
    }
    
    var body: some View {
        switch step {
        case .terms:
            TermView { termAgreements in
                signupViewModel.updateTerms(termAgreements)
                step = .profile
            }
            
        case .profile:
            SignupProfileView(
                viewModel: signupViewModel,
                onBack: { step = .terms },
                onNext: { step = .email }
            )
            
        case .email:
            SignupEmailView(
                viewModel: signupViewModel,
                onBack: { step = .profile },
                onComplete: { step = .complete }
            )
            
        case .complete:
            SignupCompleteView(
                nickname: signupViewModel.signupRequest.nickname,
                isLoading: signupViewModel.isLoading,
                errorMessage: signupViewModel.errorMessage,
                onStart: loginAfterSignup
            )
        }
    }
    
    private func loginAfterSignup() {
        Task {
            let isLoginComplete = await signupViewModel.loginAfterSignup()
            if isLoginComplete {
                onStart()
            }
        }
    }
}

#Preview {
    SignupFlowView(
        pendingSignup: PendingSignup(
            provider: .google,
            socialId: "preview",
            socialToken: "preview-token"
        ),
        onStart: {}
    )
}
