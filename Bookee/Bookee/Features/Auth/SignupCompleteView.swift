//
//  SignupCompleteView.swift
//  Bookee
//
//  Created by Codex on 5/12/26.
//

import SwiftUI

struct SignupCompleteView: View {
    
    let nickname: String
    let isLoading: Bool
    let errorMessage: String?
    let onStart: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            AppHeader(
                rightIconName: "icon-cancel",
                onRightTap: onStart
            )
            .padding(.horizontal, Spacing.spacing4)
            
            VStack(alignment: .leading, spacing: Spacing.spacing12) {
                Text("\(nickname) 님,\n회원가입을 완료했어요.")
                    .font(Typo.title)
                    .lineSpacing(Typo.titleLineSpacing)
                    .foregroundColor(Color.gray900)
                
                Text("오늘부터 마음에 남는 문장을 기록해보세요.")
                    .font(Typo.subTitle)
                    .foregroundColor(Color.gray600)
            }
            .padding(.horizontal, Spacing.spacing16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            if let errorMessage {
                Text(errorMessage)
                    .font(Typo.inputMessage)
                    .foregroundColor(Color.inputMessageError)
                    .padding(.horizontal, Spacing.spacing16)
                    .padding(.bottom, Spacing.spacing8)
            }
            
            AppButton(
                title: "시작하기",
                variant: .primary,
                isDisabled: isLoading
            ) {
                onStart()
            }
            .padding(.horizontal, Spacing.spacing16)
            .padding(.bottom, Spacing.spacing16)
        }
        .background(Color.white)
        .disabled(isLoading)
    }
}
