//
//  ProjectsData.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import Foundation
import SwiftData

@MainActor
class ModelData {
    static let shared = ModelData()
    let modelContainer: ModelContainer
    var context: ModelContext {
        modelContainer.mainContext
    }

    init() {
        let schema = Schema([
            Course.self,
            Lesson.self,
            Project.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )

            insertModelData()

            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")

        }

    }

    private func insertModelData() {
        let descriptor = FetchDescriptor<Course>()

        guard let course = try? context.fetch(descriptor) else { return }

        if course.isEmpty {
            for courses in Course.coursesData {
                context.insert(courses)
            }
        }
    }

    func removeAll() {
        let descriptor = FetchDescriptor<Course>()

        if let course = try? context.fetch(descriptor) {
            for item in course {
                context.delete(item)
            }
        }
    }
}
