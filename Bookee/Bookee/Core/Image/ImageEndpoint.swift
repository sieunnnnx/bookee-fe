//
//  ImageEndpoint.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation
import Alamofire

enum ImageEndpoint {
    
    case upload

    var path: String {
        switch self {
        case .upload:
            return "/images"
        }
    }

    var url: String {
        return AppConfig.baseURL + path
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .upload:
            return .post
        }
    }
}
