//
//  ProjectsData.swift
//  BleyLog
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

    var defaultLesson: Lesson?

    init() {
        let schema = Schema([
            Language.self,
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
        let descriptor = FetchDescriptor<Language>()

        guard let languages = try? context.fetch(descriptor) else { return }

        if languages.isEmpty {
            for language in Language.languages {
                context.insert(language)
            }
        }
    }
}
