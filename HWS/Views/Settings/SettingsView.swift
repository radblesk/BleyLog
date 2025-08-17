//
//  SettingsView.swift
//  HWS
//
//  Created by Radoslav Bley on 13/08/2025.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var context

    @State private var showAlert = false
    @State private var showDeleteConfirmation = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationStack {
            Form {
                NavigationLink("About") {
                    SettingsAboutView()
                }

                Section {
                    Button(
                        "Remove all user data",
                        role: .destructive
                    ) {
                        showAlert = true
                    }
                } header: {
                    Text("Data reset")
                } footer: {
                    Text(
                        "Caution! All data will be deleted and replaced with default values."
                    )
                }
            }
            .alert("Remove user data", isPresented: $showAlert) {
                Button("Remove", role: .destructive) {
                    do {
                        try context.delete(model: Course.self)
                        showDeleteConfirmation = true
                    } catch {
                        showErrorAlert = true
                        self.errorMessage = error.localizedDescription
                    }
                }
            } message: {
                Text(
                    "Are you sure? This will remove all user data and replace it with default values."
                )
            }
            .alert("", isPresented: $showDeleteConfirmation) {
                Button("OK") {
                    showDeleteConfirmation = false
                }
            } message: {
                Text("Data successfully removed. Please restart the app.")
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK") {
                    showErrorAlert = false
                }
            } message: {
                if let errorMessage {
                    Text(errorMessage)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
