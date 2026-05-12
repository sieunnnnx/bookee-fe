//
//  TextInput.swift
//  Bookee
//
//  Created by sieunnnx on 5/12/26.
//

import SwiftUI

struct TextInput: View {
    
    let title: String
    let placeholder: String
    
    @Binding var text: String
    var message: String?
    
    var keyboardType: UIKeyboardType = .default
    var maxLength: Int? = nil
    
    private var lineColor: Color {
        if message != nil {
            return Color.inputLineError
        }
        return text.isEmpty ? Color.inputLineDefault : Color.inputLineActive
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text(title)
                .font(Typo.inputLabel)
                .foregroundColor(Color.inputLabelDefault)
                .frame(height: 18, alignment: .leading)
            
            ZStack(alignment: .leading) {
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(Typo.inputPlaceholder)
                        .foregroundColor(Color.inputPlaceholderDefault)
                }
                
                TextField("", text: $text)
                    .font(Typo.inputText)
                    .foregroundColor(Color.inputTextActive)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onChange(of: text) { _, newValue in
                        if let maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
            }
            .frame(height: 44)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(lineColor)
                    .frame(height: 1)
            }
            
            if let message {
                Text(message)
                    .font(Typo.inputMessage)
                    .foregroundColor(Color.inputMessageError)
                    .padding(.top, Spacing.spacing6)
            }
        }
    }
}
