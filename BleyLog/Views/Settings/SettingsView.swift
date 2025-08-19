//
//  SettingsView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 13/08/2025.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    // Model Context
    @Environment(\.modelContext) private var context

    // States
    @State private var showAlert = false
    @State private var showDeleteConfirmation = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String? = nil

    // Bindings
    @Binding var presented: Bool

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                List {
                    Section {
                        Button(
                            "Reset all data",
                            systemImage: "trash",
                            role: .destructive
                        ) {
                            showAlert = true
                        }
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        #if os(iOS)
                            .background(
                                Color(.secondarySystemGroupedBackground)
                                    .opacity(
                                        0.5
                                    )
                            )
                        #endif
                        .clipShape(.capsule)
                    } header: {
                        Text("Data reset")
                    } footer: {
                        Text(
                            "Caution! This will erase all data and replace them with default ones. App restart is required."
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                    }
                    .listRowBackground(.some(Color.clear))
                    #if os(iOS)
                        .listRowSeparator(.hidden)
                    #endif
                    HStack {
                        VStack {
                            Text(
                                "Developed by [Radoslav Bley](https://www.radobley.sk)"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)

                            Text(
                                "v0.3.0 2025819.1"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(.some(Color.clear))
                    #if os(iOS)
                        .listRowSeparator(.hidden)
                    #endif
                }
                .listStyle(.plain)

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
            .toolbar {
                ToolbarItem {
                    if #available(iOS 26.0, watchOS 26, macOS 26, *) {
                        Button("Close", systemImage: "xmark", role: .close) {
                            presented = false
                        }
                    } else {
                        Button("Close", systemImage: "xmark") {
                            presented = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView(presented: .constant(true))
}
