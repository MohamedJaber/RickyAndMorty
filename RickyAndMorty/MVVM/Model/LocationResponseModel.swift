//
//  LocationResponseModel.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 06/04/2026.
//

struct LocationResponse: Codable {
    let results: [Location]
    let info: Info
}

struct Info: Codable {
    let next: String?
    let pages: Int
}

struct Location: Codable, Identifiable, Equatable, Sendable {
    let residents: [String]
    let name: String
    let type: String
    let dimension: String
    let url: String
    let created: String
    let id: Int
}

struct ResidentDisplay: Identifiable, Sendable {
    let name: String
    let originName: String
    let lastSeenName: String
    let image: String
    let id: Int
}
