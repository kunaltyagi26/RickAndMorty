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
    let endpoint: Endpoint
    
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
    var url: URL? {
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
    
    /// Attempts to create request
    /// - Parameter url: url to parse
    convenience init?(url: URL) {
        let urlString = url.absoluteString
        guard urlString.contains(Constants.baseURL) else {
            return nil
        }
        
        let trimmed = urlString.replacingOccurrences(of: Constants.baseURL + "/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                var pathComponents = [String]()
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                
                if let endpoint = Endpoint(rawValue: components[0]) {
                    self.init(endpoint: endpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let queryItems: [URLQueryItem] = components[1].components(separatedBy: "&").compactMap {
                    guard $0.contains("=") else {
                        return nil
                    }
                    
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                }
                
                if let endpoint = Endpoint(rawValue: components[0]) {
                    self.init(endpoint: endpoint, queryParamters: queryItems)
                    return
                }
            }
        }
        
        return nil
    }
}
