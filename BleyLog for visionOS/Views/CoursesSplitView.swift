//
//  CoursesSplitView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 23/08/2025.
//

import SwiftData
import SwiftUI

struct CoursesSplitView: View {
    // MARK: Environments
    /// ModelData
    @Environment(ModelData.self) private var ModelData

    // States
    @State private var columnVisibility = NavigationSplitViewVisibility
        .doubleColumn
    @State private var preferredCompactColumn = NavigationSplitViewColumn
        .sidebar

    var body: some View {
        @Bindable var ModelData = ModelData
        NavigationSplitView {
            LessonList(
                languages: ModelData.languages,
                selectedLanguage: $ModelData.selectedLanguage,
                lesson: $ModelData.selectedLesson,
            )
            .toolbar {
                Menu {
                    Picker("Language", selection: $ModelData.selectedLanguage) {
                        ForEach(ModelData.languages) { language in
                            Text(language.title).tag(language)
                        }
                    }
                } label: {
                    Button(
                        "Language",
                        systemImage: "line.3.horizontal.decrease"
                    ) {}
                    .buttonStyle(.plain)
                }
            }

        } content: {
            ProjectList(lesson: ModelData.selectedLesson, project: $ModelData.selectedProject)
        } detail: {
            ProjectView(project: ModelData.selectedProject)
        }
        .onChange(of: ModelData.selectedLesson) {
            ModelData.selectedProject = nil
        }
    }
}

#Preview {
    let ModelData = ModelData()

    CoursesSplitView()
        .environment(ModelData)
}
