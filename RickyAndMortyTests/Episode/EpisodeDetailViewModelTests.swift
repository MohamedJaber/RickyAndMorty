//
//  EpisodeDetailViewModelTests.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 14/04/2026.
//

import Testing
@testable import RickyAndMorty

@MainActor
@Suite("EpisodeDetailViewModel Tests")
struct EpisodeDetailViewModelTests {
    
    @Test("Load characters success")
    func testLoadCharacters() async {
        let mock = MockNetworkService()
        
        let episode = Episode.mock()
        mock.result = [Character.mock(), Character.mock()]
        
        let vm = EpisodeDetailViewModel(
            episode: episode,
            network: mock
        )
        
        await vm.loadCharacters()
        
        #expect(!vm.characters.isEmpty)
        #expect(vm.errorMessage == nil)
    }
    
    @Test("Retry calls load again")
    func testRetry() async {
        let mock = MockNetworkService()
        mock.result = [Character.mock()]
        
        let vm = EpisodeDetailViewModel(
            episode: Episode.mock(),
            network: mock
        )
        
        vm.retry()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(mock.fetchCallCount > 0)
    }
}
