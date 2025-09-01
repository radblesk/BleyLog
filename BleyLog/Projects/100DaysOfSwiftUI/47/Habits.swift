//
//  Habits.swift
//  BleyLog
//
//  Created by Radoslav Bley on 28/08/2025.
//

import SwiftData
import SwiftUI

struct Habits: View {
    // Environments
    @Environment(\.modelContext) var modelContext
    @Query var habits: [Habit]

    // Add habit sheet
    @State private var presented = false

    var body: some View {
        List {
            if habits.isEmpty {
                Text("Add new habit to get started!")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            } else {
                ForEach(habits) { habit in
                    NavigationLink(habit.title, value: habit)
                }
                .onDelete(perform: deleteHabit)
            }
        }
        .navigationTitle("Habits")
        .navigationDestination(for: Habit.self) { habit in
            HabitView(habit: habit)
        }
        .toolbar {
            #if os(iOS)
                if !habits.isEmpty {
                    EditButton()
                }
            #endif
            Button("Add habit", systemImage: "plus") {
                presented.toggle()
            }
        }
        .sheet(isPresented: $presented) {
            NavigationStack {
                AddHabit()
            }
            .presentationDetents([.medium])
        }
    }

    /// Delete habit
    /// - Parameter offsets: Returns index position of habit in the list
    func deleteHabit(at offsets: IndexSet) {
        for offset in offsets {
            let habit = habits[offset]
            modelContext.delete(habit)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        Habits()
            .modelContainer(for: Habit.self)
    }
}
