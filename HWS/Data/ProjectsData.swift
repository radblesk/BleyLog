//
//  ProjectsData.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import Foundation
import SwiftData

@MainActor
class ProjectsData {
    static let shared = ProjectsData()
    let modelContainer: ModelContainer
    var context: ModelContext {
        modelContainer.mainContext
    }
    init() {
        let schema = Schema([
            Courses.self,
            Days.self,
            Project.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )

        do {
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )

            insertProjecData()

            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")

        }

    }

    private func insertProjecData() {
        for courses in Courses.coursesData {
            context.insert(courses)
        }

        for days in Days.daysData {
            context.insert(days)
        }

        for project in Project.projectsData {
            context.insert(project)
        }
    }
}
