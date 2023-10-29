//
//  LocationInfoCellViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 28/10/23.
//

import UIKit

final class LocationInfoCollectionViewCellViewModel: LocationRow {
    enum LocationType: String {
        case name
        case type
        case dimension
        case created
        
        var displayName: String {
            switch self {
            case .name:
                return "Location Name"
            case .type, .dimension, .created:
                return rawValue.capitalized
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .name:
                return .systemBlue
                
            case .type:
                return .systemRed
                
            case .dimension:
                return .systemPurple
                
            case .created:
                return .green
            }
        }
    }
    
    var type: LocationType
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
    
    init(type: LocationType, value: String) {
        self.type = type
        self.value = value
    }
}
