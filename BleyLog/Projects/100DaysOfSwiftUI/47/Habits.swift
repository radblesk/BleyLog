//
//  Habits.swift
//  BleyLog
//
//  Created by Radoslav Bley on 28/08/2025.
//

import SwiftUI

// MARK: - Habit Model
struct Habit: Identifiable, Codable, Hashable, Equatable {
    var id = UUID()
    let title: String
    let description: String
    var completedSum: Int
}

// MARK: - Habits ModelData
@Observable
class HabitsStore {
    var habits = [Habit]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(habits) {
                UserDefaults.standard.set(encoded, forKey: "Habits")
            }
        }
    }

    init() {
        if let savedHabits = UserDefaults.standard.data(forKey: "Habits") {
            if let decodedHabits = try? JSONDecoder().decode([Habit].self, from: savedHabits) {
                habits = decodedHabits
                return
            }
        }

        habits = []
    }
}

// MARK: - Main View
struct Habits: View {
    // Environments
    @Environment(\.dismiss) private var dismiss

    // Load ModelData
    @State private var store = HabitsStore()

    // Add habit sheet
    @State private var presented = false

    // Habit data
    @State private var name: String = "New habit"
    @State private var description: String = ""
    @State private var completedSum: Int = 0

    var body: some View {
        List {
            if store.habits.isEmpty {
                Text("Add new habit to get started!")
            } else {
                ForEach(store.habits) { habit in
                    NavigationLink(habit.title, value: habit)
                }
                .onDelete(perform: deleteHabit)
            }
        }
        .navigationTitle("Habits")
        .navigationDestination(for: Habit.self) { habit in
            List {
                if !habit.description.isEmpty {
                    Section("Description") {
                        Text(habit.description)
                    }
                }

                Section {
                    VStack {
                        Button("\(completedSum) days completed") {
                            updateHabit(for: habit)
                        }
                        .contentTransition(.numericText())
                        .foregroundStyle(.white)
                        .bold()
                        .multilineTextAlignment(.center)
                        .buttonStyle(.plain)
                        .frame(width: 120, height: 120)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                    }
                    .listRowBackground(Color.clear)
                    .frame(maxWidth: .infinity)
                } header: {
                    Text("Progress")
                } footer: {
                    Text(
                        "To increase your number, tap the button above! Once you've completed a day, it will be added to the count."
                    )
                }
            }
            .navigationTitle(habit.title)
            .toolbar {
                Button("Reset", systemImage: "arrow.clockwise", role: .destructive) {
                    withAnimation {
                        resetHabit(for: habit)
                    }
                }
            }
            .onAppear {
                loadHabitData(for: habit)
            }
        }
        .toolbar {
            #if os(iOS)
                if !store.habits.isEmpty {
                    EditButton()
                }
            #endif
            Button("Add habit", systemImage: "plus") {
                presented = true
            }
        }
        .sheet(isPresented: $presented) {
            NavigationStack {
                Form {
                    TextField("Description", text: $description)
                }
                .navigationTitle($name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button("Save") {
                        addHabit()
                    }
                }
                .onSubmit(addHabit)
            }
            .presentationDetents([.height(180)])
        }
    }

    // MARK: - Methods

    // MARK: Add Habit
    func addHabit() {
        // Create new habit instance
        let newHabit = Habit(title: name, description: description, completedSum: 0)

        // Add habit to stored array
        store.habits.append(newHabit)

        // Close sheet
        presented = false
    }

    // MARK: Load stored habit data
    func loadHabitData(for habit: Habit) {
        completedSum = habit.completedSum
    }

    // MARK: Update existing habit at index
    func updateHabit(for habit: Habit) {
        // Find index of updating habit
        let index = store.habits.firstIndex(of: habit)

        if let index {
            // Increase UI state
            completedSum += 1

            // Create new temporary habit instance
            /// Pass previously saved data + new completedSum value
            let updatedHabit = Habit(
                title: habit.title,
                description: habit.description,
                completedSum: completedSum
            )

            // Update habit
            store.habits[index] = updatedHabit
        }
    }

    // MARK: Reset habit progress
    func resetHabit(for habit: Habit) {
        if let index = store.habits.firstIndex(of: habit) {
            store.habits[index].completedSum = 0
        }
    }

    // MARK: Delete habit
    func deleteHabit(at offsets: IndexSet) {
        store.habits.remove(atOffsets: offsets)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        Habits()
    }
}
