//
//  LocationView.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 06/04/2026.
//

import SwiftUI

fileprivate enum LocationsRoute: Hashable {
    case LocationDetails(Int)
}

struct LocationsListView: View {
    @State private var vm = LocationsViewModel(network: NetworkService())
    @State private var path: [LocationsRoute] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if vm.locations.isEmpty && vm.isLoading {
                    ProgressView("Loading locations...")
                } else {
                    List {
                        ForEach(vm.locations) { location in
                            LocationRow(location: location)
                                .onTapGesture {
                                    path.append(.LocationDetails(location.id))
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
            .navigationDestination(for: LocationsRoute.self) { route in
                switch route {
                case .LocationDetails(let locationID):
                    LocationDetailsView(locationID: locationID)
                }
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
