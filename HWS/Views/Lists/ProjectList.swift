//
//  ProjectsList.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct ProjectList: View {
    var selectedLesson: Lesson?

    @Binding var selectedProject: Project?

    var body: some View {
        NavigationStack {
            List(selection: $selectedProject) {
                Section(header: Text("Projects")) {
                    if let lesson = selectedLesson {
                        if lesson.projects.count > 0 {
                            ForEach(
                                lesson.projects.sorted { $0.date < $1.date },
                                id: \.self
                            ) { project in
                                HStack {
                                    Label(project.title, systemImage: "folder")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                        .imageScale(.small)
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
            .navigationTitle(selectedLesson?.title ?? "")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

#Preview {
    ProjectList(
        selectedLesson: ModelData.shared.defaultLesson,
        selectedProject: .constant(nil)
    )
}
