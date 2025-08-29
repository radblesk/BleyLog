//
//  CoursesSplitView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 23/08/2025.
//

import SwiftData
import SwiftUI

struct CoursesSplitView: View {
    // Environment
    @Environment(ModelData.self) private var modelData
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        @Bindable var modelData = modelData
        NavigationSplitView(
            sidebar: {
                List(
                    modelData.courses(in: modelData.selectedLanguage),
                    id: \.self,
                    selection: $modelData.selectedLesson
                ) {
                    course in
                    Section(course.title) {
                        ForEach(modelData.lessons(in: course), id: \.self) {
                            lesson in
                            NavigationLink(value: lesson) {
                                Label(
                                    lesson.title,
                                    systemImage: lesson.finished
                                        ? "checkmark"
                                        : lesson.inProgress ? "circle" : "book"
                                ).badge(lesson.projects.count)
                            }
                        }
                    }
                }
                .frame(minWidth: 200)
                .toolbar(removing: .sidebarToggle)
            },
            detail: {
                Table(
                    modelData.projectsTable(in: modelData.selectedLesson),
                    selection: $modelData.selection,
                    sortOrder: $modelData.sortOrder
                ) {
                    TableColumn("Title", value: \.title)
                        .width(150)
                    TableColumn("Date", value: \.date) { project in
                        Text(
                            "\(project.date.formatted(.dateTime.day().month().year()))"
                        )
                    }
                    .width(80)
                    TableColumn("Description", value: \.desc)
                }
                .frame(minWidth: 600)
                .contextMenu(forSelectionType: Project.ID.self) { items in
                    // ...
                } primaryAction: { items in
                    guard let projectID = modelData.selection.first
                    else {
                        return
                    }
                    if let project = modelData.projectsTable(
                        in: modelData.selectedLesson
                    ).first(where: { $0.id == projectID }) {

                        openWindow(value: project.id)

                    }
                }
                .navigationTitle(modelData.selectedLesson?.title ?? "")
            }
        )
        .searchable(text: $modelData.search) {
            Section("Lessons") {
                ForEach(modelData.lessonResults(for: modelData.search)) {
                    lesson in
                    Text(lesson.title)
                }
            }

            Section("Projects") {
                ForEach(modelData.projectsResults(for: modelData.search)) {
                    project in
                    Text(project.title)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                @Bindable var modelData = modelData
                Menu {
                    Picker("Language", selection: $modelData.selectedLanguage) {
                        ForEach(modelData.languages, id: \.self) { language in
                            Text(language.title).tag(language)
                        }
                    }.pickerStyle(.inline)
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    CoursesSplitView()
        .environment(ModelData())
}
