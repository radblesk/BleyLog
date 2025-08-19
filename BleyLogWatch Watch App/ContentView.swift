//
//  ContentView.swift
//  BleyLogWatch Watch App
//
//  Created by Radoslav Bley on 19/08/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    // DataModel
    @Environment(\.modelContext) private var context
    @Query(sort: \Language.title) private var languages: [Language]

    // States
    @State private var columnVisibility = NavigationSplitViewVisibility
        .automatic
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
        } content: {
            ProjectList(lesson: selectedLesson, project: $selectedProject)
        } detail: {
            ProjectDetailView(project: selectedProject)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(ModelData.shared.modelContainer)
}
