//
//  ExpenseItemView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 31/08/2025.
//

import SwiftUI

struct ExpenseItemView: View {
    var item: ExpenseItem
    
    var body: some View {
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
}

#Preview {
    ExpenseItemView(item: ExpenseItem(name: "Test", type: "Personal", amount: 0.0))
}
