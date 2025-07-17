//
//  SettingsView.swift
//  ExpenseTrackerApp
//
//  Created by Fenuku kekeli on 7/16/25.
//

import SwiftUI

struct SettingsView: View {
    /// Appearance
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Appearance
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $isDarkModeEnabled)
                }

                // MARK: - Social Media
                Section("Connect with Us") {
                    Link(destination: URL(string: "https://x.com/fenukukekeli?s=21&t=axe1i0ScNpywV3tKXHGQIA")!) {
                        Label("Twitter / X", systemImage: "link")
                    }
                    Link(destination: URL(string: "https://www.instagram.com/__.kelidev")!) {
                        Label("Instagram", systemImage: "camera")
                    }
                    Link(destination: URL(string: "https://www.linkedin.com/in/kekeli-fenuku-908a28250")!) {
                        Label("LinkedIn", systemImage: "person.crop.circle")
                    }
                    Link(destination: URL(string: "https://youtube.com/shorts/sFRM7acIBlQ?si=7G6ChaoXxyTEGnlf")!) {
                        Label("YouTube", systemImage: "play.rectangle.fill")
                    }
                    Link(destination: URL(string: "https://www.tiktok.com/@keli.dev?_t=ZM-8xhCJJIhG6g&_r=1")!) {
                        Label("TikTok", systemImage: "music.note")
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
    }
}

#Preview {
    SettingsView()
}
