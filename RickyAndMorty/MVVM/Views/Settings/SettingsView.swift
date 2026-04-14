//
//  SettingsView.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 14/04/2026.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    SettingsRow(
                        icon: "star.fill",
                        iconColor: .blue,
                        title: "Rate App"
                    ) {
                        requestReview()
                    }

                    SettingsRow(
                        icon: "paperplane.fill",
                        iconColor: .green,
                        title: "Contact Us"
                    ) {
                        openMail()
                    }

                    SettingsRow(
                        icon: "list.clipboard.fill",
                        iconColor: .red,
                        title: "API Reference"
                    ) {
                        openURL("https://rickandmortyapi.com/documentation")
                    }

                    SettingsRow(
                        icon: "play.rectangle.fill",
                        iconColor: .purple,
                        title: "View Video Series"
                    ) {
                        openURL("https://www.adultswim.com/videos/rick-and-morty")
                    }

                    SettingsRow(
                        icon: "hammer.fill",
                        iconColor: Color(red: 0.95, green: 0.27, blue: 0.27),
                        title: "View App Code"
                    ) {
                        openURL("https://github.com/MohamedJaber/RickyAndMorty")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }

    // MARK: - Actions

    @Environment(\.requestReview) private var requestReview

    private func openMail() {
        let email = "mohamedjaber662@gmail.com"
        let subject = "App Feedback"
        let urlString = "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Settings Row

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Icon badge
                ZStack {
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .fill(iconColor)
                        .frame(width: 36, height: 36)

                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                }

                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}
