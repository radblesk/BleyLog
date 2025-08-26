//
//  ProjectsData.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

//internal import Combine
import Foundation
import SwiftData
import SwiftUI

@Observable @MainActor
class ViewModel {
    //    static let shared = ViewModel()
    // MARK: -  ModelContainer
    let modelContainer: ModelContainer
    var context: ModelContext {
        modelContainer.mainContext
    }

    // MARK: - Enums
    /// Lesson status options
    enum LessonStatus {
        case inProgress, finished, notStarted, started
    }

    // MARK: - Data
    /// Main top level data
    var languages: [Language] = []

    /// Selections
    var selectedLanguage: Language?
    var selectedLesson: Lesson?
    var selectedProject: Project?

    /// Search
    var search: String = ""

    // MARK: macOS specific
    /// Selection
    var selection = Set<Project.ID>()
    /// Sort Order
    var sortOrder: [KeyPathComparator<Project>] = [
        .init(\.title, order: SortOrder.reverse)
    ]
    /// Path
    var path = NavigationPath()

    // MARK: - Initialization
    init() {
        let schema = Schema([
            Language.self, Course.self, Lesson.self, Project.self,
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
            insertModelData()
            defaultLanguage()
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }

    }

    // MARK: - Insert default data
    func insertModelData() {
        let descriptor = FetchDescriptor<Language>()

        do {
            let existingLanguages = try context.fetch(descriptor).sorted {
                $0.title < $1.title
            }

            if existingLanguages.isEmpty {
                let programmingLanguages = Language.languages.sorted {
                    $0.title < $1.title
                }
                for language in programmingLanguages {
                    context.insert(language)
                }
                self.languages = programmingLanguages
            } else {
                self.languages = existingLanguages
            }
        } catch {
            fatalError("Failed to fetch or insert data: \(error)")
        }
    }

    // MARK: - Defaults
    /// Default language selection
    func defaultLanguage() {
        if selectedLanguage == nil {
            selectedLanguage = languages.first(where: { $0.title == "Swift" })
        } else {
            return
        }
    }

    /// Default lesson selection
    func defaultLesson() -> Lesson? {
        if selectedLesson == nil,
            let firstLesson = selectedLanguage?.courses.first(where: {
                !$0.lessons.isEmpty
            })?.lessons.first(where: {
                $0.inProgress == true
            })
        {
            return firstLesson
        } else {
            return selectedLesson
        }
    }

    // MARK: - Lists data
    // Courses in Language array
    /// Returns an array of all courses in specified language sorted by lessons number
    func courses(in language: Language?) -> [Course] {
        if let language {
            if !language.courses.isEmpty {
                return language.courses.sorted {
                    $0.lessons.count > $1.lessons.count
                }
            } else {
                return []
            }
        } else {
            return []
        }
    }

    // Lessons in Course array
    /// Returns an array of lessons in specified course sorted by starting date
    func lessons(in course: Course, status: LessonStatus? = nil) -> [Lesson] {
        switch status {
        case .finished:
            return course.lessons
                .filter { $0.finished == true }
                .sorted { $0.firstDay < $1.firstDay }
        case .inProgress:
            return course.lessons
                .filter { $0.inProgress == true }
                .sorted { $0.firstDay < $1.firstDay }
        case .notStarted:
            return course.lessons.filter { $0.projects.isEmpty }.sorted {
                $0.firstDay < $1.firstDay
            }
        case .started:
            return course.lessons
                .filter { !$0.projects.isEmpty }
                .sorted { $0.firstDay < $1.firstDay }
        case .none:
            return course.lessons.sorted { $0.firstDay < $1.firstDay }
        }
    }

    // Lessons array
    /// Returns an array of all lessons with or without selected status sorted by starting date
    func lessons(status: LessonStatus? = nil) -> [Lesson] {
        let allLessons = languages.flatMap(\.courses).flatMap(\.lessons)
        switch status {
        case .finished:
            return
                allLessons
                .filter { $0.finished == true }
                .sorted { $0.firstDay < $1.firstDay }
        case .inProgress:
            return
                allLessons
                .filter { $0.inProgress == true }
                .sorted { $0.firstDay < $1.firstDay }
        case .notStarted:
            return allLessons.filter { $0.projects.isEmpty }.sorted {
                $0.firstDay < $1.firstDay
            }
        case .started:
            return
                allLessons
                .filter { !$0.projects.isEmpty }
                .sorted { $0.firstDay < $1.firstDay }
        case .none:
            return allLessons.sorted { $0.firstDay < $1.firstDay }
        }
    }

    /// Projects array
    func projects(in lesson: Lesson?) -> [Project] {
        if let lesson {
            if !lesson.projects.isEmpty {
                return lesson.projects.sorted { $0.date < $1.date }
            } else {
                return []
            }
        } else {
            return []
        }
    }

    /// macOS Projects array for table view
    func projectsTable(in lesson: Lesson?) -> [Project] {
        if let lesson {
            return lesson.projects.sorted(using: sortOrder)
        } else {
            return []
        }
    }

    /// Find project for specified ID
    func project(for id: Project.ID) -> Project? {
        let allProjects = languages.flatMap { $0.courses }.flatMap {
            $0.lessons
        }.flatMap { $0.projects }
        
        return allProjects.first { $0.id == id }
    }

    /// macOS Append path
    func triggerNavigation() {
        guard let projectID = selection.first else { return }

        // Find the selected project from your data source
        if let project = projectsTable(in: selectedLesson).first(where: {
            $0.id == projectID
        }) {
            path.append(project)
        }
    }

    // MARK: - Search
    /// Lessons search results
    func lessonResults(for search: String) -> [Lesson] {
        let allLessons = languages.flatMap(\.courses).flatMap(\.lessons).sorted
        {
            $0.firstDay < $1.firstDay
        }

        if search.isEmpty {
            return allLessons
        } else {
            return allLessons.filter {
                $0.title.lowercased().contains(search.lowercased())
            }
        }
    }

    /// Projects search results
    func projectsResults(for search: String) -> [Project] {
        let allProjects = languages.flatMap(\.courses).flatMap(\.lessons)
            .flatMap(
                \.projects
            ).sorted { $0.date < $1.date }

        if search.isEmpty {
            return allProjects
        } else {
            return allProjects.filter {
                $0.title.lowercased().contains(search.lowercased())
            }
        }
    }
}
