//
//  ContentView.swift
//  BleyLog for Mac
//
//  Created by Radoslav Bley on 20/08/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    // DataModel
    @Environment(\.modelContext) private var context
    @Query(sort: \Language.title) private var languages: [Language]

    // States
    @State private var columnVisibility = NavigationSplitViewVisibility
        .all
    @State private var preferredCompactColumn = NavigationSplitViewColumn
        .sidebar
    @State private var selectedLanguage: Language?
    @State private var selectedLesson: Lesson?
    @State private var selectedProject: Project?

    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            preferredCompactColumn: $preferredCompactColumn
        ) {
            LessonList(
                languages: languages,
                selectedLanguage: $selectedLanguage,
                lesson: $selectedLesson,
            )
            .navigationSplitViewColumnWidth(min: 200, ideal: 250)

        } content: {
            ProjectList(lesson: selectedLesson, project: $selectedProject)
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            ProjectDetailView(project: selectedProject)
                .navigationSplitViewColumnWidth(min: 250, ideal: 350)

        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    ContentView()
        .modelContainer(ModelData.shared.modelContainer)
}
