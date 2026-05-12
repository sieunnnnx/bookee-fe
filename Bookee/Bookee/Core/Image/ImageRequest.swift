//
//  ImageRequest.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

struct ImageRequest {
    
    let imageData: Data
    let fileName: String
    let mimeType: String
    
    init(
        imageData: Data,
        fileName: String = "image.jpg",
        mimeType: String = "image/jpeg"
    ) {
        self.imageData = imageData
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
