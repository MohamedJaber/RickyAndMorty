//
//  EpisodeViewModel.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 09/04/2026.
//
import Foundation

@Observable
@MainActor
final class EpisodeViewModel {

    var episodes: [Episode] = []
    var isLoading = false
    var errorMessage: String?

    private var currentPage = 1
    private var totalPages = 1
    private var isFetchingNextPage = false

    private let network: NetworkServiceProtocol

    init(network: NetworkServiceProtocol) {
        self.network = network
    }

    func fetchEpisodes() async {
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
            let response: EpisodeResponse =
                try await network.fetch(.fetchEpisodes(page: currentPage))

            episodes.append(contentsOf: response.results)
            totalPages = response.info.pages

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadNextPage(currentEpisode: Episode) {
        guard currentEpisode.id == episodes.last?.id else { return }
        Task {
            currentPage += 1
            await fetchEpisodes()
        }
    }

    private func canLoadMore() -> Bool {
        currentPage <= totalPages
    }
}
