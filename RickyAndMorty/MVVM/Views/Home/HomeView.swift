//
//  HomeView.swift
//  Rick&Morty
//
//  Created by Mohamed Jaber on 25/03/2026.
//

import SwiftUI

fileprivate enum CharactersRoute: Hashable {
    case characterDetails(Character)
}

struct HomeView: View {

    @State private var vm: CharactersViewModel
    @State private var path: [CharactersRoute] = []

    init(vm: CharactersViewModel) {
        _vm = State(initialValue: vm)
    }

    var body: some View {
        NavigationStack(path: $path) {
            List(vm.characters) { character in
                CharacterRowView(character: character)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        path.append(.characterDetails(character))
                    }
                    .onAppear {
                        vm.loadNextPage(currentCharacter: character)
                    }
            }
            .navigationTitle("Characters")

            .navigationDestination(for: CharactersRoute.self) { route in
                switch route {
                case .characterDetails(let character):
                    CharacterDetailsView(character: character)
                }
            }

            .task {
                if vm.characters.isEmpty {
                    await vm.fetchCharacters()
                }
            }

            .overlay(alignment: .bottom) {
                if vm.isLoading {
                    ProgressView().padding()
                }
            }
        }
    }
}
#Preview {
    HomeView(vm: CharactersViewModel(network: NetworkService()))
        .preferredColorScheme(.dark)
}
