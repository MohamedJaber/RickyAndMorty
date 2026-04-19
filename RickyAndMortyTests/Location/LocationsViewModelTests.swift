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
            residents: residents,
            name: "Ricky",
            type: "Earth",
            dimension: "Planet",
            url: "https://rickandmortyapi.com/api/character/1",
            created: "",
            id: 1
        )
    }
}

extension LocationResponse {
    static func mock(count: Int = 1, hasNext: Bool = false) -> Self {
        .init(
            results: (1...count).map { Location.mock(id: $0) },
            info: .init(
                next: hasNext ? "next-page-url" : nil, pages: 1,
            )
        )
    }
}
