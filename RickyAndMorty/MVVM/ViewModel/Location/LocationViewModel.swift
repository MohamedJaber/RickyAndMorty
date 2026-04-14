//
//  LocationViewModel.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 06/04/2026.
//

import Foundation

@Observable
@MainActor
final class LocationsViewModel {
    var locations: [Location] = []
    var isLoading = false
    var errorMessage: String?
    var currentPage = 1
    var canLoadMore = true
    
    private let network: NetworkServiceProtocol

    init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    func loadLocations() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let response: LocationResponse = try await network.fetch(.fetchLocations(page: currentPage))

            locations.append(contentsOf: response.results)
            canLoadMore = response.info.next != nil
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func loadMoreIfNeeded(currentLocation location: Location?) async {
        guard let location = location else { return }

        if locations.last?.id == location.id && canLoadMore {
            currentPage += 1
            await loadLocations()
        }
    }

    func refresh() async {
        currentPage = 1
        locations = []
        canLoadMore = true
        await loadLocations()
    }
}
