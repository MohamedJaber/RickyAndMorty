//
//  LocationDetailViewModelTests.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 14/04/2026.
//

import Testing
@testable import RickyAndMorty

@MainActor
@Suite("LocationDetailViewModel Tests")
struct LocationDetailViewModelTests {
    
    @Test("Load location details success")
    func testLoadLocationDetails() async {
        let mock = MockNetworkService()
        
        mock.result = Location.mock()
        
        let vm = LocationDetailViewModel(network: mock)
        
        await vm.loadLocationDetails(id: 1)
        
        #expect(vm.location != nil)
        #expect(vm.errorMessage == nil)
    }
}
