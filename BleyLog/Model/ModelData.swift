//
//  ProjectsData.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import Foundation
import Observation
import SwiftUI

@Observable @MainActor
class ModelData {
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
    var selectedLesson: Lesson? = .exampleLesson {
        didSet {
            guard selectedLesson != oldValue && selectedLesson != nil else { return }
            if let lesson = selectedLesson {
                let lessonID: String = lesson.id
                UserDefaults.standard.set(lessonID, forKey: "selectedLesson")
            }
        }
    }
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
        self.languages = Language.languages.sorted { $0.title < $1.title }
        setDefaultLanguage()

        let allLessons = languages.flatMap(\.courses).flatMap(\.lessons)
        if let savedLesson = UserDefaults.standard.string(forKey: "selectedLesson") {

            if let lesson = allLessons.first(where: { $0.id == savedLesson }) {
                selectedLesson = lesson
            }
        } else {
            setDefaultLesson()
        }
    }

    // MARK: - Defaults
    /// Default language selection
    func setDefaultLanguage() {
        if selectedLanguage == nil {
            selectedLanguage = languages.first(where: { $0.title == "Swift" })
        } else {
            return
        }
    }

    /// Default lesson selection
    func setDefaultLesson() {
        selectedLesson = defaultLesson()
    }

    func defaultLesson() -> Lesson {
        let lesson = selectedLanguage!.courses.flatMap(\.lessons).first!
        return lesson
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
        let allLessons = languages.flatMap(\.courses).flatMap(\.lessons).sorted {
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

    // MARK: - Date Formatter
    func formattedDate(_ date: Date) -> String {
        let weekAgo =
            Calendar.current.date(byAdding: .dayOfYear, value: -7, to: Date())! < date

        if weekAgo {
            return date.formatted(.relative(presentation: .numeric, unitsStyle: .wide))
        } else {
            return date.formatted(date: .abbreviated, time: .omitted)
        }
    }
}
