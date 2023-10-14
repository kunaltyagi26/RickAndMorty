//
//  Location.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 14/10/23.
//

import Foundation

struct Location: Decodable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
