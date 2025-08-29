//
//  LessonsListView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 27/08/2025.
//

import SwiftUI

struct LessonsListView: View {
    @Environment(ModelData.self) var modelData

    @State private var expanded: Set<String> = ["100 days of SwiftUI", "100 days of Swift"]
    @State private var showMore = false
    private var isiPad = UIDevice.current.userInterfaceIdiom == .pad
    private var itemPlacement: ToolbarItemPlacement {
        if isiPad {
            .automatic
        } else {
            .bottomBar
        }
    }

    var body: some View {
        @Bindable var modelData = modelData

        List(modelData.courses(in: modelData.selectedLanguage)) { course in
            // Expanding binding for each section
            let isExpanded: Binding<Bool> = Binding<Bool>(
                get: { expanded.contains(course.title) },
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

            Section(course.title, isExpanded: isExpanded) {
                ForEach(modelData.lessons(in: course, status: .started)) { lesson in
                    NavigationLink(value: lesson) {
                        LessonsListRow(lesson: lesson)
                    }
                }

                // Show future lessons
                if showMore {
                    ForEach(modelData.lessons(in: course, status: .notStarted)) { lesson in
                        NavigationLink(value: lesson) {
                            Label {
                                Text(lesson.title)
                            } icon: {
                                Image(systemName: "book")
                                    .foregroundStyle(Color.accentColor)
                            }
                            .badge(lesson.projects.count)
                        }
                        .disabled(true)
                        .selectionDisabled(true)
                    }
                }

                Button(showMore ? "Show fewer" : "Show more") {
                    withAnimation {
                        showMore.toggle()
                    }
                }
                .padding(.horizontal)
                .foregroundStyle(.blue)
                .font(.subheadline)
            }
        }
        .navigationTitle("Courses")
        .toolbar {
            if #available(iOS 26, *) {
                ToolbarSpacer(.flexible, placement: itemPlacement)
            }
            ToolbarItem(placement: .bottomBar) {
                Menu {
                    Picker("Language", selection: $modelData.selectedLanguage) {
                        ForEach(modelData.languages) { language in
                            Text(language.title).tag(language)
                        }
                    }
                } label: {
                    Button("Language", systemImage: "line.3.horizontal.decrease") {}
                }
            }
        }
        .apply {
            if #available(iOS 26, *) {
                if let language = modelData.selectedLanguage {
                    $0.navigationSubtitle("for \(language.title)")
                }
            } else {
                $0.disabled(false)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        LessonsListView()
            .environment(ModelData())
    }
}
