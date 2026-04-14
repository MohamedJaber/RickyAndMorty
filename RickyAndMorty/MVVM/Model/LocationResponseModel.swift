//
//  LocationResponseModel.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 06/04/2026.
//

struct LocationResponse: Codable {
    let info: Info
    let results: [Location]
}

struct Info: Codable {
    let next: String?
    let pages: Int
}

struct Location: Codable, Identifiable, Equatable, Sendable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String] // URLs of character endpoints
    let url: String
    let created: String
}

struct ResidentDisplay: Identifiable, Sendable {
    let id: Int
    let name: String
    let originName: String
    let lastSeenName: String
    let image: String
}
