//
//  APIErrorCode.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

enum APIErrorCode: String, Decodable {
    
    case ok = "COMMON-001"
    case badRequest = "COMMON-002"
    case internalServerError = "COMMON-003"
    
    case invalidToken = "AUTH-001"
    case unsupportedProvider = "AUTH-002"
    case authFailed = "AUTH-003"
    case userInfoFetchFailed = "AUTH-004"
    case userBlocked = "AUTH-005"
    case userWithdrawn = "AUTH-006"
    case invalidAccessToken = "AUTH-007"
    case expiredAccessToken = "AUTH-008"
    case invalidRefreshToken = "AUTH-009"
    case expiredRefreshToken = "AUTH-010"
    case invalidNickname = "AUTH-011"

    case invalidFile = "IMAGE-001"
    case makeDirectoryFailed = "IMAGE-002"
    case fileUploadFailed = "IMAGE-003"
    
    case invalidTerm = "TERM-001"
    case requiredTermsNotAgreed = "TERM-002"
    
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let code = try container.decode(String.self)
        self = APIErrorCode(rawValue: code) ?? .unknown
    }
}
