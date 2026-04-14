//
//  MockNetworkService.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 14/04/2026.
//

@testable import RickyAndMorty
import Testing

final class MockNetworkService: NetworkServiceProtocol {
    
    var result: Any?
    var error: Error?
    
    private(set) var fetchCallCount = 0

    func fetch<T>(_ endpoint: NetworkEndpoint) async throws -> T where T : Decodable {
        fetchCallCount += 1
        
        if let error {
            throw error
        }
        
        guard let result = result as? T else {
            fatalError("Mock result not set correctly")
        }
        
        return result
    }
}
