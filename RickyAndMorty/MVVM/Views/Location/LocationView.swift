//
//  LocationView.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 06/04/2026.
//

import SwiftUI

struct LocationsListView: View {
    @State private var vm = LocationsViewModel(network: NetworkService())
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.locations.isEmpty && vm.isLoading {
                    ProgressView("Loading locations...")
                } else {
                    List {
                        ForEach(vm.locations) { location in
                            NavigationLink(value: location.id) {
                                LocationRow(location: location)
                            }
                            .onAppear {
                                Task {
                                    await vm.loadMoreIfNeeded(currentLocation: location)
                                }
                            }
                        }

                        if vm.isLoading && !vm.locations.isEmpty {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                    .refreshable {
                        await vm.refresh()
                    }
                }
            }
            .navigationTitle("Locations")
            .navigationDestination(for: Int.self) { locationID in
                LocationDetailsView(locationID: locationID)
            }
            .alert("Error", isPresented: .constant(vm.errorMessage != nil), presenting: vm.errorMessage) { _ in
                Button("OK") { vm.errorMessage = nil }
            } message: { error in
                Text(error)
            }
            .task {
                if vm.locations.isEmpty {
                    await vm.loadLocations()
                }
            }
            .overlay(alignment: .top) {
                if vm.errorMessage != nil {
                    Text("⚠️ Pull to refresh")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
            }
        }
    }
}

#Preview("Locations List") {
    LocationsListView()
        .preferredColorScheme(.dark)
}
