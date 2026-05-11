//
//  ImageService.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation
import UIKit
import Alamofire

final class ImageUploadService {
    
    static let shared = ImageUploadService()
    
    private init() {}
    
    func uploadImage(
        image: UIImage,
        fileName: String = "image.jpg"
    ) async throws -> ImageResponse {
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw APIError.requestFailed
        }
        
        return try await uploadImageData(
            imageData,
            fileName: fileName
        )
    }
    
    func uploadImageData(
        _ imageData: Data,
        fileName: String = "image.jpg"
    ) async throws -> ImageResponse {
        
        let endpoint = ImageEndpoint.upload
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(
                        imageData,
                        withName: "file",
                        fileName: fileName,
                        mimeType: "image/jpeg"
                    )
                },
                to: endpoint.url,
                method: endpoint.method,
                headers: headers
            )
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decodedResponse = try JSONDecoder().decode(
                            APIResponse<ImageResponse>.self,
                            from: data
                        )
                        
                        if decodedResponse.isSuccess {
                            guard let imageResponse = decodedResponse.data else {
                                continuation.resume(throwing: APIError.decodingFailed)
                                return
                            }
                            
                            continuation.resume(returning: imageResponse)
                        } else {
                            continuation.resume(
                                throwing: APIError.serverError(
                                    code: decodedResponse.code,
                                    message: decodedResponse.message
                                )
                            )
                        }
                    } catch {
                        continuation.resume(throwing: APIError.decodingFailed)
                    }
                    
                case .failure:
                    continuation.resume(throwing: APIError.requestFailed)
                }
            }
        }
    }
}
