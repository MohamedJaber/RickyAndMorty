//
//  CharacterDetailsView.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 05/04/2026.
//


import SwiftUI

struct CharacterDetailsView: View {

    let character: Character

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                AsyncImage(url: URL(string: character.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()

                    case .failure:
                        Color.gray.opacity(0.2)

                    default:
                        ProgressView()
                    }
                }
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .shadow(color: .gray, radius: 10)
                .padding(.top, 20)

                Text(character.name)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                Divider()
                    .padding(.horizontal)
                    .background(.gray)

                VStack(spacing: 16) {
                    InfoRow(title: "Gender", value: character.gender)
                    InfoRow(title: "Species", value: character.species)
                    InfoRow(title: "Status", value: character.status)
                    InfoRow(title: "Origin", value: character.origin.name)
                    InfoRow(title: "Location", value: character.location.name)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)

    }
}
struct InfoRow: View {

    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.cyan)

            Spacer()

            Text(value)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    CharacterDetailsView(character: Character(id: 38, name: "Beth Smith", status: "Alive", species: "Human", type: "", gender: "Female", origin: Character.NamedResource(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"), location: Character.NamedResource(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"), image: "https://rickandmortyapi.com/api/character/avatar/38.jpeg", episode: [], url:  "https://rickandmortyapi.com/api/character/38", created: "2017-11-05T09:48:44.230Z"))
}
