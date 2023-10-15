//
//  CharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 15/10/23.
//

import Foundation

class CharacterCollectionViewCellViewModel {
    var characterName: String?
    var characterStatus: String?
    var characterImageURL: URL?
    
    init(character: Character) {
        characterName = character.name
        characterStatus = "Status: \(character.status.text)"
        characterImageURL = URL(string: character.image)
    }
    
    func fetchImage() async -> Result<Data,Service.ServiceError> {
        guard let characterImageURL = characterImageURL else {
            return .failure(.inavlidURL)
        }
        
        do {
            let (imageData, urlResponse) = try await URLSession.shared.data(from: characterImageURL)
            guard let urlResponse = urlResponse as? HTTPURLResponse,
                  200...300 ~= urlResponse.statusCode else {
                return .failure(.invalidResponse)
            }
            return .success(imageData)
        } catch {
            return .failure(.errorFetchingData)
        }
    }
}
