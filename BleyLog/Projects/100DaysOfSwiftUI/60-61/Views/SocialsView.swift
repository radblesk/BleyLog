//
//  SocialsView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 31/08/2025.
//

import SwiftUI

struct SocialsView: View {
    @State private var users = [SocialsUser]()
    var body: some View {
        List(users, id: \.id) { user in
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
        .task {
            await fetchUsers()
        }
    }

    func fetchUsers() async {
        print("Checking if users are already fetched...")
        if users.isEmpty {
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
