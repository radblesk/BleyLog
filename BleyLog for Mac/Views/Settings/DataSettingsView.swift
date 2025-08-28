//
//  DataSettingsView.swift
//  BleyLog for Mac
//
//  Created by Radoslav Bley on 20/08/2025.
//

import SwiftData
import SwiftUI

struct DataSettingsView: View {
    // Model Context
    @Environment(\.modelContext) private var context

    // States
    @State private var showAlert = false
    @State private var showDeleteConfirmation = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationStack {
            Form {
                Button(
                    "Reset all data",
                    systemImage: "trash",
                    role: .destructive
                ) {
                    showAlert = true
                }
            }

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
    }
}

#Preview {
    DataSettingsView()
}
