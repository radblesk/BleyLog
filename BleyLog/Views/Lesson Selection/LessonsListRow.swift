//
//  LessonsListRow.swift
//  BleyLog
//
//  Created by Radoslav Bley on 28/08/2025.
//

import SwiftUI

struct LessonsListRow: View {
    let lesson: Lesson

    var body: some View {
        Label {
            Text(lesson.title)
        } icon: {
            if lesson.inProgress {
                Image(systemName: "target")
                    .foregroundStyle(.primary)
                    .symbolEffect(
                        .variableColor.cumulative.dimInactiveLayers.nonReversing,
                        options: .repeat(.periodic(delay: 1.0))
                    )
            } else {
                Image(systemName: lesson.finished ? "checkmark.circle" : "book")
                    .foregroundStyle(lesson.finished ? .green : Color.accentColor)
            }
        }
        .badge(lesson.projects.count)
    }
}

#Preview {
    List {
        LessonsListRow(lesson: Lesson.exampleLesson)
    }
}
