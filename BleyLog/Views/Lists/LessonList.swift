//
//  ProjectsList.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct LessonList: View {
    // DataModel
    @Environment(\.modelContext) private var context
    var languages: [Language]

    // States
    @State private var searchText: String = ""
    @State private var expanded: Set<String> = ["100 days of SwiftUI"]
    @State private var isPresented = false
    @State private var settingsPresented = false
    @Binding var selectedLanguage: Language?

    // Bindings
    @Binding var lesson: Lesson?

    // OS Specifics
    private var buttonPlacement: ToolbarItemPlacement {
        #if os(iOS) || os(watchOS)
            .bottomBar
        #else
            .automatic
        #endif
    }

    var body: some View {
        NavigationStack {
            VStack {
                if let selectedLanguage {
                    if !selectedLanguage.courses.isEmpty {
                        let sortedCourses = selectedLanguage
                            .courses
                            .sorted {
                                $0.lessons
                                    .count > $1.lessons.count
                            }
                        List(
                            sortedCourses,
                            selection: $lesson
                        ) {
                            course in
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
                                if !course.lessons.isEmpty {
                                    let searchResults = course.lessons.filter {
                                        $0.title.lowercased().contains(
                                            searchText.lowercased()
                                        )
                                    }

                                    let sortedLessons = course.lessons.sorted {
                                        $0.firstDay
                                            < $1.firstDay
                                    }
                                    ForEach(
                                        searchText.isEmpty
                                            ? sortedLessons : searchResults,
                                        id: \.self
                                    ) { lesson in
                                        NavigationLink(value: lesson) {
                                            LessonListRow(lesson: lesson)
                                        }
                                        .disabled(
                                            lesson.projects.count == 0
                                                && !lesson.inProgress
                                        )
                                        .selectionDisabled(
                                            lesson.projects.count == 0
                                                && !lesson.inProgress
                                        )
                                    }
                                } else {
                                    Text("Course not started...")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        #if os(watchOS)
                            .listStyle(.carousel)
                        #endif
                        .headerProminence(.increased)
                        .refreshable {
                            insertModelData()
                        }
                    } else {
                        Text("No courses")
                    }
                } else {
                    Text("Select a language")
                }
            }
            .onAppear {
                if selectedLanguage == nil {
                    selectedLanguage = languages.first { $0.title == "Swift" }
                }
            }
            .navigationTitle(Text("Courses"))
            #if os(watchOS)
                .containerBackground(
                    Color(red: 1, green: 0.23, blue: 0).gradient.opacity(0.5),
                    for: .navigation
                )
                .toolbarForegroundStyle(.orange, for: .automatic)
            #endif
            #if os(iOS) || os(macOS)
                .searchable(text: $searchText)
            #endif
            .toolbar {
                #if os(watchOS)
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(
                            "Language",
                            systemImage: "line.3.horizontal.decrease"
                        ) {
                            isPresented = true
                        }

                        Button("Settings", systemImage: "ellipsis") {
                            settingsPresented = true
                        }
                    }
                #endif
                #if os(iOS)
                    ToolbarItem(placement: .automatic) {
                        Button("Settings", systemImage: "ellipsis") {
                            settingsPresented = true
                        }
                    }
                    if #available(iOS 26, *) {
                        DefaultToolbarItem(kind: .search, placement: .bottomBar)

                        ToolbarItem(placement: .largeSubtitle) {
                            if let selectedLanguage {
                                HStack {
                                    Text(
                                        "\(selectedLanguage.courses.count) \(selectedLanguage.title) courses"
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    Spacer()
                                }
                            }
                        }
                        ToolbarItem(placement: .subtitle) {
                            if let selectedLanguage {
                                HStack {
                                    Text(
                                        "\(selectedLanguage.courses.count) \(selectedLanguage.title) courses"
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    Spacer()
                                }
                            }
                        }
                    } else {
                        ToolbarItem(placement: .status) {
                            if let selectedLanguage {
                                HStack {
                                    Text(
                                        "\(selectedLanguage.courses.count) \(selectedLanguage.title) courses"
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    Spacer()
                                }
                            }
                        }
                    }
                #endif
                #if os(iOS) || os(macOS)
                    ToolbarItem(placement: buttonPlacement) {
                        Button(
                            "Language",
                            systemImage: "line.3.horizontal.decrease"
                        ) {
                            isPresented = true
                        }
                    }
                #endif
                #if os(iOS)
                    if #available(iOS 26, *) {
                        ToolbarSpacer(placement: .bottomBar)
                    }
                #endif

            }
            .sheet(isPresented: $isPresented) {
                VStack {
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language.title)
                                .tag(language)
                        }
                    }
                    #if os(iOS) || os(watchOS)
                        .pickerStyle(.wheel)
                    #endif
                }
                .padding()
                .presentationDetents([.height(250), .medium])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $settingsPresented) {
                SettingsView(presented: $settingsPresented)
                    .presentationDetents([.height(350)])
            }
        }
    }
    private func insertModelData() {
        let descriptor = FetchDescriptor<Language>()

        guard let languages = try? context.fetch(descriptor) else { return }

        if languages.isEmpty {
            for language in Language.languages {
                context.insert(language)
            }
        }
    }
}

#Preview {
    LessonList(
        languages: Language.languages,
        selectedLanguage: .constant(Language.languages.first),
        lesson: .constant(nil)
    )
}
