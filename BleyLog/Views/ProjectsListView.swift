//
//  ProjectsListView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 27/08/2025.
//

import SwiftUI

struct ProjectsListView: View {
    @Environment(ViewModel.self) var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            if viewModel.selectedLesson != nil {
                List(
                    viewModel.projects(in: viewModel.selectedLesson),
                    id: \.self,
                    selection: $viewModel.selectedProject
                ) {
                    project in
                    NavigationLink {
                        ProjectView(project: project)
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
                                        .apply {
                                            if #available(iOS 26.0, *) {
                                                $0.glassEffect(
                                                    in: .rect(cornerRadius: 16)
                                                )
                                            } else {
                                                $0.disabled(false)
                                            }
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
                                        .apply {
                                            if #available(iOS 26.0, *) {
                                                $0.glassEffect(
                                                    in: .rect(cornerRadius: 16)
                                                )
                                            } else {
                                                // Fallback
                                            }
                                        }
                                }

                                VStack(alignment: .leading, spacing: 4) {

                                    Text(project.title)
                                        .font(.title3)
                                        .truncationMode(.tail)

                                    let date = project.date
                                    let currentDate =
                                        date
                                        == Calendar.current.startOfDay(
                                            for: Date()
                                        )
                                    let lessThanThreeDaysAgo =
                                        Calendar.current.date(
                                            byAdding: .dayOfYear,
                                            value: -3,
                                            to: Date()
                                        )! < date

                                    if currentDate {
                                        Text(
                                            "Today"
                                        )
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    } else if lessThanThreeDaysAgo {
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
                .navigationTitle(viewModel.selectedLesson?.title ?? "")
                .apply {
                    if #available(iOS 26, *) {
                        if let lesson = viewModel.selectedLesson {
                            let oneDay =
                                lesson.firstDay
                                == lesson.lastDay
                            $0
                                .navigationSubtitle(
                                    oneDay
                                        ? "Day \(lesson.firstDay) in \(lesson.course!.title)"
                                        : "Days \(lesson.firstDay) - \(lesson.lastDay) in \(lesson.course!.title)"
                                )
                        }
                    } else {
                        $0.disabled(false)
                    }
                }
            } else {
                Text("Select a lesson")
            }
        }
    }
}

#Preview {
    let viewModel = ViewModel()

    ProjectsListView()
        .environment(viewModel)
}
