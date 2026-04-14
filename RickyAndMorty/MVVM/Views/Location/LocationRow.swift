//
//  LocationRow.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 14/04/2026.
//

import SwiftUI

struct LocationRow: View {
    let location: Location
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(location.name)
                .font(.headline)
                .foregroundStyle(.cyan)
            Text(location.type)
                .font(.subheadline)
                .foregroundStyle(.white)
            Text("Dimension: \(location.dimension.isEmpty ? "Unknown" : location.dimension)")
                .font(.caption)
                .foregroundStyle(.white)
        }
        .padding(.vertical, 4)
    }
}
