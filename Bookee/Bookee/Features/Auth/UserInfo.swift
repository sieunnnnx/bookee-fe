//
//  UserInfo.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

struct UserInfo: Decodable {
    
    let publicId: UUID
    
    let nickname: String
    
    let profileImgUrl: String?
}
