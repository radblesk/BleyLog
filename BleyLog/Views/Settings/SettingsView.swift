//
//  SettingsView.swift
//  BleyLog
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
            ZStack(alignment: .bottom) {
                Form {
                    Section {
                        Button(
                            "Reset all data",
                            role: .destructive
                        ) {
                            showAlert = true
                        }
                    } header: {
                        Text("Data reset")
                    } footer: {
                        Text(
                            "Caution! All data will be deleted and replaced with default values. App restart is required."
                        )
                    }
                }
                #if os(iOS)
                    .listStyle(.insetGrouped)
                #endif

                VStack {
                    Text(
                        "Developed by [Radoslav Bley](https://www.radobley.sk)"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Text(
                        "v0.2.0 2025819.1"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding()
            }
            .alert("Remove user data", isPresented: $showAlert) {
                Button("Remove", role: .destructive) {
                    do {
                        try context.delete(model: Language.self)
                        try context.delete(model: Course.self)
                        try context.delete(model: Lesson.self)
                        try context.delete(model: Project.self)
                        try context.save()
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
            #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
                .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

#Preview {
    SettingsView()
}
