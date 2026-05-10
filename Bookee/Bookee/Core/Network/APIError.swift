//
//  APIError.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

enum APIError: Error, LocalizedError {
    
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingFailed
    case serverError(code: String, message: String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        
        case .invalidURL:
            return "요청 주소가 올바르지 않습니다."
            
        case .requestFailed:
            return "요청 처리에 실패했습니다."
            
        case .invalidResponse:
            return "서버 응답이 올바르지 않습니다."
            
        case .decodingFailed:
            return "응답 데이터를 처리하지 못했습니다."
        
        case .serverError(_, let message):
            return message
        
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
