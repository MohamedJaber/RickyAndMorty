//
//  EpisodeViewModelTests.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 14/04/2026.
//

import Testing
@testable import RickyAndMorty

@MainActor
@Suite("EpisodeViewModel Tests")
struct EpisodeViewModelTests {
    
    @Test("Fetch episodes success")
    func testFetchEpisodesSuccess() async {
        let mock = MockNetworkService()
        mock.result = EpisodeResponse.mock()
        
        let vm = EpisodeViewModel(network: mock)
        
        await vm.fetchEpisodes()
        
        #expect(!vm.episodes.isEmpty)
        #expect(vm.errorMessage == nil)
    }
    
    @Test("Fetch episodes failure")
    func testFetchEpisodesFailure() async {
        let mock = MockNetworkService()
        mock.error = NetworkError.custom("Error")
        
        let vm = EpisodeViewModel(network: mock)
        
        await vm.fetchEpisodes()
        
        #expect(vm.episodes.isEmpty)
        #expect(vm.errorMessage != nil)
    }
}

extension Episode {
    static func mock(
        id: Int = 1,
        characters: [String] = [
            "https://rickandmortyapi.com/api/character/1",
            "https://rickandmortyapi.com/api/character/2"
        ]
    ) -> Self {
        .init(
            id: 1, name: "Pilot", air_date: "December 2, 2013",
            episode: "S01E01",
            characters: ["https://rickandmortyapi.com/api/character/1",
                         "https://rickandmortyapi.com/api/character/2"],
            url: "", created: "")
    }
}

extension EpisodeResponse {
    static func mock(count: Int = 1) -> Self {
        .init(
            info: .init(pages: 1),
            results: (1...count).map { Episode.mock(id: $0) }
        )
    }
}
