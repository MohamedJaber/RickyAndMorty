//
//  EpisodeResponseModel.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 09/04/2026.
//

struct Episode: Codable, Identifiable, Hashable {
    let characters: [String]
    let name: String
    let air_date: String
    let episode: String
    let url: String
    let created: String
    let id: Int
}

struct EpisodeResponse: Codable {
    let results: [Episode]
    let info: PageInfo

    struct PageInfo: Codable {
        let pages: Int
    }
}
