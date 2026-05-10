//
//  SocialLoginButton.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import SwiftUI

struct SocialLoginButton: View {
    
    let variant: SocialLoginButtonVariant
    
    var metric: ButtonMetrics = .large
    
    let action: () -> Void
    
    var body: some View {
        SwiftUI.Button {
            action()
        } label:  {
            HStack(spacing: Spacing.spacing8) {
                Image(variant.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(variant.title)
                    .font(metric.font)
                    .foregroundColor(variant.foregroundColor)
            }
            .padding(.leading, Spacing.spacing24)
            .padding(.trailing, Spacing.spacing32)
            .frame(maxWidth: .infinity)
            .frame(height: metric.height)
            .background(variant.backgroundColor)
            .cornerRadius(metric.cornerRadius)
        }
    }
}
