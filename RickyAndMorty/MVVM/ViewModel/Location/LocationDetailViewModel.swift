//
//  LocationDetailViewModel.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 06/04/2026.
//

import Foundation

@Observable
@MainActor
final class LocationDetailViewModel {
    var location: Location?
    var residents: [ResidentDisplay] = []
    var isLoadingLocation = true
    var isLoadingResidents = false
    var errorMessage: String?

    private let network: NetworkServiceProtocol

    init(network: NetworkServiceProtocol) {
        self.network = network
    }

    func loadLocationDetails(id: Int) async {
        isLoadingLocation = true
        errorMessage = nil

        do {
            let fetchedLocation: Location = try await network.fetch(.fetchLocation(id: id))
            location = fetchedLocation
            isLoadingLocation = false
            await loadResidents(for: fetchedLocation.residents)
        } catch {
            errorMessage = error.localizedDescription
            isLoadingLocation = false
        }
    }

    private func loadResidents(for residentURLs: [String]) async {
        guard !residentURLs.isEmpty else { return }

        isLoadingResidents = true
        defer { isLoadingResidents = false }

        let loadedResidents: [ResidentDisplay] =
            await withTaskGroup(of: ResidentDisplay?.self) { group in

                for url in residentURLs {
                    group.addTask { [weak self] in
                        guard let self else { return nil }
                        do {
                            let character: Character = try await self.network.fetch(.fetchCharacter(urlString: url))

                            return ResidentDisplay(
                                id: character.id,
                                name: character.name,
                                originName: character.origin.name.isEmpty ? "Unknown" : character.origin.name,
                                lastSeenName: character.location.name.isEmpty ? "Unknown" : character.location.name,
                                image: character.image
                            )
                        } catch {
                            debugPrint("Failed to load resident at \(url): \(error)")
                            return nil
                        }
                    }
                }

                var results: [ResidentDisplay] = []
                for await resident in group {
                    if let resident { results.append(resident) }
                }
                return results
            }

        residents = loadedResidents.sorted { $0.id < $1.id }
    }
}
