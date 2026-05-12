//
//  SignupEmailView.swift
//  Bookee
//
//  Created by Codex on 5/12/26.
//

import SwiftUI

struct SignupEmailView: View {
    
    @ObservedObject var viewModel: SignupViewModel
    @Environment(\.dismiss) private var dismiss
    
    let onBack: () -> Void
    let onComplete: () -> Void
    
    @State private var email = ""
    @State private var emailMessage: String?
    @State private var isShowingSignupCancelAlert = false
    
    private var isEmailValid: Bool {
        Self.isValidEmail(email)
    }
    
    private var emailLineColor: Color {
        if emailMessage != nil {
            return Color.inputLineError
        }
        
        return email.isEmpty ? Color.inputLineDefault : Color.inputLineActive
    }
    
    var body: some View {
        VStack(spacing: 0) {
            AppHeader(
                leftIconName: "icon-prev",
                rightIconName: "icon-cancel",
                onLeftTap: onBack,
                onRightTap: { isShowingSignupCancelAlert = true }
            )
            .padding(.horizontal, Spacing.spacing4)
            
            VStack(alignment: .leading, spacing: 44) {
                VStack(alignment: .leading, spacing: Spacing.spacing12) {
                    Text("서비스에 사용할\n이메일을 입력해주세요.")
                        .font(Typo.title)
                        .lineSpacing(Typo.titleLineSpacing)
                        .foregroundColor(Color.gray900)
                    
                    Text("이메일 인증은 필요한 경우에만 진행해요.")
                        .font(Typo.subTitle)
                        .foregroundColor(Color.gray600)
                }
                .padding(.top, Spacing.spacing16)
                
                TextInput(
                        title: "이메일",
                        placeholder: "bookee@bookee.com",
                        text: $email,
                        message: emailMessage,
                        keyboardType: .emailAddress
                )
            }
            .padding(.horizontal, Spacing.spacing16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(Typo.inputMessage)
                    .foregroundColor(Color.inputMessageError)
                    .padding(.horizontal, Spacing.spacing16)
                    .padding(.bottom, Spacing.spacing8)
            }
            
            AppButton(
                title: "다음",
                variant: .tertiary,
                isDisabled: !isEmailValid || viewModel.isLoading
            ) {
                submitEmail()
            }
            .padding(.horizontal, Spacing.spacing16)
            .padding(.bottom, Spacing.spacing16)
        }
        .background(Color.white)
        .alert("회원가입 중단", isPresented: $isShowingSignupCancelAlert) {
            Button("네", role: .cancel) {
                dismiss()
            }
            
            Button(role: .confirm) {
                isShowingSignupCancelAlert = false
            } label: {
                Text("아니오")
            }
            .keyboardShortcut(.defaultAction)
        } message: {
            Text("작성 중인 정보가 사라질 수 있어요.\n로그인 화면으로 이동할까요?")
        }
        .onChange(of: email) { _, newValue in
            emailMessage = Self.emailValidationMessage(newValue)
        }
    }
    
    private func submitEmail() {
        guard isEmailValid else {
            emailMessage = Self.emailValidationMessage(email)
            return
        }
        
        viewModel.updateEmail(email)
        
        Task {
            let isSignupComplete = await viewModel.signup()
            if isSignupComplete {
                onComplete()
            }
        }
    }
    
    private static func isValidEmail(_ email: String) -> Bool {
        emailValidationMessage(email) == nil
    }
    
    private static func emailValidationMessage(_ email: String) -> String? {
        guard !email.isEmpty else {
            return "이메일을 입력해주세요."
        }
        
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        guard email.range(of: pattern, options: .regularExpression) != nil else {
            return "올바른 이메일 형식으로 입력해주세요."
        }
        
        return nil
    }
}
