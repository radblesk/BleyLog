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

    @Relationship(deleteRule: .cascade) var lessons: [Lesson] = []

    init(
        title: String,
        lessons: [Lesson] = []
    ) {
        self.title = title
        self.lessons = lessons

    }

    static let coursesData = [
        Course(
            title: "100 days of SwiftUI",
            lessons: Lesson.hundreedDaysOfSwiftUILessons
        ),
        Course(
            title: "100 days of Swift",
        ),
    ]
}
