//
//  iExpense.swift
//  BleyLog
//
//  Created by Radoslav Bley on 26/08/2025.
//

import SwiftData
import SwiftUI

struct iExpense: View {
    @Environment(\.modelContext) var modelContext
    // States
    @State private var showingAddExpense: Bool = false
    @State private var type: String = "All"
    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.name)
    ]

    var body: some View {
        ExpenseItemsView(type: type, sortOrder: sortOrder)
            .navigationTitle("iExpense")
            .toolbar {
                #if os(iOS)
                    ToolbarItem {
                        EditButton()
                    }
                    ToolbarItem {
                        Menu("Menu", systemImage: "ellipsis") {
                            Section("Sort") {
                                Picker("Sort", selection: $sortOrder) {
                                    Text("Sort by name")
                                        .tag([SortDescriptor(\ExpenseItem.name)])
                                    Text("Sort by amount")
                                        .tag([SortDescriptor(\ExpenseItem.amount)])
                                }
                            }

                            Section("Filter") {
                                Picker("Filter", selection: $type) {
                                    Text("All")
                                        .tag("All")
                                    Text("Personal")
                                        .tag("Personal")
                                    Text("Business")
                                        .tag("Business")
                                }
                            }
                        }
                    }
                    if #available(iOS 26, *) {
                        ToolbarSpacer(.flexible, placement: .bottomBar)
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button("Add Expense", systemImage: "plus") {
                            showingAddExpense = true
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                        .controlSize(.extraLarge)
                    }
                #else
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        Button("Add Expense", systemImage: "plus") {
                            showingAddExpense = true
                        }
                    }
                #endif
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView()
                    .presentationDetents([.height(300), .medium])
            }
    }
}

#Preview {
    NavigationStack {
        iExpense()
    }
}
