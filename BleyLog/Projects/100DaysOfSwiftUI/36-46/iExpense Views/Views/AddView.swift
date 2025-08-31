//
//  AddView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 26/08/2025.
//

import SwiftData
import SwiftUI

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    private var placement: ToolbarItemPlacement {
        #if os(iOS)
            .automatic
        #else
            .bottomBar
        #endif
    }

    @State private var name = "Untitled"
    @State private var type = "Personal"
    @State private var amount = 0.0

    let types = ["Business", "Personal"]
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .listRowBackground(Color.secondary.opacity(0.2))

                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                .listRowBackground(Color.secondary.opacity(0.2))

                TextField(
                    "Amount",
                    value: $amount,
                    format:
                        .currency(
                            code: Locale.current.currency?.identifier ?? "EUR"
                        )
                )
                .listRowBackground(Color.secondary.opacity(0.2))
                #if os(iOS)
                    .keyboardType(.decimalPad)
                #endif
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Add new expense")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: placement) {
                    Button("Save") {
                        let newExpense = ExpenseItem(name: name, type: type, amount: amount)

                        modelContext.insert(newExpense)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddView()
}
