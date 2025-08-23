//
//  ProjectListRow.swift
//  BleyLog
//
//  Created by Radoslav Bley on 13/08/2025.
//

import SwiftUI

struct ProjectListRow: View {
    // DataModel
    var project: Project

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
                                    style: StrokeStyle(lineWidth: 0.2)
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
                                    style: StrokeStyle(lineWidth: 0.2)
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

#Preview {
    List {
        ProjectListRow(project: Project.consolidation2.first!)
    }
}
