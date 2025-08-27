//
//  ProjectsListRow.swift
//  BleyLog
//
//  Created by Radoslav Bley on 28/08/2025.
//

import SwiftUI

struct ProjectsListRow: View {
    // MARK: Environments
    /// ViewModel
    @Environment(ViewModel.self) var viewModel

    // Passed data
    let project: Project

    var body: some View {
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
                                $0.disabled(false)
                            }
                        }
                }

                VStack(alignment: .leading, spacing: 4) {

                    Text(project.title)
                        .font(.title3)
                        .truncationMode(.tail)

                    Text(viewModel.formattedDate(project.date))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Text(project.desc)
                .font(.subheadline)
                .lineLimit(2)
                .truncationMode(.tail)
        }
    }
}

#Preview {
    let viewModel = ViewModel()
    let project = Project.scalingUpToBiggerApps[1]

    List {
        ProjectsListRow(project: project)
            .environment(viewModel)
    }
}
