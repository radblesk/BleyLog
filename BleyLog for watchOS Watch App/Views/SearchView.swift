//
//  SearchView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 25/08/2025.
//

import SwiftUI

struct SearchView: View {
    // MARK: - ViewModel
    @Environment(ViewModel.self) var viewModel

    // MARK: States
    /// Expanded states
    @State private var expandedLessons = true
    @State private var expandedProjects = true
    /// Selections
    @State private var selectedLesson: Lesson?
    @State private var selectedProject: Project?

    // MARK: - Projects list
    fileprivate func projectsList(for selectedLesson: Lesson)
        -> NavigationStack<
            NavigationPath, some View
        >
    {
        return NavigationStack {
            List(
                viewModel.projects(in: selectedLesson),
                id: \.self,
                selection: $selectedProject
            ) {
                project in
                NavigationLink {
                    projectDetailView(for: project)
                } label: {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 14) {
                            if let icon = project.icon {
                                Image(icon)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(.rect(cornerRadius: 16))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                .secondary.opacity(0.4),
                                                style: StrokeStyle(
                                                    lineWidth: 0.2
                                                )
                                            )
                                    }
                            } else {
                                Image("empty-icon")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(.rect(cornerRadius: 16))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                .secondary.opacity(0.4),
                                                style: StrokeStyle(
                                                    lineWidth: 0.2
                                                )
                                            )
                                    }
                            }

                            VStack(alignment: .leading, spacing: 4) {

                                Text(project.title)
                                    .font(.title3)
                                    .truncationMode(.tail)

                                let date = project.date
                                let lessThanThreeDaysAgo =
                                    Calendar.current.date(
                                        byAdding: .dayOfYear,
                                        value: -3,
                                        to: Date()
                                    )! < date

                                if lessThanThreeDaysAgo {
                                    Text(
                                        "\(project.date.formatted(.dateTime.weekday(.wide)))"
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                } else {
                                    Text(
                                        "\(project.date.formatted(date: .abbreviated, time: .omitted))"
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                }
                            }
                        }

                        Text(project.desc)
                            .font(.subheadline)
                            .lineLimit(2)
                            .truncationMode(.tail)
                    }
                }
            }
            .navigationTitle(selectedLesson.title)
        }
    }

    // MARK: - Project detail view
    fileprivate func projectDetailView(for selectedProject: Project)
        -> some View
    {
        return NavigationStack {
            Group {
                switch selectedProject.title {
                case "WeSplit":
                    WeSplit()
                case "TempConvert":
                    TempConvert()
                case "GuessTheFlag":
                    GuessTheFlag()
                case "RockPaperScissors":
                    RockPaperScissors()
                case "BetterRest":
                    BetterRest()
                default:
                    Text("Select a project")
                }
            }
        }
    }

    // MARK: - Main View
    var body: some View {
        NavigationStack {
            List {
                Section("Lessons", isExpanded: $expandedLessons) {
                    ForEach(viewModel.lessonResults(for: viewModel.search)) {
                        lesson in
                        NavigationLink(lesson.title) {
                            projectsList(for: lesson)
                        }
                    }
                }

                Section("Projects", isExpanded: $expandedProjects) {
                    ForEach(viewModel.projectsResults(for: viewModel.search)) {
                        project in
                        NavigationLink(project.title) {
                            projectDetailView(for: project)
                        }
                    }
                }

            }
            .navigationBarTitle("Search")
        }
    }
}

// MARK: - Preview
#Preview {
    let viewModel = ViewModel()
    SearchView()
        .environment(viewModel)
}
