//
//  AppHeader.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import SwiftUI

struct AppHeader: View {
    
    var title: LocalizedStringKey?
    
    var leftIconName: String?
    var rightIconName: String?
    
    var onLeftTap: (() -> Void)?
    var onRightTap: (() -> Void)?
    
    var body: some View {
        HStack {
            leftArea
            
            Spacer()
            
            if let title {
                Text(title)
                    .font(Typo.headerTitle)
                    .foregroundStyle(Color.gray900)
            }
            
            Spacer()
            
            rightArea
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
    }
    
    private var leftArea: some View {
        Group {
            if let leftIconName {
                IconButton(iconName: leftIconName) {
                    onLeftTap?()
                }
            } else {
                emptyButtonSpace
            }
        }
    }
    
    private var rightArea: some View {
        Group {
            if let rightIconName {
                IconButton(iconName: rightIconName) {
                    onRightTap?()
                }
            } else {
                emptyButtonSpace
            }
        }
    }
    
    private var emptyButtonSpace: some View {
        Color.clear
            .frame(width: .infinity, height: 44)
    }
}
