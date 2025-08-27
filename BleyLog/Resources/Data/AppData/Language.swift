//
//  Projects.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

@Model
class Language {
    var title: String

    @Relationship(deleteRule: .cascade) var courses: [Course] = []

    init(
        title: String,
        courses: [Course] = []
    ) {
        self.title = title
        self.courses = courses

    }

    static let languages = [
        Language(title: "Swift", courses: Course.swiftCourses),
        Language(title: "Next.js"),
        Language(title: "React"),
        Language(title: "TypeScript"),
    ]
}
