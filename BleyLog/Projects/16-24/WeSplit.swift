//
//  WeSplit.swift
//  BleyLog
//
//  Created by Radoslav Bley on 08/07/2025.
//

import SwiftUI

struct WeSplit: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    @State private var isPresenting = false

    let tipPercentages = [10, 15, 20, 25, 0]

    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)

        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount

        return amountPerPerson
    }

    var totalCheckAmount: Double {
        let tipSelection = Double(tipPercentage)

        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue

        return grandTotal
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        "Amount",
                        value: $checkAmount,
                        format: .currency(
                            code: Locale.current.currency?.identifier ?? "EUR"
                        )
                    )
                    #if os(iOS)
                        .keyboardType(.decimalPad)
                    #endif
                    .focused($amountIsFocused)

                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                    #if os(iOS)
                        .pickerStyle(.navigationLink)
                    #endif
                }

                Section("How much do you want to tip?") {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Grand Total") {
                    Text(
                        totalCheckAmount,
                        format:
                            .currency(
                                code: Locale.current.currency?.identifier
                                    ?? "EUR"
                            )
                    )
                    .foregroundStyle(tipPercentage == 0 ? .red : .primary)
                }

                Section("Amount per person") {
                    Text(
                        totalPerPerson,
                        format: .currency(
                            code: Locale.current.currency?.identifier ?? "EUR"
                        )
                    )
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                Button {
                    isPresenting = true
                } label: {
                    Label("Source Code", systemImage: "terminal")
                }
                if amountIsFocused {
                    Button("Done", systemImage: "checkmark") {
                        amountIsFocused = false
                    }
                }
            }
            .sheet(isPresented: $isPresenting) {
                SheetView(isPresenting: $isPresenting, project: "weSplit")
            }
        }
    }
}

#Preview {
    WeSplit()
}
