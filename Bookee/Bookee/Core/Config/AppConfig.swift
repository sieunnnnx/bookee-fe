//
//  AppConfig.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

enum AppConfig {
    static let baseURL = "http://localhost:8080/api/v1"
    
    static var kakaoNativeAppKey: String {
        guard let key = Bundle.main.object(
            forInfoDictionaryKey: "Default Native AppKey"
        ) as? String else {
            fatalError("KAKAO_NATIVE_APP_KEY가 설정되지 않았습니다.")
        }
        
        return key
    }
}
