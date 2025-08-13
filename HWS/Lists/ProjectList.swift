//
//  ProjectsList.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct ProjectList: View {
    @Binding var selectedProject: Project?
    var selectedLesson: Lesson

    var body: some View {
        NavigationStack {
            List(selection: $selectedProject) {
                Section(header: Text("Projects")) {
                    if selectedLesson.projects.count > 0 {
                        ForEach(
                            selectedLesson.projects.sorted { $0.date < $1.date }
                        ) { project in
                            ProjectListRow(project: project)
                                .tag(project)
                                .swipeActions(edge: .leading) {
                                    Button(
                                        "Mark as complete",
                                        systemImage: "checkmark"
                                    ) {
                                    }
                                    .tint(.green)
                                }
                        }
                    } else {
                        Text("No projects, yet.")
                    }

                }
            }
            .navigationTitle(selectedLesson.title)
        }
    }
}

#Preview {
    ProjectList(
        selectedProject: .constant(Project.startingSwiftUI.first),
        selectedLesson: Lesson.hundreedDaysOfSwiftUILessons.first!
    )
}
