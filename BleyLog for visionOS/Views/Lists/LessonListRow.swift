//
//  LessonListRow.swift
//  BleyLog
//
//  Created by Radoslav Bley on 19/08/2025.
//

import SwiftUI

struct LessonListRow: View {
    // DataModel
    var lesson: Lesson

    var body: some View {
        HStack(spacing: 20) {
            if lesson.inProgress {
                Image(systemName: "target")
                    .symbolEffect(
                        .variableColor
                            .iterative
                            .dimInactiveLayers
                            .nonReversing,
                        options: .repeat(
                            .periodic(
                                delay: 1.0
                            )
                        )
                    )
                    .foregroundStyle(.blue)
            } else {
                Image(
                    systemName: lesson
                        .finished
                        ? "checkmark"
                        : "book.pages"
                )
                .imageScale(.medium)
                .foregroundStyle(
                    lesson.finished
                        ? .green
                        : .orange
                )
            }
            VStack(alignment: .leading) {
                Text(lesson.title)
                    .font(.headline)

                let oneDay = lesson.firstDay == lesson.lastDay
                Text(
                    oneDay
                        ? "Day \(lesson.firstDay)"
                        : "Days \(lesson.firstDay)-\(lesson.lastDay)"
                )
                .font(.caption)
                .foregroundStyle(
                    .secondary
                )
            }
            Spacer()
            Text("\(lesson.projects.count)")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    List {
        LessonListRow(
            lesson: Lesson.hundreedDaysOfSwiftUILessons
                .first(where: { $0.firstDay == 25 })!
        )
    }
}
