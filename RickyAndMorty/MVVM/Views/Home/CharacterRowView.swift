//
//  CharacterRowView.swift
//  Rick&Morty
//
//  Created by Mohamed Jaber on 25/03/2026.
//

import SwiftUI

struct CharacterRowView: View {

    let character: Character

    private var imageURL: URL? {
        URL(string: character.image)
    }

    var body: some View {
        HStack(spacing: 16) {

            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 100, height: 100)

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .shadow(radius: 10)

                case .failure:
                    Image(systemName: "person.fill")

                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 5)
            .shadow(color: .gray, radius: 10)

            Text(character.name)
                .font(.headline)
                .lineLimit(1)

            Spacer()
        }
    }
}

//#Preview(traits: .sizeThatFitsLayout) {
//    CharacterRowView(character: Character(episode: [], origin: Character.NamedResource(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"), location: Character.NamedResource(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"), name: "Beth Smith", status: "Alive", species: "Human", type: "", gender: "Female", image: "https://rickandmortyapi.com/api/character/avatar/38.jpeg", url:  "https://rickandmortyapi.com/api/character/38", created: "2017-11-05T09:48:44.230Z", id: 38))
//}
