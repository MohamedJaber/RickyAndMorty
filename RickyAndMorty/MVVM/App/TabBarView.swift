//
//  TabBarView.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 05/04/2026.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            HomeView(vm: CharactersViewModel(network: NetworkService()))
                .tabItem {
                    Image(systemName: "person")
                    Text("Characters")
                }

            LocationsListView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Locations")
                }

            EpisodesView()
                .tabItem {
                    Image(systemName: "tv")
                    Text("Episodes")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}
