//
//  ButtonMetrics.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import SwiftUI

enum ButtonMetrics {
    case large
    case medium
    case small
    
    var height: CGFloat {
        switch self {
        
        case .large:
            return 56
        
        case .medium:
            return 56
        
        case .small:
            return 56
        }
    }
    
    var font: Font {
        switch self {
        
        case .large:
            return Typo.largeButtonText
        
        case .medium:
            return Typo.largeButtonText
        
        case .small:
            return Typo.largeButtonText
        }
    }
    
    var iconSize: CGFloat {
        switch self {
        
        case .large:
            return 24
        
        case .medium:
            return 24
        
        case .small:
            return 24
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        
        case .large:
            return Radius.radius12
        
        case .medium:
            return Radius.radius12
        
        case .small:
            return Radius.radius12
        }
    }
}
