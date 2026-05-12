//
//  TermItem.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

struct TermItem: Identifiable {
    
    let termId: Int
    
    let title: String
    
    let required: Bool
    
    var isChecked: Bool = false
    
    
    var id: Int {
        termId
    }
}
