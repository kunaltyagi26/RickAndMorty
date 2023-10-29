//
//  LocationCellViewModell.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 28/10/23.
//

import Foundation

final class LocationCellViewModel: Identifiable {
    let id = UUID()
    private var location: Location
    
    init(location: Location) {
        self.location = location
    }
    
    var name: String {
        return location.name
    }
    
    var type: String {
        return "Type: \(location.type)"
    }
    
    var dimension: String {
        return "Dimension: \(location.dimension)"
    }
}
