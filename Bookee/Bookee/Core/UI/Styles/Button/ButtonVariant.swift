//
//  ButtonVariant.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import SwiftUI

enum ButtonVariant {
    
    case primary
    case secondary
    case tertiary
    case disabled
    
    var backgroundColor: Color {
        switch self {
        
        case .primary:
            return Color.buttonBgPrimary
            
        case .secondary:
            return Color.buttonBgSecondary
        
        case .tertiary:
            return Color.buttonBgTertiary
        
        case .disabled:
            return Color.buttonBgDisable
        }
    }
    
    var foregroundColor: Color {
        switch self {
            
        case .primary:
            return Color.buttonTextPrimary
            
        case .secondary:
            return Color.buttonTextSecondary
            
        case .tertiary:
            return Color.buttonTextTertiary
            
        case .disabled:
            return Color.buttonTextDisable
        }
    }
}
