//
//  Projects.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

@Model
class Course {
    var title: String
    var language: Language?

    @Relationship(deleteRule: .cascade) var lessons: [Lesson] = []

    init(
        title: String,
        lessons: [Lesson] = [],
        language: Language? = nil
    ) {
        self.title = title
        self.lessons = lessons
        self.language = language

    }

    static let swiftCourses = [
        Course(
            title: "100 days of SwiftUI",
            lessons: Lesson.hundreedDaysOfSwiftUILessons
        ),
        Course(
            title: "100 days of Swift",
        ),
    ]
}
