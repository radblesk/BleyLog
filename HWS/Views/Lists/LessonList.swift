//
//  ProjectsList.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct LessonList: View {

    @Environment(\.modelContext) private var context

    var courses: [Course]

    @State private var searchText: String = ""
    @State private var expanded: Set<String> = ["100 days of SwiftUI"]

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    if searchText.isEmpty {
                        Section {
                            HStack {
                                Spacer()
                                VStack {
                                    Image(systemName: "books.vertical.fill")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .padding(8)
                                        .background(.orange)
                                        .clipShape(.rect(cornerRadius: 10))
                                    Text(
                                        "Programming courses from various sources. Track your progress and learn new programming languages."
                                    )
                                    .multilineTextAlignment(.center)
                                    .font(.subheadline)
                                }
                                Spacer()
                            }
                        }
                    } else {
                        Section {
                            Text(
                                "Searching in \(courses.reduce(0) { $0 + $1.lessons.count }) lessons..."
                            )
                        }
                    }
                    ForEach(courses, id: \.self) { course in
                        if course.lessons.count > 0 {
                            Section(
                                course.title,
                                isExpanded: Binding<Bool>(
                                    get: { expanded.contains(course.title) },
                                    set: { isExpanding in
                                        if isExpanding {
                                            expanded.insert(course.title)
                                        } else {
                                            expanded.remove(course.title)
                                        }
                                    }
                                )
                            ) {
                                let sortedLessons = course.lessons.sorted {
                                    $0.firstDay < $1.firstDay
                                }

                                let searchResults = sortedLessons.filter {
                                    $0.title.lowercased().contains(
                                        searchText.lowercased()
                                    )
                                }
                                ForEach(
                                    searchText.isEmpty
                                        ? sortedLessons : searchResults,
                                    id: \.self
                                ) { lesson in
                                    NavigationLink {
                                        ProjectList(lesson: lesson)
                                    } label: {
                                        Label(
                                            "Days \(lesson.firstDay)-\(lesson.lastDay): \(lesson.title)",
                                            systemImage: lesson.finished
                                                ? "checkmark"
                                                : lesson.inProgress
                                                    ? "circle.dotted"
                                                    : "book.pages"
                                        )
                                        .tint(.orange)
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button(
                                            "Mark as done",
                                            systemImage: lesson.finished
                                                ? "xmark" : "checkmark"
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
                                            systemImage:
                                                "circle.dotted"
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
                                }
                            }
                        } else {
                            Section(course.title) {
                                Text("Course not started yet...")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .searchable(text: $searchText)
                .onChange(of: searchText) { _, newValue in
                    if !newValue.isEmpty {
                        expanded = Set(
                            courses.filter { !$0.lessons.isEmpty }.map(\.title)
                        )
                    } else {
                        expanded = ["100 days of SwiftUI"]
                    }
                }
                .listStyle(.sidebar)
                .navigationTitle("Courses")
            }

        }
    }
}

#Preview {
    LessonList(
        courses: Course.coursesData
    )
}
