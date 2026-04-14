//
//  CharactersViewModelTests.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 14/04/2026.
//

import Testing
@testable import RickyAndMorty

@MainActor
@Suite("CharactersViewModel Tests")
struct CharactersViewModelTests {
    
    @Test("Fetch characters success")
    func testFetchCharactersSuccess() async throws {
        let mock = MockNetworkService()
        
        let expected = CharacterResponse.mock()
        mock.result = expected
        
        let vm = CharactersViewModel(network: mock)
        
        await vm.fetchCharacters()
        
        #expect(vm.characters.count == expected.results.count)
        #expect(vm.errorMessage == nil)
        #expect(vm.isLoading == false)
    }
    
    @Test("Fetch characters failure")
    func testFetchCharactersFailure() async {
        let mock = MockNetworkService()
        mock.error = NetworkError.custom("Failed")
        
        let vm = CharactersViewModel(network: mock)
        
        await vm.fetchCharacters()
        
        #expect(vm.characters.isEmpty)
        #expect(vm.errorMessage != nil)
    }
    
    @Test("Pagination triggers next page")
    func testLoadNextPage() async {
        let mock = MockNetworkService()
        let response = CharacterResponse.mock()
        mock.result = response
        
        let vm = CharactersViewModel(network: mock)
        
        await vm.fetchCharacters()
        
        let last = vm.characters.last!
        vm.loadNextPage(currentCharacter: last)

        try? await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(mock.fetchCallCount >= 1)
    }
}

extension CharacterResponse {
    static func mock() -> Self {
        .init(
            info: .init(pages: 1),
            results: [Character.mock()]
        )
    }
}

extension Character {
    static func mock(id: Int = 1) -> Self {
        .init(id: 38, name: "Beth Smith", status: "Alive", species: "Human", type: "", gender: "Female", origin: Character.NamedResource(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"), location: Character.NamedResource(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"), image: "https://rickandmortyapi.com/api/character/avatar/38.jpeg", episode: [], url:  "https://rickandmortyapi.com/api/character/38", created: "2017-11-05T09:48:44.230Z")
    }
}
