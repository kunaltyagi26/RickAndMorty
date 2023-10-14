//
//  Service.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 14/10/23.
//

import Foundation

/// Primary API service object to get Rick and Morty data
final class Service {
    /// Shared singleton instance
    static let shared = Service()
    
    /// Privatized constructor
    private init() {}
    
    enum ServiceError: Error {
        case invalidRequest
        case errorFetchingData
        case invalidResponse
        case decodingError
        case errorMessage(String)
    }
    
    /// Send Rick and Morty API call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The type of object we expect to get back
    ///   - completion: Callback with data or error
    func execute<T: Decodable>(
        _ request: Request,
        expecting type: T.Type
    ) async -> Result<T, ServiceError> {
        guard let urlRequest = request.urlRequest else {
            return .failure(.invalidRequest)
        }
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            guard let urlResponse = urlResponse as? HTTPURLResponse,
                  200...300 ~= urlResponse.statusCode else {
                return .failure(.invalidResponse)
            }
            let response = try JSONDecoder().decode(type.self, from: data)
            return .success(response)
        } catch _ as DecodingError {
            return .failure(.decodingError)
        } catch {
            return .failure(.errorFetchingData)
        }
    }
}
