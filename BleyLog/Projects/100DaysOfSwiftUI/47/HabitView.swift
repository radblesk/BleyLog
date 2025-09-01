//
//  HabitView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 01/09/2025.
//

import SwiftData
import SwiftUI

struct HabitView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @Bindable var habit: Habit

    var body: some View {
        Form {
            Section("Description") {
                TextField("", text: $habit.habitDescription)
            }

            Section {
                VStack {
                    Button("\(habit.days) days completed") {
                        withAnimation {
                            habit.days += 1
                        }
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
            Button("Delete", systemImage: "trash") {
                deleteHabit()
            }
            Button("Reset", systemImage: "arrow.clockwise", role: .destructive) {
                withAnimation {
                    habit.days = 0
                }
            }
        }
    }

    func deleteHabit() {
        modelContext.delete(habit)

        dismiss()
    }
}

#Preview {
    HabitView(habit: Habit(title: "Not smoking", habitDescription: "Stop fucking dying", days: 614))
}
