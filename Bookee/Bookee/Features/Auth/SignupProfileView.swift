//
//  SignupProfileView.swift
//  Bookee
//
//  Created by Codex on 5/12/26.
//

import SwiftUI
import Photos
import PhotosUI
import UIKit

struct SignupProfileView: View {
    
    @ObservedObject var viewModel: SignupViewModel
    @Environment(\.dismiss) private var dismiss
    
    let onBack: () -> Void
    let onNext: () -> Void
    
    @State private var nickname = ""
    @State private var selectedBirthday: Date?
    @State private var isShowingBirthdayPicker = false
    @State private var isShowingSignupCancelAlert = false
    @State private var isShowingPhotoPicker = false
    @State private var isShowingPhotoPermissionAlert = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var profileImage: UIImage?
    @State private var profileImageUrl: String?
    @State private var nicknameMessage: String?
    
    private var birthdayText: String {
        Self.birthdayFormatter.string(from: selectedBirthday ?? Self.defaultBirthday)
    }
    
    private var isBirthdaySelected: Bool {
        selectedBirthday != nil
    }
    
    private var isNicknameValid: Bool {
        Self.isValidNickname(nickname)
    }
    
    private var canGoNext: Bool {
        isNicknameValid && isBirthdaySelected
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
                Text("서비스를 이용하기 전\n프로필을 설정할 수 있어요.")
                    .font(Typo.title)
                    .lineSpacing(Typo.titleLineSpacing)
                    .foregroundColor(Color.gray900)
                    .padding(.top, Spacing.spacing16)
                
                profileImageButton
                
                VStack(alignment: .leading, spacing: Spacing.spacing24) {
                    TextInput(
                        title: "닉네임",
                        placeholder: "2글자 이상",
                        text: $nickname,
                        message: nicknameMessage,
                        maxLength: 10
                    )
                    
                    DateInput(
                        title: "생년월일",
                        value: birthdayText,
                        isSelected: isBirthdaySelected
                    ) {
                        isShowingBirthdayPicker = true
                    }
                }
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
                isDisabled: !canGoNext || viewModel.isLoading
            ) {
                submitProfile()
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
        .onChange(of: nickname) { _, newValue in
            nicknameMessage = Self.nicknameValidationMessage(newValue)
        }
        .sheet(isPresented: $isShowingBirthdayPicker) {
            birthdayPickerSheet
        }
        .photosPicker(
            isPresented: $isShowingPhotoPicker,
            selection: $selectedPhotoItem,
            matching: .images
        )
        .onChange(of: selectedPhotoItem) { _, newValue in
            guard let newValue else { return }
            loadProfileImage(from: newValue)
        }
        .alert("사진 사용에 대한 접근 권한이 없습니다.", isPresented: $isShowingPhotoPermissionAlert) {
            Button("설정으로 이동하기") {
                openAppSettings()
            }
            
            Button("취소", role: .cancel) {}
        } message: {
            Text("설정 > Bookee 탭에서 접근을 활성화 할 수 있어요.")
        }
    }
    
    private var profileImageButton: some View {
        Button {
            handleProfileImageTap()
        } label: {
            ZStack(alignment: .bottomTrailing) {
                Group {
                    if let profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Circle()
                            .fill(Color.gray300)
                    }
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                
                Image("icon-add-image")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
    
    private func handleProfileImageTap() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .notDetermined:
            Task {
                let newStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
                await MainActor.run {
                    handlePhotoAuthorizationStatus(newStatus)
                }
            }
            
        case .authorized, .limited:
            isShowingPhotoPicker = true
            
        case .denied, .restricted:
            isShowingPhotoPermissionAlert = true
            
        @unknown default:
            isShowingPhotoPermissionAlert = true
        }
    }
    
    private func handlePhotoAuthorizationStatus(_ status: PHAuthorizationStatus) {
        switch status {
        case .authorized, .limited:
            isShowingPhotoPicker = true
            
        case .denied, .restricted, .notDetermined:
            isShowingPhotoPermissionAlert = true
            
        @unknown default:
            isShowingPhotoPermissionAlert = true
        }
    }
    
    private func loadProfileImage(from item: PhotosPickerItem) {
        Task {
            do {
                guard let data = try await item.loadTransferable(type: Data.self),
                      let image = UIImage(data: data) else {
                    return
                }
                
                profileImage = image
                
                let response = try await ImageUploadService.shared.uploadImage(image: image)
                profileImageUrl = response.imageUrl
                
            } catch {
                viewModel.errorMessage = (error as? LocalizedError)?.errorDescription
                    ?? error.localizedDescription
            }
        }
    }
    
    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    private var birthdayPickerSheet: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()

                Button("완료") {
                    isShowingBirthdayPicker = false
                }
                .padding(.horizontal, Spacing.spacing16)
                .padding(.top, Spacing.spacing12)
            }

            DatePicker(
                "생년월일",
                selection: Binding(
                    get: { selectedBirthday ?? Self.defaultBirthday },
                    set: { selectedBirthday = $0 }
                ),
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .environment(\.locale, Locale(identifier: "ko_KR"))
            .frame(maxWidth: .infinity)
            .padding(.horizontal, Spacing.spacing16)
            .padding(.bottom, Spacing.spacing16)
        }
        .presentationDetents([.height(300)])
        .presentationDragIndicator(.visible)
    }
    
    private func submitProfile() {
        guard isNicknameValid else {
            nicknameMessage = Self.nicknameValidationMessage(nickname)
            return
        }
        
        guard let selectedBirthday else {
            return
        }
        
        viewModel.updateProfile(
            nickname: nickname,
            profileImgUrl: profileImageUrl,
            birthday: Self.birthdayFormatter.string(from: selectedBirthday)
        )
        
        onNext()
    }
    
    private var nicknameLineColor: Color {
        if nicknameMessage != nil {
            return Color.inputLineError
        }
        
        return nickname.isEmpty ? Color.inputLineDefault : Color.inputLineActive
    }
    
    private var birthdayInputColor: Color {
        isBirthdaySelected ? Color.inputTextActive : Color.inputPlaceholderDefault
    }
    
    private static let defaultBirthday = Date(timeIntervalSince1970: 631152000)
    
    private static let birthdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    private static func isValidNickname(_ nickname: String) -> Bool {
        nicknameValidationMessage(nickname) == nil
    }
    
    private static func nicknameValidationMessage(_ nickname: String) -> String? {
        guard (2...10).contains(nickname.count) else {
            return "닉네임은 2~10자로 입력해주세요."
        }
        
        guard nickname == nickname.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return "닉네임에는 공백을 사용할 수 없어요."
        }
        
        let koreanJamoPattern = "[ㄱ-ㅎㅏ-ㅣ]"
        if nickname.range(of: koreanJamoPattern, options: .regularExpression) != nil {
            return "한글 자음이나 모음만 사용할 수 없어요."
        }
        
        let pattern = "^[가-힣a-zA-Z0-9ぁ-んァ-ン]+$"
        guard nickname.range(of: pattern, options: .regularExpression) != nil else {
            return "한글, 영문, 숫자, 일본어만 사용할 수 있어요."
        }
        
        return nil
    }
}
