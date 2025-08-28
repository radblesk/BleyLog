//
//  MoonshotListView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 27/08/2025.
//

import SwiftUI

struct MoonshotListView: View {
    let missions: [Mission]
    let astronauts: [String: Astronaut]

    var body: some View {
        List {
            ForEach(missions) { mission in
                NavigationLink(value: mission) {
                    HStack(spacing: 20) {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)

                        VStack(alignment: .leading) {
                            Text(mission.displayName)
                            Text(mission.formattedLaunchDate)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            #if !os(watchOS)
                .listRowBackground(Color.lightBackground)
            #endif
        }
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    return MoonshotListView(missions: missions, astronauts: astronauts)
}
