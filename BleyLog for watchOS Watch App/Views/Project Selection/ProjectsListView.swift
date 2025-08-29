//
//  ProjectsListView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 28/08/2025.
//

import SwiftUI

struct ProjectsListView: View {
    var modelData: ModelData
    @State private var lesson: Lesson?

    var body: some View {
        List(modelData.projects(in: lesson)) { project in
            NavigationLink(value: project) {
                ProjectListRow(project: project)
            }
        }
        .onAppear(perform: loadLesson)
        .onChange(of: modelData.selectedLesson) {
            loadLesson()
        }
        .navigationTitle(modelData.selectedLesson?.title ?? "")
        .containerBackground(
            RadialGradient(
                colors: [
                    .teal.opacity(0.8),
                    .black,
                ],
                center: .bottom,
                startRadius: -200,
                endRadius: 400
            ),
            for: .navigation
        )
        .toolbarForegroundStyle(.teal, for: .automatic)
    }

    func loadLesson() {
        if let selectedLesson = modelData.selectedLesson {
            lesson = selectedLesson
        }
    }
}

#Preview {
    NavigationStack {
        ProjectsListView(modelData: ModelData())
            .environment(ModelData())
    }
}
