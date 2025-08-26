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
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationSplitView(
            sidebar: {
                List(
                    viewModel.courses(in: viewModel.selectedLanguage),
                    id: \.self,
                    selection: $viewModel.selectedLesson
                ) {
                    course in
                    Section(course.title) {
                        ForEach(viewModel.lessons(in: course), id: \.self) {
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
                    viewModel.projectsTable(in: viewModel.selectedLesson),
                    selection: $viewModel.selection,
                    sortOrder: $viewModel.sortOrder
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
                    guard let projectID = viewModel.selection.first
                    else {
                        return
                    }
                    if let project = viewModel.projectsTable(
                        in: viewModel.selectedLesson
                    ).first(where: { $0.id == projectID }) {

                        openWindow(value: project.id)

                    }
                }
                .navigationTitle(viewModel.selectedLesson?.title ?? "")
            }
        )
        .searchable(text: $viewModel.search) {
            Section("Lessons") {
                ForEach(viewModel.lessonResults(for: viewModel.search)) {
                    lesson in
                    Text(lesson.title)
                }
            }

            Section("Projects") {
                ForEach(viewModel.projectsResults(for: viewModel.search)) {
                    project in
                    Text(project.title)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                @Bindable var viewModel = viewModel
                Menu {
                    Picker("Language", selection: $viewModel.selectedLanguage) {
                        ForEach(viewModel.languages, id: \.self) { language in
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
    let viewModel = ViewModel()
    CoursesSplitView()
        .environment(viewModel)
}
