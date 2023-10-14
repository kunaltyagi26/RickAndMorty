//
//  Request.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 14/10/23.
//

import Foundation

/// Object that represents a single API call
final class Request {
    // MARK: - Constants
    private struct Constants {
        static let baseURL = "https://rickandmortyapi.com/api"
    }
    
    /// Desired endpoint
    private let endpoint: Endpoint
    
    /// Path components for API, if any
    private let pathComponents: [String]
    
    /// Query parameters for API, if any
    private let queryParamters: [URLQueryItem]
    
    /// Constructed url for the api request in string request
    private var urlString: String {
        var urlString = Constants.baseURL + "/" + endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach { urlString += "/\($0)" }
        }
        
        if !queryParamters.isEmpty {
            urlString += "?"
            
            let arguementString = queryParamters.compactMap {
                guard let value = $0.value else {
                    return ""
                }
                return "\($0.name)=\(value)"
            }.joined(separator: "&")
            
            urlString += arguementString
        }
        
        return urlString
    }
    
    /// Computed and constructed API url
    private var url: URL? {
        URL(string: urlString)
    }
    
    /// Desired http method
    let httpMethod = "GET"
    
    /// Computed and constructed API urlRequest
    var urlRequest: URLRequest? {
        guard let url = url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        
        return urlRequest
    }
    
    /// Constructs request
    /// - Parameters:
    ///   - endpoint: target endpoint
    ///   - pathComponents: collection of path components
    ///   - queryParamters: colllection of query parameters
    init(
        endpoint: Endpoint,
        pathComponents: [String] = [],
        queryParamters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParamters = queryParamters
    }
}
