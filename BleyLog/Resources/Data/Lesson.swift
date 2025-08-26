//
//  Projects.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

@Model
class Lesson {
    var firstDay: Int
    var lastDay: Int
    var title: String
    var inProgress: Bool = false
    var finished: Bool = false

    @Relationship(deleteRule: .cascade) var projects: [Project] = []
    var course: Course?

    init(
        firstDay: Int,
        lastDay: Int,
        title: String,
        inProgress: Bool = false,
        finished: Bool = false,
        projects: [Project] = [],
        course: Course? = nil

    ) {
        self.firstDay = firstDay
        self.lastDay = lastDay
        self.title = title
        self.inProgress = inProgress
        self.finished = finished
        self.projects = projects
        self.course = course

    }

    static let hundreedDaysOfSwiftUILessons = [
        Lesson(
            firstDay: 16,
            lastDay: 24,
            title: "Starting SwiftUI",
            finished: true,
            projects: Project.startingSwiftUI,
        ),
        Lesson(
            firstDay: 25,
            lastDay: 25,
            title: "Consolidation II",
            finished: true,
            projects: Project.consolidation2
        ),
        Lesson(
            firstDay: 26,
            lastDay: 34,
            title: "Expanding your skills",
            inProgress: true,
            projects: Project.expandingYourSkills,
        ),
        Lesson(
            firstDay: 35,
            lastDay: 35,
            title: "Consolidation III",
        ),
        Lesson(
            firstDay: 36,
            lastDay: 46,
            title: "Scaling up to bigger apps",
        ),
        Lesson(
            firstDay: 47,
            lastDay: 48,
            title: "Consolidation IV",
        ),
        Lesson(
            firstDay: 49,
            lastDay: 59,
            title: "Focus on data",
        ),
        Lesson(
            firstDay: 60,
            lastDay: 61,
            title: "Consolidation V",
        ),
        Lesson(
            firstDay: 62,
            lastDay: 76,
            title: "Filters, maps, and more",
        ),
        Lesson(
            firstDay: 77,
            lastDay: 78,
            title: "Consolidation VI",
        ),
        Lesson(
            firstDay: 79,
            lastDay: 94,
            title: "Controlling UI flow",
        ),
        Lesson(
            firstDay: 95,
            lastDay: 95,
            title: "Consolidation VII",
        ),
        Lesson(
            firstDay: 96,
            lastDay: 99,
            title: "One last project",
        ),
        Lesson(
            firstDay: 100,
            lastDay: 100,
            title: "Final Exam",
        ),
    ]
}
