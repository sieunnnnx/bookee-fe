//
//  PageIndicator.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import SwiftUI

struct PageIndicator: View {
    
    let currentPage: Int
    let totalCount: Int
    
    var body: some View {
        HStack(spacing: Spacing.spacing6) {
            ForEach(0..<totalCount, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? Color.slideDotActive : Color.slideDotDefault)
                    .frame(
                        width: index == currentPage ? 24 : 8,
                        height: 8
                    )
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
            }
        }
    }
}
