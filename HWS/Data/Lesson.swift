//
//  Projects.swift
//  HWS
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

    init(
        firstDay: Int,
        lastDay: Int,
        title: String,
        inProgress: Bool = false,
        finished: Bool = false,
        projects: [Project] = []

    ) {
        self.firstDay = firstDay
        self.lastDay = lastDay
        self.title = title
        self.inProgress = inProgress
        self.finished = finished
        self.projects = projects

    }

    static let hundreedDaysOfSwiftUILessons = [
        Lesson(
            firstDay: 16,
            lastDay: 24,
            title: "Starting SwiftUI",
            projects: Project.startingSwiftUI,
        ),
        Lesson(
            firstDay: 26,
            lastDay: 34,
            title: "Expanding your skills",
        ),
        Lesson(
            firstDay: 36,
            lastDay: 46,
            title: "Scaling up to bigger apps",
        ),
        Lesson(
            firstDay: 49,
            lastDay: 59,
            title: "Focus on data",
        ),
        Lesson(
            firstDay: 62,
            lastDay: 76,
            title: "Filters, maps, and more",
        ),
        Lesson(
            firstDay: 79,
            lastDay: 94,
            title: "Controlling UI flow",
        ),
        Lesson(
            firstDay: 96,
            lastDay: 99,
            title: "One last project",
        ),
    ]
}
