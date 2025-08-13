//
//  DaysListSection.swift
//  HWS
//
//  Created by Radoslav Bley on 12/08/2025.
//

import SwiftUI

struct LessonListSection: View {
    @Environment(\.modelContext) private var context

    var lessons: [Lesson]
    var course: Course

    @State private var isExpanded = true

    var body: some View {
        Section(course.title, isExpanded: $isExpanded) {
            ForEach(lessons.sorted { $0.firstDay < $1.firstDay }) { lesson in
                HStack {
                    if lesson.inProgress {
                        ProgressView()
                            .tint(.orange)
                    } else if lesson.finished {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.green)
                    }
                    Text(
                        "Days \(lesson.firstDay)-\(lesson.lastDay): \(lesson.title)"
                    )

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                        .imageScale(.small)
                }
                .swipeActions(edge: .leading) {
                    Button(
                        "Mark as done",
                        systemImage: lesson.finished ? "xmark" : "checkmark"
                    ) {
                        if lesson.inProgress {
                            lesson.inProgress.toggle()
                        }

                        lesson.finished.toggle()

                        do {
                            try context.save()
                        } catch {
                            print(error)
                        }
                    }
                    .tint(.green)
                    Button(
                        "Mark as in progress",
                        systemImage: "arrow.triangle.2.circlepath"
                    ) {
                        if lesson.finished {
                            lesson.finished.toggle()
                        }
                        lesson.inProgress.toggle()

                        do {
                            try context.save()
                        } catch {
                            print(error)
                        }
                    }
                    .tint(.orange)
                }
                .tag(lesson)
            }
        }
    }
}

#Preview {
    List {
        LessonListSection(
            lessons: Course.coursesData.first!.lessons,
            course: Course
                .coursesData.first!
        )
    }
}
