//
//  CharactersResponseModel.swift
//  Rick&Morty
//
//  Created by Mohamed Jaber on 25/03/2026.
//

import Foundation

struct Character: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: NamedResource
    let location: NamedResource
    let image: String
    let episode: [String]
    let url: String
    let created: String

    struct NamedResource: Codable, Equatable, Hashable {
        let name: String
        let url: String
    }
}

nonisolated extension Character: Codable {}

struct CharacterResponse: Codable {
    let info: PageInfo
    let results: [Character]

    struct PageInfo: Codable {
        let pages: Int
    }
}


