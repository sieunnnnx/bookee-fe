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
    }
    
    @StateObject private var signupViewModel: SignupViewModel
    @State private var step: Step = .terms
    
    init(pendingSignup: PendingSignup) {
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
                onBack: { step = .profile }
            )
        }
    }
}

#Preview {
    SignupFlowView(
        pendingSignup: PendingSignup(
            provider: .google,
            socialId: "preview"
        )
    )
}
