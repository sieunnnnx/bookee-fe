//
//  AppButton.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import SwiftUI

struct AppButton: View {
    
    let title: LocalizedStringKey
    
    var metrics: ButtonMetrics = .large
    var variant: ButtonVariant = .primary
    var isFullWidth: Bool = true
    var isDisabled: Bool = false
    
    let action: () -> Void
    
    private var buttonVariant: ButtonVariant {
        isDisabled ? .disabled : variant
    }
    
    var body: some View {
        Button {
            if !isDisabled {
                action()
            }
        } label: {
            Text(title)
                .font(metrics.font)
                .foregroundColor(buttonVariant.foregroundColor)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .frame(height: metrics.height)
                .background(buttonVariant.backgroundColor)
                .cornerRadius(metrics.cornerRadius)
        }
        .disabled(isDisabled)
    }
}
