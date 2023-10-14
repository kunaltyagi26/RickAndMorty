//
//  Character.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 14/10/23.
//

import Foundation

struct Character: Decodable {
    let id: Int
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
}

struct Object: Decodable {
    let name: String
    let url: String
}

enum CharacterStatus: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

enum CharacterGender: String, Decodable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}
