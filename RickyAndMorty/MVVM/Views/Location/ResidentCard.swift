//
//  ResidentCard.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 14/04/2026.
//

import SwiftUI

struct ResidentCard: View {
    let resident: ResidentDisplay
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: resident.image), transaction: .init(animation: .default)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    
                case .failure:
                    Image(systemName: "person.fill")
                        .frame(width: 100, height: 100)
                    
                @unknown default:
                    EmptyView()
                }
            }
            .padding(.trailing, 16)
            .shadow(color: .gray, radius: 10)

            VStack(alignment: .leading, spacing: 6) {
                Text(resident.name)
                    .font(.headline)
                
                HStack {
                    Image(systemName: "birthday.cake")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Born in \(resident.originName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "eye")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Last seen in \(resident.lastSeenName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
