//
//  SocialsView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 31/08/2025.
//

import SwiftData
import SwiftUI

struct SocialsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\UserModel.isActive, order: .reverse)]) var savedUsers: [UserModel]

    var body: some View {
        List(savedUsers) { user in
            NavigationLink(value: user) {
                HStack {
                    Image(systemName: user.isActive ? "circlebadge.fill" : "circlebadge")
                        .foregroundStyle(user.isActive ? .green : .gray)

                    Text(user.name)
                }

            }
        }
        .navigationDestination(for: UserModel.self) { user in
            SocialsUserView(user: user)
        }
        .navigationTitle("Socials")
        .toolbar {
            Button("Refresh", systemImage: "arrow.clockwise") {
                try? modelContext.delete(model: UserModel.self)
                Task {
                    await fetchUsers()
                }
            }
        }
        .task {
            await fetchUsers()
        }
    }

    /// If there are no saved users, fetch new users from JSON and save them using SwiftData models
    func fetchUsers() async {
        if savedUsers.isEmpty {
            guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
                print("Invalid URL")
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
                decoder.dateDecodingStrategy = .formatted(formatter)

                if let decodedResponse = try? decoder.decode([UserModel].self, from: data) {
                    for user in decodedResponse {

                        let friends = user.unwrappedFriends.map { friend in
                            FriendModel(id: friend.id, name: friend.name)
                        }

                        let newUser = UserModel(
                            id: user.id,
                            isActive: user.isActive,
                            name: user.name,
                            age: user.age,
                            company: user.company,
                            email: user.email,
                            address: user.address,
                            about: user.about,
                            registered: user.registered,
                            tags: user.tags,
                            friends: friends
                        )

                        modelContext.insert(newUser)
                    }
                }
            } catch {
                print("Invalid data")
            }
        }
    }
}

#Preview {
    NavigationStack {
        SocialsView()
            .modelContainer(for: [UserModel.self, FriendModel.self])
    }
}
