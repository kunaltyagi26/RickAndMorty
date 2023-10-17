//
//  CharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 15/10/23.
//

import Foundation

/// View model to handle character detail view logic
final class CharacterDetailViewModel {
    private let character: Character
    
    init(character: Character) {
        self.character = character
    }
    
    var title: String {
        return character.name.uppercased()
    }
}

