//
//  ExpenseItemsView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 31/08/2025.
//

import SwiftData
import SwiftUI

struct ExpenseItemsView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [ExpenseItem]

    var body: some View {
        List {
            ForEach(expenses) { item in
                ExpenseItemView(item: item)
            }
            .onDelete(perform: removeItem)
        }
    }

    init(type: String, sortOrder: [SortDescriptor<ExpenseItem>]) {
        if type != "All" {
            _expenses = Query(
                filter: #Predicate<ExpenseItem> { item in
                    item.type == type
                },
                sort: sortOrder
            )
        } else {
            _expenses = Query(sort: sortOrder)
        }
    }

    /// Removes an item from SwiftData
    /// - Parameter offsets: specifies where is item located in the list for exact delete location
    func removeItem(at offsets: IndexSet) {
        for offset in offsets {
            let item = expenses[offset]
            modelContext.delete(item)
        }
    }
}

#Preview {
    ExpenseItemsView(type: "All", sortOrder: [SortDescriptor(\ExpenseItem.name)])
}
