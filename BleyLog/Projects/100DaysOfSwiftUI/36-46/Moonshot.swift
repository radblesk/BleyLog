//
//  Moonshot.swift
//  BleyLog
//
//  Created by Radoslav Bley on 27/08/2025.
//

import SwiftUI

struct Moonshot: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    enum DisplayMode: String, CaseIterable {
        case list = "List"
        case grid = "Grid"
    }

    @State private var displayMode: DisplayMode = .grid

    var body: some View {
        NavigationStack {
            Group {
                switch displayMode {
                case .grid:
                    MoonshotGridView(astronauts: astronauts, missions: missions)
                case .list:
                    MoonshotListView(missions: missions, astronauts: astronauts)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                #if !os(watchOS)
                    Menu {
                        Picker("Display Mode", selection: $displayMode) {
                            ForEach(DisplayMode.allCases, id: \.rawValue) { mode in
                                Text(mode.rawValue)
                                    .tag(mode)
                            }
                        }
                    } label: {
                        Button("Toggle view", systemImage: "line.3.horizontal.decrease") {}
                    }
                #elseif os(watchOS)
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        Button("Toggle View", systemImage: "line.3.horizontal.decrease") {
                            if displayMode == .grid {
                                displayMode = .list
                            } else {
                                displayMode = .grid
                            }
                        }
                    }
                #endif
            }
        }
        #if os(macOS)
            .frame(minWidth: 700)
        #endif
    }
}

#Preview {
    Moonshot()
}
