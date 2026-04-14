//
//  EpisodesView.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 09/04/2026.
//

import SwiftUI

enum EpisodesRoute: Hashable {
    case episodeDetails(Episode)
}

// MARK: - EpisodesView

struct EpisodesView: View {

    @State private var path: [EpisodesRoute] = []
    @State private var vm = EpisodeViewModel(network: NetworkService())

    var body: some View {
        NavigationStack(path: $path) {
            episodeList
                .navigationDestination(for: EpisodesRoute.self) { route in
                    switch route {
                    case .episodeDetails(let episode):
                        EpisodeDetailView(viewModel: EpisodeDetailViewModel(episode: episode, network: NetworkService()), episode: episode)
                    }
                }
                .task {
                    if vm.episodes.isEmpty {
                        await vm.fetchEpisodes()
                    }
                }
        }
    }

    // MARK: - Episode list

    private var episodeList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                VStack(spacing: 0) {
                    ForEach(Array(vm.episodes.enumerated()), id: \.element.id) { index, episode in
                        episodeRow(episode, isLast: index == vm.episodes.count - 1)
                            .onAppear {
                                vm.loadNextPage(currentEpisode: episode)
                            }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 16)

                if vm.isLoading && !vm.episodes.isEmpty {
                    ProgressView()
                        .padding(.top, 16)
                }
            }
            .padding(.bottom, 16)
        }
        .navigationTitle("Episodes")
        .scrollIndicators(.hidden)
    }

    // MARK: - Episode row

    private func episodeRow(_ episode: Episode, isLast: Bool) -> some View {
        Button {
            path.append(.episodeDetails(episode))
        } label: {
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(episode.name)
                            .font(.system(size: 20, weight: .regular))
                            .foregroundStyle(.cyan)

                        Text(episode.episode)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.white)

                        Text(episode.air_date)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color(white: 0.5))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)

                if !isLast {
                    Divider()
                        .background(Color(white: 0.25))
                        .padding(.horizontal, 16)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    EpisodesView()
        .preferredColorScheme(.dark)
}
