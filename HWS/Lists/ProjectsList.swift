//
//  ProjectsList.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct ProjectsList: View {
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
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(project.title)
                                        .font(.headline)
                                    Text(
                                        "\(project.date.formatted(.relative(presentation: .numeric, unitsStyle: .spellOut)))"
                                    )
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .imageScale(.small)
                                    .foregroundStyle(.secondary)
                            }
                            .tag(project)
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
