//
//  CharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 18/10/23.
//

import UIKit

final class CharacterPhotoCollectionViewCellViewModel {
    private let id = UUID()
    var image = UIImage()
    
    init(characterImageUrl: String) {
        Task {
            let imageResult = await ImageManager.shared.loadImageUsingCache(withURLString: characterImageUrl)
            switch imageResult {
            case .success(let image):
                self.image = image
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension CharacterPhotoCollectionViewCellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (
        lhs: CharacterPhotoCollectionViewCellViewModel,
        rhs: CharacterPhotoCollectionViewCellViewModel)
    -> Bool {
        lhs.id == rhs.id
    }
}
