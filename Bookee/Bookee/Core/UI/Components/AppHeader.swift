//
//  AppHeader.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import SwiftUI

struct AppHeader: View {
    
    var title: LocalizedStringKey?
    var showsbackButton: Bool = false
    var showsCloseButton: Bool = false
    
    var onBack:(() -> Void)?
    var onClose:(() -> Void)?
    
    var body: some View {
        HStack {
            if showsbackButton {
                Button {
                    onBack?()
                } label: {
                    Image("icon-prev")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
            } else {
                Spacer()
                    .frame(width: 44, height: 44)
                    .opacity(0)
            }
            
            Spacer()
            
            if let title {
                Text(title)
                    .font(Typo.headerTitle)
                    .foregroundStyle(Color.gray900)
            }
            
            Spacer()
            
            if showsCloseButton {
                Button {
                    onClose?()
                } label: {
                    Image("icon-cancel")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
            } else {
                Spacer()
                    .frame(width: 44, height: 44)
                    .opacity(0)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
    }
}
