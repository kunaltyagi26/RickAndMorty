//
//  EpisodesResponse.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 20/10/23.
//

import Foundation

struct EpisodesResponse: Decodable {
    struct Info: Decodable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [Episode]
}
