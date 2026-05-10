//
//  APIResponse.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    
    let isSuccess: Bool
    
    let code: String
    
    let message: String
    
    let data: T?
}
