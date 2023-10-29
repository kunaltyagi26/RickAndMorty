//
//  LocationsResponse.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 28/10/23.
//

import Foundation

struct LocationsResponse: Decodable {
    struct Info: Decodable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [Location]
}
