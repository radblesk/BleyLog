//
//  ProjectListRow.swift
//  BleyLog
//
//  Created by Radoslav Bley on 13/08/2025.
//

import SwiftUI

struct ProjectListRow: View {
    var project: Project

    var body: some View {
        HStack(spacing: 20) {

            Image(systemName: "folder")
                .foregroundStyle(Color.accentColor)
                .imageScale(.large)

            VStack(alignment: .leading) {

                HStack {
                    Text(project.title)
                        .font(.headline)
                        .truncationMode(.tail)

                    Spacer()

                    let date = project.date
                    let lessThanThreeDaysAgo =
                        Calendar.current.date(
                            byAdding: .dayOfYear,
                            value: -3,
                            to: Date()
                        )! < date

                    if lessThanThreeDaysAgo {
                        Text(
                            "\(project.date.formatted(.relative(presentation: .named, unitsStyle: .wide)))"
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    } else {
                        Text(
                            "\(project.date.formatted(date: .abbreviated, time: .omitted))"
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                }

                Text(project.desc)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .truncationMode(.tail)

            }
        }
    }
}

#Preview {
    ProjectListRow(project: Project.startingSwiftUI.first!)
}
