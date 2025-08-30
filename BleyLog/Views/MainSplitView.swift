//
//  NewSplitView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 30/08/2025.
//

import SwiftUI

struct MainSplitView: View {
    @Environment(ModelData.self) var modelData
    @State private var path = PathStore()
    @State private var showingMore: Bool = false
    private var isPad = UIDevice.current.userInterfaceIdiom == .pad
    private var placement: ToolbarItemPlacement {
        if isPad {
            .automatic
        } else {
            .bottomBar
        }
    }

    var body: some View {
        @Bindable var modelData = modelData

        NavigationSplitView {
            if let language = modelData.selectedLanguage {
                List(selection: $modelData.selectedLesson) {
                    ForEach(modelData.courses(in: language)) { course in
                        Section(course.title) {
                            ForEach(modelData.lessons(in: course, status: .started)) { lesson in
                                NavigationLink(value: lesson) {
                                    LessonsListRow(lesson: lesson)
                                }
                            }

                            if showingMore {
                                ForEach(modelData.lessons(in: course, status: .notStarted)) { lesson in
                                    NavigationLink(value: lesson) {
                                        LessonsListRow(lesson: lesson)
                                    }
                                }
                                .disabled(true)
                                .selectionDisabled(true)
                            }

                            Button(showingMore ? "Show less" : "Show more") {
                                withAnimation {
                                    showingMore.toggle()
                                }
                            }
                            .foregroundStyle(.blue)
                        }
                    }
                }
                .navigationTitle(language.title)
                .toolbar {
                    if !isPad {
                        if #available(iOS 26, *) {
                            ToolbarSpacer(.flexible, placement: .bottomBar)
                        }
                    }
                    ToolbarItem(placement: placement) {
                        Menu {
                            Picker("Languages", selection: $modelData.selectedLanguage) {
                                ForEach(modelData.languages) { language in
                                    Text(language.title)
                                        .tag(language)
                                }
                            }
                        } label: {
                            Button("Language", systemImage: "line.3.horizontal.decrease") {}
                        }
                    }
                }
            }
        } detail: {
            if let lesson = modelData.selectedLesson {
                NavigationStack(path: $path.path) {
                    List(lesson.projects) { project in
                        NavigationLink(value: project) {
                            ProjectsListRow(project: project)
                        }
                    }
                    .navigationTitle(lesson.title)
                    .navigationDestination(for: Project.self) { project in
                        ProjectView(project: project).viewForProject()
                    }
                    .toolbar {
                        if #available(iOS 26, *) {
                            ToolbarItem(placement: .largeSubtitle) {
                                Text(days())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundStyle(.accent)
                            }
                            ToolbarItem(placement: .subtitle) {
                                Text(days())
                                    .font(.caption)
                                    .foregroundStyle(.accent)
                            }
                        }
                    }
                }
            } else {
                Text("Select a lesson")
            }
        }
    }

    func days() -> String {
        guard modelData.selectedLesson != nil else {
            return ""
        }
        if let lesson = modelData.selectedLesson {
            let oneDay = lesson.firstDay == lesson.lastDay
            return oneDay ? "Day \(lesson.firstDay)" : "Days \(lesson.firstDay) - \(lesson.lastDay)"
        } else {
            return ""
        }
    }
}

#Preview {
    MainSplitView()
        .environment(ModelData())
}
