//
//  Moonshot.swift
//  BleyLog
//
//  Created by Radoslav Bley on 27/08/2025.
//

import SwiftUI

struct Moonshot: View {
    @State private var path = NavigationPath()

    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    enum DisplayMode: String, CaseIterable {
        case grid = "Grid"
        case list = "List"
    }

    @State private var displayMode: DisplayMode = .grid

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                switch displayMode {
                case .grid:
                    MoonshotGridView(astronauts: astronauts, missions: missions)
                case .list:
                    MoonshotListView(missions: missions, astronauts: astronauts)
                }
            }
            .navigationDestination(for: Mission.self) { mission in
                MissionView(mission: mission, astronauts: astronauts)
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                #if !os(watchOS)
                    Menu {
                        Picker("Display Mode", selection: $displayMode.animation()) {
                            ForEach(DisplayMode.allCases, id: \.rawValue) { mode in
                                Text(mode.rawValue)
                                    .tag(mode)
                            }
                        }
                    } label: {
                        Button(
                            "Toggle view",
                            systemImage: (displayMode == .grid)
                                ? "list.bullet" : "rectangle.grid.1x2"
                        ) {}
                    }
                #elseif os(watchOS)
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        Button(
                            "Toggle View",
                            systemImage: (displayMode == .grid)
                                ? "list.bullet" : "rectangle.grid.1x2"
                        ) {
                            withAnimation {
                                if displayMode == .grid {
                                    displayMode = .list
                                } else {
                                    displayMode = .grid
                                }
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
