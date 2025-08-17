//
//  ProjectsList.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct ProjectList: View {
    var lesson: Lesson? = ModelData.shared.defaultLesson

    var body: some View {
        List {
            Section(header: Text("Projects")) {
                if let lesson {
                    if lesson.projects.count > 0 {
                        ForEach(
                            lesson.projects.sorted { $0.date < $1.date }
                        ) { project in
                            NavigationLink {
                                ProjectDetailView(project: project)
                            } label: {
                                ProjectListRow(project: project)
                            }
                        }
                    } else {
                        Text("No projects, yet.")
                    }
                } else {
                    Text("No lesson selected.")
                }
            }
        }
        .navigationTitle(lesson?.title ?? "")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    ProjectList(
        lesson: Lesson.hundreedDaysOfSwiftUILessons.first!
    )
}
