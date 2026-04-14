//
//  LocationsViewModelTests.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 14/04/2026.
//

import Testing
@testable import RickyAndMorty

@MainActor
@Suite("LocationsViewModel Tests")
struct LocationsViewModelTests {
    
    @Test("Load locations success")
    func testLoadLocations() async {
        let mock = MockNetworkService()
        mock.result = LocationResponse.mock()
        
        let vm = LocationsViewModel(network: mock)
        
        await vm.loadLocations()
        
        #expect(!vm.locations.isEmpty)
        #expect(vm.errorMessage == nil)
    }
    
    @Test("Refresh resets state")
    func testRefresh() async {
        let mock = MockNetworkService()
        mock.result = LocationResponse.mock()
        
        let vm = LocationsViewModel(network: mock)
        
        await vm.loadLocations()
        await vm.refresh()
        
        #expect(vm.currentPage == 1)
        #expect(!vm.locations.isEmpty)
    }
}

extension Location {
    static func mock(
        id: Int = 1,
        residents: [String] = [
            "https://rickandmortyapi.com/api/character/1"
        ]
    ) -> Self {
        .init(
            id: 1,
            name: "Ricky",
            type: "Earth",
            dimension: "Planet",
            residents: residents,
            url: "https://rickandmortyapi.com/api/character/1",
            created: ""
        )
    }
}

extension LocationResponse {
    static func mock(count: Int = 1, hasNext: Bool = false) -> Self {
        .init(
            info: .init(
                next: hasNext ? "next-page-url" : nil, pages: 1,
            ),
            results: (1...count).map { Location.mock(id: $0) }
        )
    }
}
