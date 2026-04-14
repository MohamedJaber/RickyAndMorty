//
//  CharactersViewModel.swift
//  Rick&Morty
//
//  Created by Mohamed Jaber on 29/03/2026.
//

import Foundation

@Observable
@MainActor
final class CharactersViewModel {

    var characters: [Character] = []
    var isLoading = false
    var errorMessage: String?

    private var currentPage = 1
    private var totalPages = 1
    private var isFetchingNextPage = false

    private let network: NetworkServiceProtocol

    init(network: NetworkServiceProtocol) {
        self.network = network
    }

    func fetchCharacters() async {
        guard !isLoading,
              !isFetchingNextPage,
              canLoadMore()
        else { return }

        isLoading = true
        isFetchingNextPage = true

        defer {
            isLoading = false
            isFetchingNextPage = false
        }

        do {
            let response: CharacterResponse =
                try await network.fetch(.characters(page: currentPage))

            characters.append(contentsOf: response.results)
            totalPages = response.info.pages

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadNextPage(currentCharacter: Character) {
        guard currentCharacter.id == characters.last?.id else { return }

        Task {
            currentPage += 1
            await fetchCharacters()
        }
    }

    func canLoadMore() -> Bool {
        currentPage <= totalPages
    }
}
