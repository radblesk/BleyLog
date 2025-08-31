//
//  UsersView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 31/08/2025.
//

import SwiftData
import SwiftUI

struct UsersView: View {
    @Environment(\.modelContext) var modelContext
    @Query var users: [User]

    var body: some View {
        List {
            ForEach(users) { user in
                NavigationLink(value: user) {
                    HStack {
                        Text(user.name)
                        Spacer()
                        Text(String(user.unwrappedJobs.count))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete(perform: deleteUser)
        }
    }

    init(contains: String, sortOrder: [SortDescriptor<User>]) {
        if !contains.isEmpty {
            _users = Query(
                filter: #Predicate<User> { user in
                    user.name.localizedStandardContains(contains)
                },
                sort: sortOrder
            )
        } else {
            _users = Query(sort: sortOrder)
        }
    }

    func addSample() {
        let user1 = User(name: "Piper Chapman", city: "New Yorl", joinDate: .now)
        let job1 = Job(name: "Organize sock drawer", priority: 3)
        let job2 = Job(name: "Buy groceries", priority: 1)

        modelContext.insert(user1)

        user1.jobs?.append(job1)
        user1.jobs?.append(job2)
    }

    func deleteUser(at offsets: IndexSet) {
        for offset in offsets {
            let user = users[offset]
            modelContext.delete(user)
        }
    }
}

#Preview {
    UsersView(contains: "", sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self)
}
