//
//  LocationDetailsView.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 06/04/2026.
//

import SwiftUI

struct LocationDetailsView: View {
    let locationID: Int
    @State private var vm = LocationDetailViewModel(network: NetworkService())
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if vm.isLoadingLocation {
                    ProgressView("Loading location details...")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else if let location = vm.location {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(location.name)
                            .font(.largeTitle)
                            .bold()
                        
                        HStack {
                            Text("Type:")
                                .fontWeight(.semibold)
                            Text(location.type)
                        }
                        .font(.subheadline)
                        
                        HStack {
                            Text("Dimension:")
                                .fontWeight(.semibold)
                            Text(location.dimension.isEmpty ? "Unknown" : location.dimension)
                        }
                        .font(.subheadline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("RESIDENTS")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if vm.isLoadingResidents {
                            HStack {
                                Spacer()
                                ProgressView("Loading residents...")
                                Spacer()
                            }
                            .padding()
                        } else if vm.residents.isEmpty {
                            Text("No residents found for this location.")
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(vm.residents) { resident in
                                    ResidentCard(resident: resident)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                } else if let error = vm.errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("Failed to load location")
                            .font(.headline)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await vm.loadLocationDetails(id: locationID)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                    .padding()
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Location Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.loadLocationDetails(id: locationID)
        }
        .refreshable {
            await vm.loadLocationDetails(id: locationID)
        }
    }
}

#Preview {
    LocationDetailsView(locationID: 1)
}
