//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 15/10/23.
//

import Foundation

class CharacterListViewModel {
    enum Event {
        case startLoading
        case stopLoading
        case refreshData
        case showError
    }
    
    typealias EventHandler = (Event) -> Void
    
    var eventHandler: EventHandler
    var characters = [Character]()
    
    init(eventHandler: @escaping EventHandler) {
        self.eventHandler = eventHandler
        fetchCharacters()
    }
    
    private func fetchCharacters() {
        Task {
            eventHandler(.startLoading)
            let result = await Service.shared.execute(
                Request(endpoint: .character),
                expecting: CharactersResponse.self
            )
            eventHandler(.stopLoading)
            switch result {
            case .success(let characterResponse):
                characters = characterResponse.results
                eventHandler(.refreshData)
            case .failure(let error):
                print(error)
                eventHandler(.showError)
            }
        }
    }
}
