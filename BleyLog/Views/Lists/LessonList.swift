//
//  ProjectsList.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct LessonList: View {

    @Environment(\.modelContext) private var context

    var languages: [Language]

    @State private var searchText: String = ""
    @State private var expanded: Set<String> = ["100 days of SwiftUI"]
    @State private var isPresented = false
    @State private var selectedLanguage: Language?

    var body: some View {
        NavigationStack {
            VStack {
                if let lang = selectedLanguage {
                    List {
                        if lang.courses.count > 0 {
                            if searchText.isEmpty {
                                Section {
                                    HStack {
                                        Spacer()
                                        VStack(spacing: 16) {
                                            Image(
                                                systemName:
                                                    "books.vertical.fill"
                                            )
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                            .padding(8)
                                            .background(.orange)
                                            .clipShape(.rect(cornerRadius: 10))
                                            .foregroundStyle(.white)
                                            Text(
                                                "Programming courses from various sources. Track your progress and learn new programming languages."
                                            )
                                            .multilineTextAlignment(.center)
                                            .font(.subheadline)
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                }
                            } else {
                                Section {
                                    Text(
                                        "Searching in \(lang.courses.reduce(0) { $0 + $1.lessons.count }) lessons..."
                                    )
                                }
                            }
                            ForEach(
                                lang.courses.sorted {
                                    $0.lessons.count > $1.lessons.count
                                },
                                id: \.self
                            ) { course in
                                if course.lessons.count > 0 {
                                    Section(
                                        course.title,
                                        isExpanded: Binding<Bool>(
                                            get: {
                                                expanded.contains(course.title)
                                            },
                                            set: { isExpanding in
                                                if isExpanding {
                                                    expanded.insert(
                                                        course.title
                                                    )
                                                } else {
                                                    expanded.remove(
                                                        course.title
                                                    )
                                                }
                                            }
                                        )
                                    ) {
                                        let sortedLessons = course.lessons
                                            .sorted {
                                                $0.firstDay < $1.firstDay
                                            }

                                        let searchResults = sortedLessons.filter
                                        {
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
                                                HStack(spacing: 20) {
                                                    if lesson.inProgress {
                                                        ProgressView()
                                                            .tint(.orange)
                                                    } else {
                                                        Image(
                                                            systemName: lesson
                                                                .finished
                                                                ? "checkmark"
                                                                : "book.pages"
                                                        )
                                                        .imageScale(.large)
                                                        .foregroundStyle(
                                                            lesson.finished
                                                                ? .green
                                                                : .orange
                                                        )
                                                    }
                                                    VStack(alignment: .leading)
                                                    {
                                                        Text(lesson.title)
                                                            .font(.headline)
                                                        Text(
                                                            "Days \(lesson.firstDay)-\(lesson.lastDay)"
                                                        )
                                                        .font(.subheadline)
                                                        .foregroundStyle(
                                                            .secondary
                                                        )
                                                    }
                                                }
                                            }
                                            .swipeActions(edge: .leading) {
                                                Button(
                                                    "Mark as done",
                                                    systemImage: lesson.finished
                                                        ? "xmark" : "checkmark"
                                                ) {
                                                    if lesson.inProgress {
                                                        lesson.inProgress
                                                            .toggle()
                                                    }

                                                    lesson.finished.toggle()

                                                    do {
                                                        try context.save()
                                                        print("Saved")
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
                        } else {
                            Text("No courses for \(lang.title).")
                        }
                    }
                    .searchable(text: $searchText)
                    .onChange(of: searchText) { _, newValue in
                        if !newValue.isEmpty {
                            expanded = Set(
                                lang.courses.filter {
                                    !$0.lessons.isEmpty
                                }.map(\.title)
                            )
                        } else {
                            expanded = ["100 days of SwiftUI"]
                        }
                    }
                    .listStyle(.sidebar)
                    .navigationTitle("\(lang.title) Courses")
                }
            }
            .onAppear {
                if selectedLanguage == nil {
                    selectedLanguage = languages.first { $0.title == "Swift" }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(
                        "Language",
                        systemImage: "line.3.horizontal.decrease"
                    ) {
                        isPresented = true
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
                VStack {
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language.title)
                                .tag(language)
                        }
                    }
                    #if os(iOS)
                        .pickerStyle(.wheel)
                    #endif
                }
                .presentationDetents([.fraction(0.2)])
                .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    LessonList(
        languages: Language.languages,
    )
}
