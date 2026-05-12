//
//  LoginView.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            AppHeader(leftIconName: "icon-prev")
                .padding(.horizontal, Spacing.spacing16)
            
            Spacer()
            
            VStack(spacing: Spacing.spacing12) {
                SocialLoginButton(variant: .google) {
                    login(provider: .google)
                }
                
                SocialLoginButton(variant: .kakao) {
                    login(provider: .kakao)
                }
                
                SocialLoginButton(variant: .apple) {
                    login(provider: .apple)
                }
            }
            .padding(.horizontal, Spacing.spacing16)
            .padding(.bottom, 50)
        }
        .background(Color.white)
        .disabled(viewModel.isLoading)
        .fullScreenCover(item: $viewModel.pendingSignup) { pendingSignup in
            SignupFlowView(pendingSignup: pendingSignup)
        }
    }
    
    private func login(provider: SocialLoginProvider) {
        Task {
            await viewModel.login(provider: provider)
        }
    }
}

#Preview {
    LoginView()
}
