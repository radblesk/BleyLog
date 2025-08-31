//
//  SocialsUserView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 31/08/2025.
//

import SwiftUI

struct SocialsUserView: View {
    var user: SocSDUser
    let layout = [
        GridItem(.flexible(minimum: 20, maximum: 80))
    ]

    var body: some View {
        List {
            Section("Basic Info") {
                Text("Age: \(user.age)")
                Text("Email: \(user.email)")
                Text("Company: \(user.company)")
                Text("Address: \(user.address)")
                Text("Registered since: \(user.formattedDate)")
            }

            Section("About") {
                Text(user.about)
            }

            Section("Tags") {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: layout, alignment: .center) {
                        ForEach(user.tags, id: \.self) { tag in
                            Text(tag)
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                                .padding(10)
                                .background(.blue)
                                .clipShape(.capsule)
                        }
                    }
                }
                .listRowBackground(Color.clear)
                .scrollClipDisabled()
            }

            Section("Friends") {
                ForEach(user.unwrappedFriends, id: \.id) { friend in
                    Text(friend.name)
                }
            }

        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
