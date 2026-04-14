//
//  EpisodeResponseModel.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 09/04/2026.
//

struct Episode: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String 
    let characters: [String]
    let url: String
    let created: String
}

struct EpisodeResponse: Codable {
    let info: PageInfo
    let results: [Episode]

    struct PageInfo: Codable {
        let pages: Int
    }
}
