//
//  IconButton.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import SwiftUI

struct IconButton: View {

    let iconName: String
    
    var iconSize: CGFloat = 24
    var touchSIze: CGFloat = 44
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .frame(width: touchSIze, height: touchSIze)
        }
    }
}
