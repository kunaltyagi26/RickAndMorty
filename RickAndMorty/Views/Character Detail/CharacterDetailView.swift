//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 01/11/23.
//

import Foundation
import SwiftUI

struct CharacterDetailView: UIViewControllerRepresentable {
    let character: Character
    
    func makeUIViewController(context: Context) -> CharacterDetailViewController {
        // this will work if you are not using Storyboards at all.
        return CharacterDetailViewController(character: character)
    }

    func updateUIViewController(_ uiViewController: CharacterDetailViewController, context: Context) {
        // No code required.
    }
}
