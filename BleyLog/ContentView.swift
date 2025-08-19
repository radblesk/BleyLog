//
//  ContentView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    // DataModel
    @Environment(\.modelContext) private var context
    @Query(sort: \Language.title) private var languages: [Language]

    // States
    @State private var columnVisibility = NavigationSplitViewVisibility
        #if os(iOS) || os(tvOS)
            .doubleColumn
        #else
            .all
        #endif
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
            .navigationSplitViewColumnWidth(min: 250, ideal: 300)

        } content: {
            ProjectList(lesson: selectedLesson, project: $selectedProject)
                .navigationSplitViewColumnWidth(min: 300, ideal: 300)
                #if os(iOS)
                    .onChange(of: selectedLesson) {
                        columnVisibility = .doubleColumn
                    }
                #endif
        } detail: {
            ProjectDetailView(project: selectedProject)
                #if os(macOS)
                    .navigationSplitViewColumnWidth(min: 250, ideal: 350)
                #endif
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    ContentView()
        .modelContainer(ModelData.shared.modelContainer)
}
