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
        #if os(iOS) || os(macOS) || os(tvOS) || targetEnvironment(macCatalyst)
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
                    Text(
                        "Days \(lesson.firstDay)-\(lesson.lastDay)"
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
        #elseif os(watchOS)
            VStack(alignment: .leading, spacing: 10) {
                if lesson.inProgress {
                    Image(systemName: "target")
                        .resizable()
                        .frame(width: 32, height: 32)
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
                    .frame(width: 32, height: 32)
                    .foregroundStyle(
                        lesson.finished
                            ? .green
                            : .orange
                    )
                }
                VStack(alignment: .leading) {
                    Text(lesson.title)
                        .bold()
                    Text(
                        "Days \(lesson.firstDay)-\(lesson.lastDay)"
                    )
                    .font(.caption)
                    .foregroundStyle(
                        .secondary
                    )
                }
                Text("\(lesson.projects.count) projects")
                    .foregroundStyle(
                        lesson.finished
                            ? .green
                            : lesson.inProgress
                                ? .blue : .orange
                    )
                    .bold()
                    .textCase(.uppercase)
            }
            .padding(.vertical, 10)
        #endif
    }
}

#Preview {
    List {
        LessonListRow(lesson: Lesson.hundreedDaysOfSwiftUILessons.first!)
    }
}
