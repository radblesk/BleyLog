//
//  ContentView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(ModelData.self) var modelData
    @State private var pathStore = PathStore()
    @State private var column = NavigationSplitViewColumn.detail

    var body: some View {
        NavigationSplitView(preferredCompactColumn: $column) {
            LessonsListView()
                .navigationDestination(for: Lesson.self) { lesson in
                    NavigationStack(path: $pathStore.path) {
                        ProjectsListView(modelData: modelData, lesson: lesson)
                    }
                    .navigationDestination(for: Project.self) { project in
                        ProjectView(project: project).viewForProject()
                    }
                }
        } detail: {
            if let selected = modelData.selectedLesson {
                NavigationStack(path: $pathStore.path) {
                    ProjectsListView(modelData: modelData, lesson: selected)
                        .navigationDestination(for: Project.self) { project in
                            ProjectView(project: project).viewForProject()
                        }
                }
            } else {
                Text("Select a lesson")
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
