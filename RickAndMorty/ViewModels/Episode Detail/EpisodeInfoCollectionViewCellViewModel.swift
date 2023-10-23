//
//  EpisodeInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 23/10/23.
//

import UIKit

final class EpisodeInfoCollectionViewCellViewModel {
    enum EpisodeType: String {
        case name
        case airDate
        case episode
        case created
        
        var displayName: String {
            return rawValue.capitalized
        }
        
        var tintColor: UIColor {
            switch self {
            case .name:
                return .systemBlue
                
            case .airDate:
                return .systemRed
                
            case .episode:
                return .systemPurple
                
            case .created:
                return .green
            }
        }
    }
    
    private let id = UUID()
    
    var type: EpisodeType
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
    
    init(type: EpisodeType, value: String) {
        self.type = type
        self.value = value
    }
}

extension EpisodeInfoCollectionViewCellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (
        lhs: EpisodeInfoCollectionViewCellViewModel,
        rhs: EpisodeInfoCollectionViewCellViewModel)
    -> Bool {
        lhs.id == rhs.id
    }
}
