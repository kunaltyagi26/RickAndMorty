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
    
    private var cacheManager = APICacheManager()
    
    /// Privatized constructor
    private init() {}
    
    enum ServiceError: Error {
        case inavlidURL
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
        if let cachedData = cacheManager.cachedResponse(
            for: request.endpoint,
            url: request.url
        ) {
            do {
                let cachedResponse = try JSONDecoder().decode(type.self, from: cachedData)
                return .success(cachedResponse)
            } catch {
                return .failure(.decodingError)
            }
        }
        
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
            cacheManager.setCache(
                for: request.endpoint,
                url: request.url,
                data: data
            )
            return .success(response)
        } catch _ as DecodingError {
            return .failure(.decodingError)
        } catch {
            return .failure(.errorFetchingData)
        }
    }
    
    func executeThroughCompletion<T: Decodable>(
        _ request: Request,
        expecting type: T.Type,
        completion: @escaping (Result<T, ServiceError>) -> Void
    ) {
        if let cachedData = cacheManager.cachedResponse(
            for: request.endpoint,
            url: request.url
        ) {
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(result))
            }
            catch {
                completion(.failure(.decodingError))
            }
            return
        }
        
        guard let urlRequest = request.urlRequest else {
            completion(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let data = data, error == nil,
            let response = response as? HTTPURLResponse,
            200...300 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // Decode response
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(
                    for: request.endpoint,
                    url: request.url,
                    data: data
                )
                completion(.success(result))
            }
            catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}
