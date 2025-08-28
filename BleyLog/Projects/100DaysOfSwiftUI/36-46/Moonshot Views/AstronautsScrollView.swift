//
//  AstronautsScrollView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 27/08/2025.
//

import SwiftUI

struct AstronautsScrollView: View {
    let crew: [CrewMember]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.role) { crew in
                    NavigationLink(value: crew) {
                        HStack {
                            Image(crew.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .clipShape(.capsule)
                                .overlay(Capsule().strokeBorder(.white, lineWidth: 1))

                            VStack(alignment: .leading) {
                                Text(crew.astronaut.name)
                                    .foregroundStyle(.white)
                                    .font(.headline)

                                Text(crew.role)
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationDestination(for: CrewMember.self) { astronaut in
            AstronautView(astronaut: astronaut.astronaut)
        }
    }
}
