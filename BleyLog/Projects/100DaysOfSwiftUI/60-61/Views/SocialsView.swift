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
    @Query var savedUsers: [SocSDUser]
    @State private var users = [SocialsUser]()

    var body: some View {
        List(savedUsers) { user in
            NavigationLink {
                SocialsUserView(user: user)
            } label: {
                HStack {
                    Image(systemName: user.isActive ? "circlebadge.fill" : "circlebadge")
                        .foregroundStyle(user.isActive ? .green : .gray)

                    Text(user.name)
                }
            }
        }
        .navigationTitle("Socials")
        .toolbar {
            Button("Refresh", systemImage: "arrow.clockwise") {
                try? modelContext.delete(model: SocSDUser.self)
                print("saved users removed")
                
                Task {
                    await fetchUsers()
                }
            }
        }
        .task {
            await fetchUsers()
        }
    }

    func fetchUsers() async {
        print("Checking if users are already fetched...")
        if savedUsers.isEmpty {
            print("Fetching users...")
            guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
                print("Invalid URL")
                return
            }

            print(url)

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                print(data)

                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
                decoder.dateDecodingStrategy = .formatted(formatter)

                if let decodedResponse = try? decoder.decode([SocialsUser].self, from: data) {
                    users = decodedResponse

                    for user in users {
                        let friends = user.friends.map { friend in
                            SocSDFriend(id: friend.id, name: friend.name)
                        }

                        let savedUser = SocSDUser(
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

                        modelContext.insert(savedUser)
                    }

                    try modelContext.save()
                }
            } catch {
                print("Invalid data")
            }
        }
    }
}

#Preview {
    SocialsView()
}
