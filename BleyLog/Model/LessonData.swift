//
//  LessonData.swift
//  BleyLog
//
//  Created by Radoslav Bley on 29/08/2025.
//

import Foundation

extension Lesson {
    //    @MainActor
    static let exampleLesson = hundreedDaysOfSwiftUILessons[2]

    static let hundreedDaysOfSwiftUILessons = [
        Lesson(
            firstDay: 16,
            lastDay: 24,
            title: "Starting SwiftUI",
            finished: true,
            projects: Project.startingSwiftUI,
            headerImage: "startingswiftui-header",
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
            finished: true,
            projects: Project.expandingYourSkills,
            headerImage: "expandingyourskills-header"
        ),
        Lesson(
            firstDay: 35,
            lastDay: 35,
            title: "Consolidation III",
            finished: true,
            projects: Project.consolidation3
        ),
        Lesson(
            firstDay: 36,
            lastDay: 46,
            title: "Scaling up to bigger apps",
            finished: true,
            projects: Project.scalingUpToBiggerApps
        ),
        Lesson(
            firstDay: 47,
            lastDay: 48,
            title: "Consolidation IV",
            finished: true,
            projects: Project.consolidation4
        ),
        Lesson(
            firstDay: 49,
            lastDay: 59,
            title: "Focus on data",
            finished: true,
            projects: Project.focusOnData
        ),
        Lesson(
            firstDay: 60,
            lastDay: 61,
            title: "Consolidation V",
            finished: true,
            projects: Project.consolidation5
        ),
        Lesson(
            firstDay: 62,
            lastDay: 76,
            title: "Filters, maps, and more",
            inProgress: true,
            projects: Project.filtersMapsAndMore
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
