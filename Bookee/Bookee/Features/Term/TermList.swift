//
//  TermList.swift
//  Bookee
//
//  Created by sieunnnx on 5/12/26.
//

import SwiftUI

struct TermList: View {
    
    let term: TermItem
    let onToggle: () -> Void
    var onMoreTap: () -> Void = {}
    
    var body: some View {
        HStack(alignment: .center) {
            Button(action: onToggle) {
                HStack(alignment: .center, spacing: Spacing.spacing8) {
                    Image(term.isChecked ? "icon-check-selected" : "icon-check-default")
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Text("\(term.required ? "(필수)" : "(선택)") \(term.title)")
                        .font(Typo.checkBoxLabelMedium)
                        .foregroundColor(term.isChecked ? Color.checkboxLabelSelected : Color.checkboxLabelDefault)
                }
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Button(action: onMoreTap) {
                Image("icon-more")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, minHeight: 42, alignment: .center)
    }
}
