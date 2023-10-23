//
//  ImageManager.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 15/10/23.
//

import UIKit

struct ImageManager {
    // MARK: - Variables
    let imageCache = NSCache<NSString, UIImage>()
    static var shared = ImageManager()
    
    // MARK: - Lifecycle Methods
    private init() {}
    
    // MARK: - Public Methods
    
    /// Get image with URL
    /// - Parameter URLString: source urll
    /// - Returns: callback
    func loadImageUsingCache(withURLString URLString: String) async -> Result<UIImage, Service.ServiceError> {
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            return .success(cachedImage)
        }
        
        if let url = URL(string: URLString) {
            do {
                let (imageData, urlResponse) = try await URLSession.shared.data(from: url)
                guard let urlResponse = urlResponse as? HTTPURLResponse,
                      200...300 ~= urlResponse.statusCode else {
                    return .failure(.invalidResponse)
                }
                
                if let downloadedImage = UIImage(data: imageData) {
                    imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                    return .success(downloadedImage)
                }
            } catch {
                return .failure(.errorFetchingData)
            }
        } else {
            return .failure(.inavlidURL)
        }
        return .failure(.errorMessage("Unknown error."))
    }
}
