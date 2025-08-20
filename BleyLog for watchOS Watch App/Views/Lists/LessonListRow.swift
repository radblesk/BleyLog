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
        VStack(alignment: .leading) {
            if lesson.inProgress {
                Image(systemName: "target")
                    .resizable()
                    .frame(width: 26, height: 26)
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
                        ? "checkmark.circle.fill"
                        : "book.pages.fill"
                )
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 26)
                .foregroundStyle(
                    lesson.finished
                        ? .green
                        : .orange
                )
            }
            Spacer()
            Text(lesson.title)
                .bold()
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
            Spacer()
            Text("^[\(lesson.projects.count) project](inflect: true)")
                .foregroundStyle(
                    lesson.finished
                        ? .green
                        : lesson.inProgress
                            ? .blue : .orange
                )
                .font(.footnote)
                .bold()
                .textCase(.uppercase)
        }
        .padding(.vertical)
        .frame(height: 120)
    }
}

#Preview {
    List {
        LessonListRow(lesson: Lesson.hundreedDaysOfSwiftUILessons.first!)
    }
}
