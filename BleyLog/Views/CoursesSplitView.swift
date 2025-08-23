//
//  CoursesSplitView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 23/08/2025.
//

import SwiftData
import SwiftUI

struct CoursesSplitView: View {
    // DataModel
    @Environment(\.modelContext) private var context
    @Query(sort: \Language.title) private var languages: [Language]

    // States
    @State private var columnVisibility = NavigationSplitViewVisibility
        .doubleColumn
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
                .onChange(of: selectedLesson) {
                    columnVisibility = .doubleColumn
                }
        } detail: {
            ProjectDetailView(project: selectedProject)
        }
        .onChange(of: selectedLesson) {
            selectedProject = nil
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    CoursesSplitView()
}
