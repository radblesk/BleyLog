//
//  ProjectsList.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct ProjectsList: View {
    @Query(sort: \Project.projectNumber) private var projects: [Project]
    @Environment(\.modelContext) private var context

    @Binding var selectedProject: Int?
    var selectedDays: Int

    var body: some View {
        let courseFilter = Days.daysData.filter({ $0.firstDay == selectedDays })
        let courseName =
            "Day \(courseFilter.first?.firstDay ?? 0)-\(courseFilter.first?.lastDay ?? 0) \(courseFilter.first?.title ?? "")"
        let filteredProjects = projects.filter({
            $0.startingDay == selectedDays
        })

        NavigationStack {
            List(selection: $selectedProject) {
                Section(header: Text("Projects")) {
                    if filteredProjects.count > 0 {
                        ForEach(filteredProjects) { project in
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
                            .tag(project.projectNumber)
                        }
                    } else {
                        Text("No projects found")
                    }

                }
            }
            .navigationTitle(courseName)
        }
    }
}

#Preview {
    ProjectsList(selectedProject: .constant(1), selectedDays: 26)
        .modelContainer(ProjectsData.shared.modelContainer)
}
