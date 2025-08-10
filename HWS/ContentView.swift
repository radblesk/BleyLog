//
//  ContentView.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility
        .all
    @State private var preferredCompactColumn = NavigationSplitViewColumn
        .sidebar
    @State private var selectedDays: Int?
    @State private var selectedProject: Int?

    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            preferredCompactColumn: $preferredCompactColumn
        ) {
            DaysList(selectedDays: $selectedDays)
                .modelContainer(ProjectsData.shared.modelContainer)

        } content: {
            if let selectedDays {
                ProjectsList(
                    selectedProject: $selectedProject,
                    selectedDays: selectedDays
                )
                .modelContainer(ProjectsData.shared.modelContainer)

            } else {
                Text("Select course")
            }
        } detail: {
            // Group the views so you can apply a modifier once.
            Group {
                // Use a switch statement for better readability.
                switch selectedProject {
                case 1:
                    WeSplit()
                case 2:
                    TempConvert()
                case 3:
                    GuessTheFlag()
                default:
                    Text("Select project")
                }
            }
            // Apply the conditional modifier only once.
            #if os(macOS)
                .padding()
            #endif
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(ProjectsData.shared.modelContainer)
}
