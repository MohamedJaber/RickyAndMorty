//
//  NetworkEndpoint.swift
//  Rick&Morty
//
//  Created by Mohamed Jaber on 29/03/2026.
//
import Foundation

enum NetworkEndpoint {
    case characters(page: Int)
    case fetchLocations(page: Int)
    case fetchLocation(id: Int)
    case fetchCharacter(urlString: String)
    case fetchEpisodes(page: Int)
    case fetchCharactersByIDs(ids: [Int])
    nonisolated var url: URL? {
        switch self {
        case .characters(let page):
            return URL(string: "https://rickandmortyapi.com/api/character?page=\(page)")
        case .fetchLocations(let page):
            return URL(string: "https://rickandmortyapi.com/api/location?page=\(page)")
        case .fetchLocation(let page):
            return URL(string: "https://rickandmortyapi.com/api/location/\(page)")
        case .fetchCharacter(let urlString):
            return URL(string: "\(urlString)")
        case .fetchEpisodes(let page):
            return URL(string: "https://rickandmortyapi.com/api/episode?page=\(page)")
        case .fetchCharactersByIDs(let ids):
            let list = ids.map(String.init).joined(separator: ",")
            return URL(string: "https://rickandmortyapi.com/api/character/\(list)")
        }
    }
}
