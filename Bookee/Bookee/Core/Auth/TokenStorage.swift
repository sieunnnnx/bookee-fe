//
//  TokenStorage.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

final class TokenStorage {
    
    static let shared = TokenStorage()
    
    private init() {}
    
    private enum Key {
        static let accessToken = "access_token"
        static let refreshToken = "refresh_token"
    }
    
    var accessToken: String? {
        KeychainService.shared.read(key: Key.accessToken)
    }
    
    var refreshToken: String? {
        KeychainService.shared.read(key: Key.refreshToken)
    }
    
    var isLoggedIn: Bool {
        accessToken != nil && refreshToken != nil
    }
    
    func save(
        accessToken: String,
        refreshToken: String
    ) {
        KeychainService.shared.save(
            key: Key.accessToken,
            value: accessToken
        )
        
        KeychainService.shared.save(
            key: Key.refreshToken,
            value: refreshToken
        )
    }
    
    func saveAccessToken(_ accessToken: String) {
        KeychainService.shared.save(
            key: Key.accessToken,
            value: accessToken
        )
    }
    
    func clear() {
        KeychainService.shared.delete(key: Key.accessToken)
        KeychainService.shared.delete(key: Key.refreshToken)
    }
}
