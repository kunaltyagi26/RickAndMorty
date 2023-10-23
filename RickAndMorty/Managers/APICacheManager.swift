//
//  APICacheManager.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 20/10/23.
//

import Foundation

// Manages in memory session scoped API caches
final class APICacheManager {
    // MARK: - Variables
    private var cacheDictionary: [Endpoint: NSCache<NSString, NSData>] = [:]
    
    // MARK: - Lifecycle Methods
    init() {
        setupCache()
    }
    
    // MARK: - Private Methods
    private func setupCache() {
        Endpoint.allCases.forEach {
            cacheDictionary[$0] = NSCache<NSString, NSData>()
        }
    }
    
    // MARK: - Public Methods
    func cachedResponse(for endpoint: Endpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint],
              let urlString = url?.absoluteString as? NSString else {
            return nil
        }
        
        return targetCache.object(forKey: urlString) as? Data
    }
    
    func setCache(for endpoint: Endpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint],
              let urlString = url?.absoluteString as? NSString else {
            return
        }
        
        targetCache.setObject(NSData(data: data), forKey: urlString)
    }
}
