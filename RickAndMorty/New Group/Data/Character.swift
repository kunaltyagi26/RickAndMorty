//
//  Character.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 14/10/23.
//

import Foundation

struct Character: Decodable, Hashable {
    private let uuid = UUID()
    
    var id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: CharacterGender
    let origin: Object
    let location: Object
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(uuid)
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

struct Object: Decodable, Hashable {
    let name: String
    let url: String
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(name)
    }
    
    static func == (lhs: Object, rhs: Object) -> Bool {
        lhs.name == rhs.name
    }
}

enum CharacterStatus: String, Decodable, Hashable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
            
        case .unknown:
            return "Unknown"
        }
    }
}

enum CharacterGender: String, Decodable, Hashable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
    
    var text: String {
        switch self {
        case .female, .male, .genderless:
            return rawValue
            
        case .unknown:
            return "Unknown"
        }
    }
}
