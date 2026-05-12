//
//  DatePicker.swift
//  Bookee
//
//  Created by sieunnnx on 5/12/26.
//

import SwiftUI

struct DateInput: View {
    
    let title: String
    let value: String
    let isSelected: Bool
    
    let onTap: () -> Void
    
    private var textColor: Color {
        isSelected ? Color.inputTextActive : Color.inputPlaceholderDefault
    }
    
    private var lineColor: Color {
        isSelected ? Color.inputLineActive : Color.inputLineDefault
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text(title)
                .font(Typo.inputLabel)
                .foregroundColor(Color.inputLabelDefault)
                .frame(height: 18)
            
            Button(action: onTap) {
                HStack(spacing: 8) {
                    
                    Image("icon-calendar")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(textColor)
                    
                    Text(value)
                        .font(Typo.inputPlaceholder)
                        .foregroundColor(textColor)
                    
                    Spacer()
                }
                .frame(height: 44)
            }
            .buttonStyle(.plain)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(lineColor)
                    .frame(height: 1)
            }
        }
    }
}
