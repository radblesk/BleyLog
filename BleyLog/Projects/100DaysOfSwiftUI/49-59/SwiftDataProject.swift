//
//  SwiftDataProject.swift
//  BleyLog
//
//  Created by Radoslav Bley on 31/08/2025.
//

import SwiftData
import SwiftUI

struct SwiftDataProject: View {
    @Environment(\.modelContext) var modelContext
    @State private var showingUpcomingOnly: Bool = false
    @State private var searchText: String = ""
    @State private var sortOrder = [
        SortDescriptor(\User.name),
        SortDescriptor(\User.joinDate),
    ]

    var body: some View {
        UsersView(contains: searchText, sortOrder: sortOrder)
            .navigationTitle("Users")
            .navigationDestination(for: User.self) { user in
                EditUserView(user: user)
            }
            .searchable(text: $searchText, prompt: "Search users")
            .toolbar {
                Button("Add user", systemImage: "plus") {
//                    try? modelContext.delete(model: User.self)
//
//                    let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
//                    let second = User(
//                        name: "Rosa Diaz",
//                        city: "New York",
//                        joinDate: .now.addingTimeInterval(86400 * -5)
//                    )
//                    let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
//                    let fourth = User(
//                        name: "Johnny English",
//                        city: "London",
//                        joinDate: .now.addingTimeInterval(86400 * 10)
//                    )
//
//                    modelContext.insert(first)
//                    modelContext.insert(second)
//                    modelContext.insert(third)
//                    modelContext.insert(fourth)
                    
                    let newUser = User(name: "New user", city: "", joinDate: .now)
                    
                    modelContext.insert(newUser)
                }
                #if os(iOS)
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by name")
                                .tag([
                                    SortDescriptor(\User.name),
                                    SortDescriptor(\User.joinDate),
                                ])
                            Text("Sort by date")
                                .tag([
                                    SortDescriptor(\User.joinDate),
                                    SortDescriptor(\User.name),
                                ])
                        }
                    }
                #endif
            }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: User.self, configurations: config)

        return NavigationStack {
            SwiftDataProject()
                .modelContainer(container)
        }
    } catch {
        return Text("Failed to create a preview: \(error.localizedDescription)")
    }
}
