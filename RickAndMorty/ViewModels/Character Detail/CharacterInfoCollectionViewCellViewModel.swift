//
//  CharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 18/10/23.
//

import UIKit

final class CharacterInfoCollectionViewCellViewModel {
    enum CharacterType: String {
        case status
        case gender
        case type
        case species
        case origin
        case location
        case created
        case episodeCount
        
        var displayName: String {
            switch self {
            case .status, .gender, .type, .species, .origin, .location, .created:
                return rawValue.capitalized
            case .episodeCount:
                return "Episode Count"
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemBlue
            case .gender:
                return .systemRed
            case .type:
                return .systemPurple
            case .species:
                return .green
            case .origin:
                return .systemOrange
            case .location:
                return .systemPink
            case .created:
                return .systemYellow
            case .episodeCount:
                return .systemMint
            }
        }
    }
    
    private let id = UUID()
    
    var type: CharacterType
    private var value: String
    
    var displayName: String {
        if value.isEmpty {
            return "None"
        }
        
        if type == .created {
            return value.getFormattedDate()
        }
        
        return value
    }
    
    init(type: CharacterType, value: String) {
        self.type = type
        self.value = value
    }
}

extension CharacterInfoCollectionViewCellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (
        lhs: CharacterInfoCollectionViewCellViewModel,
        rhs: CharacterInfoCollectionViewCellViewModel
    ) -> Bool {
        lhs.id == rhs.id
    }
}
