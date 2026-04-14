//
//  EpisodeDetailsViewModel.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 12/04/2026.
//

import Foundation

@Observable
@MainActor
final class EpisodeDetailViewModel {
    
    let episode: Episode
    
    // Published state
    private(set) var characters: [Character] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String? = nil
    private let network: NetworkServiceProtocol

    init(episode: Episode, network: NetworkServiceProtocol) {
        self.episode = episode
        self.network = network
    }
    
    // MARK: - Intents

    func loadCharacters() async {
        guard characters.isEmpty, !isLoading else { return }
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            characters = try await fetchCharacters(fromURLs: episode.characters)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func retry() {
        Task { await loadCharacters() }
    }

    func fetchCharacters(fromURLs urls: [String]) async throws -> [Character] {
        guard !urls.isEmpty else { return [] }
 
        let ids: [Int] = urls.compactMap { urlStr in
            guard let last = URL(string: urlStr)?.lastPathComponent else { return nil }
            return Int(last)
        }
 
        guard !ids.isEmpty else { return [] }
 
        var allCharacters: [Character] = []
 
        for chunk in ids.chunked(into: 20) {
            if chunk.count == 1 {
                // Single ID
                let character: Character = try await network.fetch(.fetchCharactersByIDs(ids: chunk))
                allCharacters.append(character)
            } else {
                // Multiple IDs
                let characters: [Character] = try await network.fetch(.fetchCharactersByIDs(ids: chunk))
                allCharacters.append(contentsOf: characters)
            }
        }
 
        return allCharacters
    }
}
