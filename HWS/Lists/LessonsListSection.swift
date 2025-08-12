//
//  DaysListSection.swift
//  HWS
//
//  Created by Radoslav Bley on 12/08/2025.
//

import SwiftUI

struct LessonsListSection: View {
    var lessons: [Lesson]
    var course: Course

    @State private var isExpanded = true

    var body: some View {
        Section(course.title, isExpanded: $isExpanded) {
            ForEach(lessons.sorted { $0.firstDay < $1.firstDay }) { lesson in
                HStack {
                    if lesson.finished {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.green)
                    }
                    Text(
                        "Days \(lesson.firstDay)-\(lesson.lastDay): \(lesson.title)"
                    )
                }
                .tag(lesson)
            }
        }
    }
}
