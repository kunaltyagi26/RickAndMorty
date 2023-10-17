//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 15/10/23.
//

import Foundation

/// View model to handle character list view logic
final class CharacterListViewModel {
    /// Describes the event happening
    enum Event {
        case startLoading
        case stopLoading
        case refreshData
        case showError
    }
    
    typealias EventHandler = (Event) -> Void
    
    private var eventHandler: EventHandler
    
    var characters = [Character]() {
        didSet {
            cellViewModels = characters.compactMap {
                CharacterCollectionViewCellViewModel(character: $0)
            }
        }
    }
    
    var cellViewModels = [CharacterCollectionViewCellViewModel]()
    
    var apiInfo: CharactersResponse.Info?
    
    init(eventHandler: @escaping EventHandler) {
        self.eventHandler = eventHandler
        fetchCharacters()
    }
    
    var shouldShowLoadMoreIndicator: Bool {
        apiInfo?.next != nil
    }
    
    /// Fetch initial set of characters(20)
    private func fetchCharacters(
        request: Request = Request(endpoint: .character),
        isInitialFetch: Bool = true
    ) {
        Task {
            if isInitialFetch {
                eventHandler(.startLoading)
            }
            
            let result = await Service.shared.execute(
                request,
                expecting: CharactersResponse.self
            )
            
            if isInitialFetch {
                eventHandler(.stopLoading)
            }
            
            switch result {
            case .success(let characterResponse):
                if characters.isEmpty {
                    characters = characterResponse.results
                } else {
                    characters.append(contentsOf: characterResponse.results)
                }
                
                apiInfo = characterResponse.info
                eventHandler(.refreshData)
            case .failure(let error):
                print(error)
                eventHandler(.showError)
            }
        }
    }
    
    func fetchAdditionalCharacters() {
        guard let nextUrlString = apiInfo?.next,
              let nextUrl = URL(string: nextUrlString),
              let request = Request(url: nextUrl) else {
            return
        }
        
        self.fetchCharacters(request: request)
    }
}
