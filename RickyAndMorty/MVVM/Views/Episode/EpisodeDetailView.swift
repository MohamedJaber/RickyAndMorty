//
//  EpisodeDetailView.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 09/04/2026.
//

import SwiftUI

// MARK: - EpisodeDetailView

struct EpisodeDetailView: View {
    @State var viewModel: EpisodeDetailViewModel

    let episode: Episode

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    metadataSection
                        .padding(.top, 16)

                    charactersHeader

                    charactersSection
                }
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle(viewModel.episode.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.black, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task { await viewModel.loadCharacters() }
    }

    // MARK: - Metadata

    private var metadataSection: some View {
        VStack(spacing: 0) {
            Divider().background(Color(white: 0.25))

            metadataRow(icon: "tv",
                        label: "Episode",
                        value: viewModel.episode.episode)

            Divider().background(Color(white: 0.25))

            metadataRow(icon: "calendar",
                        label: "Air Date",
                        value: viewModel.episode.air_date)

            Divider().background(Color(white: 0.25))

            metadataRow(icon: "person.3",
                        label: "Characters count",
                        value: "\(viewModel.episode.characters.count)")

            Divider().background(Color(white: 0.25))
        }
        .padding(.bottom, 32)
    }

    private func metadataRow(icon: String, label: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(.cyan)
                .frame(width: 28)

            Text(label)
                .font(.system(size: 16))
                .foregroundStyle(.cyan)

            Spacer()

            Text(value)
                .font(.system(size: 16))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.black)
    }

    // MARK: - Characters header

    private var charactersHeader: some View {
        HStack {
            Text("CHARACTERS")
                .font(.system(size: 13))
                .foregroundStyle(Color(white: 0.5))
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
            Spacer()
        }
        .background(Color.black)
    }

    // MARK: - Characters section

    @ViewBuilder
    private var charactersSection: some View {
        if viewModel.isLoading {
            ProgressView()
                .tint(.cyan)
                .padding(.top, 40)
        } else if let errorMsg = viewModel.errorMessage {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 32))
                    .foregroundStyle(.cyan)
                Text(errorMsg)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)
                Button("Retry") { viewModel.retry() }
                    .foregroundStyle(.cyan)
            }
            .padding(.top, 40)
        } else {
            characterList
        }
    }

    private var characterList: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.characters.enumerated()), id: \.element.id) { index, character in
                CharacterRowEpisodeView(character: character)

                if index < viewModel.characters.count - 1 {
                    Divider()
                        .background(Color(white: 0.25))
                        .padding(.leading, 80)
                }
            }
        }
        .background(Color(white: 0.13))
        .cornerRadius(16)
    }
}

#Preview {
    let episode = Episode(
        characters: ["https://rickandmortyapi.com/api/character/1", "https://rickandmortyapi.com/api/character/2"], name: "Pilot", air_date: "December 2, 2013", episode: "S01E01", url: "", created: "", id: 1)

    EpisodeDetailView(viewModel: EpisodeDetailViewModel(episode: episode, network: NetworkService()), episode: episode)
}
