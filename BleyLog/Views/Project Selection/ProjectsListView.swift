//
//  ProjectsListView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 27/08/2025.
//

import SwiftUI

struct ProjectsListView: View {
    var modelData: ModelData
    var lesson: Lesson?

    var body: some View {
        List(modelData.projects(in: lesson)) { project in
            NavigationLink(value: project) {
                ProjectsListRow(project: project)
            }
        }
        .navigationTitle(lesson?.title ?? "")
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: lesson?.id) {
            modelData.selectedLesson = lesson
        }
        .onAppear {
            modelData.selectedLesson = lesson
        }
        .apply {
            if #available(iOS 26, *) {
                $0.navigationSubtitle(days())
            } else {
                $0.disabled(false)
            }
        }
    }

    func days() -> String {
        guard modelData.selectedLesson != nil else {
            return ""
        }
        if let lesson = lesson {
            let oneDay = lesson.firstDay == lesson.lastDay
            return oneDay ? "Day \(lesson.firstDay)" : "Days \(lesson.firstDay) - \(lesson.lastDay)"
        } else {
            return ""
        }
    }
}

#Preview {
    NavigationStack {
        ProjectsListView(modelData: ModelData())
            .environment(ModelData())
    }
}
