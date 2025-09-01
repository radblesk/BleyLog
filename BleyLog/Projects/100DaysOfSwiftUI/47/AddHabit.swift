//
//  AddHabit.swift
//  BleyLog
//
//  Created by Radoslav Bley on 01/09/2025.
//

import SwiftData
import SwiftUI

struct AddHabit: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext

    // Habit data
    @State private var title: String = ""
    @State private var habitDescription: String = ""

    var body: some View {
        Form {
            TextField("Habit title", text: $title)
            TextField("Description", text: $habitDescription)
        }
        .navigationTitle(habitTitle())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Save") {
                addHabit()
            }
        }
        .onSubmit(addHabit)
    }

    /// Adds new habit using SwiftData
    func addHabit() {
        let newHabit = Habit(title: title, habitDescription: habitDescription, days: 0)

        modelContext.insert(newHabit)

        dismiss()
    }

    func habitTitle() -> String {
        if title.isEmpty {
            return "New habit"
        } else {
            return title
        }
    }
}

#Preview {
    AddHabit()
        .modelContainer(for: Habit.self)
}
