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
            ZStack {
                HStack {
                    Image(variant.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: metric.iconSize, height: metric.iconSize)
                    
                    Spacer()
                }
                .padding(.leading, Spacing.spacing24)
                .padding(.trailing, Spacing.spacing24)
                
                Text(variant.title)
                    .font(metric.font)
                    .foregroundColor(variant.foregroundColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: metric.height)
            .background(variant.backgroundColor)
            .cornerRadius(metric.cornerRadius)
        }
    }
}
