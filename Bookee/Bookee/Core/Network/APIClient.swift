//
//  APIClient.swift
//  Bookee
//
//  Created by sieunnnx on 5/10/26.
//

import Foundation

final class APIClient {
    
    static let shared = APIClient()
    
    private init() {}
    
    func reaquest<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type,
    ) async throws -> T {
        
        let request = try makeURLRequest(endpoint: endpoint)
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw APIError.requestFailed
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...599).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
            
            if decodedResponse.isSuccess {
                guard let responseData = decodedResponse.data else {
                    throw APIError.decodingFailed
                }
                
                return responseData
            }
            
            throw APIError.serverError(
                code: decodedResponse.code,
                message: decodedResponse.message
            )
            
        } catch let apiError as APIError {
            throw apiError
            
        } catch {
            throw APIError.decodingFailed
        }
    }
    
    private func makeURLRequest(endpoint: APIEndpoint) throws -> URLRequest {
        var components = URLComponents(string: AppConfig.baseURL + endpoint.path)
        
        if let queryItems = endpoint.queryItems {
            components?.queryItems = queryItems
        }
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if endpoint.requiresAuth,
           let accessToken = TokenStorage.shared.accessToken {
            request.setValue(
                "Bearer \(accessToken)",
                forHTTPHeaderField: "Authorization"
            )
        }
        
        return request
    }
}
