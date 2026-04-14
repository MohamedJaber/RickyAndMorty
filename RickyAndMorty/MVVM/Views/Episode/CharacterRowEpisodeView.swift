//
//  CharacterRowEpisodeView.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 14/04/2026.
//

import SwiftUI

struct CharacterRowEpisodeView: View {
    let character: Character
    
    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: character.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure, .empty:
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color(white: 0.45))
                @unknown default:
                    Color(white: 0.25)
                }
            }
            .frame(width: 54, height: 54)
            .clipShape(Circle())
            .shadow(color: .gray, radius: 10)

            Text(character.name)
                .font(.system(size: 17))
                .foregroundStyle(.cyan)

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("Been in \(character.episode.count) episodes")
                    .font(.system(size: 13))
                    .foregroundStyle(.white)

                Rectangle()
                    .frame(width: 130, height: 0.5)
                    .foregroundStyle(Color(white: 0.35))

                Text("Current status \(character.status)")
                    .font(.system(size: 13))
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(white: 0.13))
    }
}
