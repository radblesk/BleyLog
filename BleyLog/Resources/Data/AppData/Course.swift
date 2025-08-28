//
//  Projects.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftUI

struct Course: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var language: Language?
    var lessons: [Lesson] = []

    static let swiftCourses = [
        Course(
            title: "100 days of SwiftUI",
            lessons: Lesson.hundreedDaysOfSwiftUILessons
        ),
//        Course(
//            title: "100 days of Swift",
//        ),
    ]
}
