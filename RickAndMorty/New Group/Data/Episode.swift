//
//  Episode.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 14/10/23.
//

import Foundation

struct Episode: Decodable {
    private let uuid = UUID()
    
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episode
        case characters
        case url
        case created
    }
}

extension Episode: Hashable {
    func hash(into hasher: inout Hasher) {
        return hasher.combine(uuid)
    }
    
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
