//
//  SetPlayer.swift
//  BleyLog
//
//  Created by Radoslav Bley on 30/08/2025.
//

import SwiftUI

struct SetPlayer: View {
    @Environment(\.dismiss) var dismiss
    @Binding var playerName: String

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $playerName)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Set a new player")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                Button("Save") {
                    savePlayer()
                }
            }
            .onSubmit(savePlayer)
        }
    }

    func savePlayer() {
        dismiss()
    }
}
