//
//  iExpense.swift
//  BleyLog
//
//  Created by Radoslav Bley on 26/08/2025.
//

import SwiftUI

// MARK: - Expense item Model
struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

// MARK: - Expenses Model
@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }

    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

// MARK: - Main View
struct iExpense: View {
    // States
    @State private var expenses = Expenses()
    @State private var showingAddExpense: Bool = false

    var personalItems: [ExpenseItem] {
        return expenses.items.filter { $0.type == "Personal" }
    }

    var businessItems: [ExpenseItem] {
        return expenses.items.filter { $0.type == "Business" }
    }

    var body: some View {
        NavigationStack {
            List {
                if !personalItems.isEmpty {
                    Section("Personal") {
                        ForEach(personalItems) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)

                                    Text(item.type)
                                }

                                Spacer()

                                Text(
                                    "\(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))"
                                )
                                .bold()
                                .foregroundStyle(
                                    item.amount > 100.0
                                        ? .red : item.amount > 10.0 ? .orange : .primary
                                )
                            }
                        }
                        .onDelete(perform: removePersonalItems)
                    }
                }

                if !businessItems.isEmpty {
                    Section("Business") {
                        ForEach(businessItems) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)

                                    Text(item.type)
                                }

                                Spacer()

                                Text(
                                    "\(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))"
                                )
                                .bold()
                                .foregroundStyle(
                                    item.amount > 100.0
                                        ? .red : item.amount > 10.0 ? .orange : .primary
                                )
                            }
                        }
                        .onDelete(perform: removeBusinessItems)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                #if os(iOS)
                    EditButton()
                #endif
                //                Button("Add Expense", systemImage: "plus") {
                //                    path.append(0)
                //                    //                    showingAddExpense = true
                //                }
                NavigationLink {
                    AddView(expenses: expenses)
                        .navigationBarBackButtonHidden()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
                    .presentationDetents([.height(300), .medium])
            }
        }
    }

    // MARK: - Methods
    // List items management
    /// Removes an item at specified offset
    func removePersonalItems(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { personalItems[$0] }

        expenses.items.removeAll { item in
            itemsToDelete.contains(where: { $0.id == item.id })
        }
    }

    func removeBusinessItems(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { businessItems[$0] }

        expenses.items.removeAll { item in
            itemsToDelete.contains(where: { $0.id == item.id })
        }
    }
}

#Preview {
    iExpense()
}
