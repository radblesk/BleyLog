//
//  RecentsView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 25/08/2025.
//

import SwiftData
import SwiftUI

struct RecentsView: View {
    // MARK: - ViewModel
    @Environment(ViewModel.self) var viewModel

    //    // MARK: - Projects list
    fileprivate func projectsList() -> NavigationStack<
        NavigationPath, some View
    > {
        return NavigationStack {
            if viewModel.selectedLesson != nil {
                @Bindable var viewModel = viewModel
                List(
                    viewModel.projects(in: viewModel.selectedLesson),
                    id: \.self,
                    selection: $viewModel.selectedProject
                ) {
                    project in
                    NavigationLink {
                        projectDetailView()
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
                .navigationTitle(viewModel.selectedLesson?.title ?? "")
                .apply {
                    if #available(iOS 26, *) {
                        if let selection = viewModel.selectedLesson {
                            let oneDay =
                                selection.firstDay
                                == selection.lastDay
                            $0
                                .navigationSubtitle(
                                    oneDay
                                        ? "Day \(selection.firstDay) in \(selection.course!.title)"
                                        : "Days \(selection.firstDay) - \(selection.lastDay) in \(selection.course!.title)"
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

    // MARK: - Project detail view
    fileprivate func projectDetailView() -> some View {
        return NavigationStack {
            Group {
                switch viewModel.selectedProject?.title {
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
        @Bindable var viewModel = viewModel
        NavigationSplitView {
            List(
                viewModel.lessons(status: .inProgress),
                id: \.self,
                selection: $viewModel.selectedLesson
            ) { lesson in
                NavigationLink(lesson.title, value: lesson)
            }
            .navigationTitle("Recents")
        } detail: {
            projectsList()
        }
    }
}

// MARK: - Preview
#Preview {
    let viewModel = ViewModel()
    RecentsView()
        .environment(viewModel)
}
