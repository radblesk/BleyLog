//
//  ContentView.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility
        .doubleColumn
    @State private var preferredCompactColumn = NavigationSplitViewColumn
        .sidebar

    @Query(sort: \Course.title) private var courses: [Course]
    @Environment(\.modelContext) private var context

    @State var selectedLesson: Lesson? = Course.self.coursesData.first(
        where: {
            $0.lessons.count > 0
        })?.lessons.first(where: { $0.finished != true })
    @State private var selectedProject: Project?

    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            preferredCompactColumn: $preferredCompactColumn
        ) {
            LessonsList(courses: courses, selectedLesson: $selectedLesson)

        } content: {
            if let selectedLesson {
                ProjectsList(
                    selectedProject: $selectedProject,
                    selectedLesson: selectedLesson
                )
            } else {
                Text("Select a lesson")
            }
        } detail: {
            Group {
                switch selectedProject?.projectNumber {
                case 1:
                    WeSplit()
                case 2:
                    TempConvert()
                case 3:
                    GuessTheFlag()
                default:
                    Text("Select a project")
                }
            }
            // Apply the conditional modifier only once.
            #if os(macOS)
                .padding()
            #endif
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    ContentView()
        .modelContainer(ModelData.shared.modelContainer)
}
