//
//  CharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 15/10/23.
//

import Foundation
import UIKit

/// View model to handle character cell view logic
final class CharacterCollectionViewCellViewModel: LocationRow {
    var characterName: String?
    var characterStatus: String?
    var characterImageURL: String?
    
    init(character: Character) {
        characterName = character.name
        characterStatus = "Status: \(character.status.text)"
        characterImageURL = character.image
    }
    
    func fetchImage() async -> Result<UIImage,Service.ServiceError> {
        guard let characterImageURL = characterImageURL else {
            return .failure(.inavlidURL)
        }
        
        return await ImageManager.shared.loadImageUsingCache(withURLString: characterImageURL)
    }
}
