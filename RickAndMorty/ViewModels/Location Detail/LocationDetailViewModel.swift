//
//  LocationDetailViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 28/10/23.
//

import Foundation

class LocationRow: Hashable, Identifiable {
    let id = UUID()
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (
        lhs: LocationRow,
        rhs: LocationRow
    ) -> Bool {
        lhs.id == rhs.id
    }
}

final class LocationDetailViewModel: ObservableObject {
    enum Section: String, CaseIterable, Hashable {
        case info
        case characters
        
        var displayName: String {
            return rawValue.capitalized
        }
    }
    
    enum Row: Hashable {
        case info(LocationInfoCollectionViewCellViewModel)
        case character(CharacterCollectionViewCellViewModel)
    }
    
    struct ListItem: Identifiable {
        let id = UUID()
        
        let key: Section
        let value: Array<LocationRow>
    }
    
    var location: Location
    @Published var datasource = [ListItem]()
    
    init(location: Location) {
        self.location = location
    }
    
    func fetchCharacters() {
        var characterList: [Character] = []
        
        location.residents.forEach { urlString in
            guard let url = URL(string: urlString),
                  let urlRequest = Request(url: url) else {
                return
            }
            
            Service.shared.executeThroughCompletion(urlRequest, expecting: Character.self, completion: { [weak self] characterResult in
                guard let self = self else {
                    return
                }
                
                switch characterResult {
                case .success(let character):
                    characterList.append(character)
                    
                case .failure(let error):
                    print(error)
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    var data = [ListItem]()
                    
                    if characterList.count == location.residents.count {
                        let info: [LocationInfoCollectionViewCellViewModel] = [
                            .init(type: .name, value: location.name),
                            .init(type: .type, value: location.type),
                            .init(type: .dimension, value: location.dimension),
                            .init(type: .created, value: location.created)
                        ]
                        data.append(ListItem(key: .info, value: info))
                        
                        let characters: [CharacterCollectionViewCellViewModel] = characterList.compactMap {
                            CharacterCollectionViewCellViewModel(character: $0)
                        }
                        
                        data.append(ListItem(key: .characters, value: characters))
                        
                        datasource = data
                    }
                }
            })
        }
    }
}
