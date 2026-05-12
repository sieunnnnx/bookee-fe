//
//  TermVIew.swift
//  Bookee
//
//  Created by sieunnnx on 5/12/26.
//

import SwiftUI

struct TermView: View {
    
    @StateObject private var viewModel = TermViewModel()
    @State private var isShowingSignupCancelAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var onNext: ([TermAgreement]) -> Void = { _ in }
    
    var body: some View {
        VStack(spacing: 0) {
            AppHeader(
                rightIconName: "icon-cancel",
                onRightTap: { isShowingSignupCancelAlert = true }
            )
            .padding(.horizontal, Spacing.spacing4)
            
            VStack(alignment: .leading, spacing: Spacing.spacing32) {
                Text("서비스 이용을 위해\n이용약관 동의가 필요해요.")
                    .font(Typo.title)
                    .lineSpacing(Typo.titleLineSpacing)
                    .foregroundColor(Color.gray900)
                    .padding(.top, Spacing.spacing16)
                
                VStack(alignment: .leading, spacing: 0) {
                    allTermsRow
                    
                    Divider()
                        .background(Color.gray.opacity(0.2))
                        .padding(.top, Spacing.spacing4)
                        .padding(.bottom, Spacing.spacing6)
                    
                    if viewModel.isLoading && viewModel.terms.isEmpty {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 168)
                    } else {
                        termsList
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(Typo.inputMessage)
                            .foregroundColor(.red)
                            .padding(.top, Spacing.spacing4)
                    }
                }
            }
            .padding(.horizontal, Spacing.spacing16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            AppButton(
                title: "다음",
                variant: .tertiary,
                isDisabled: !viewModel.isAllRequiredChecked || viewModel.isLoading
            ) {
                onNext(viewModel.termAgreements)
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
        .task {
            await viewModel.fetchTerms()
        }
    }
    
    private var allTermsRow: some View {
        HStack(alignment: .center) {
            Button {
                viewModel.toggleAll()
            } label: {
                HStack(alignment: .center, spacing: Spacing.spacing8) {
                    Image(viewModel.isAllChecked ? "icon-check-selected" : "icon-check-default")
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Text("필수 약관 전체 동의")
                        .font(Typo.checkBoxLabelLarge)
                        .foregroundColor(viewModel.isAllChecked ? Color.checkboxLabelSelected : Color.checkboxLabelDefault)
                }
            }
            .buttonStyle(.plain)
            .disabled(viewModel.terms.isEmpty)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 42, alignment: .center)
    }
    
    private var termsList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(viewModel.terms) { term in
                TermList(term: term) {
                    viewModel.toggleTerm(term)
                }
            }
        }
    }
}

#Preview {
    TermView()
}
