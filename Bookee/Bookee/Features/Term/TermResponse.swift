//
//  TermResponse.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

struct TermResponse: Decodable {
    
    let termId: Int
    
    let title: String
    
    let required: Bool
}
