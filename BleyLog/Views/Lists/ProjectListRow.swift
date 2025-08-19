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

            if let icon = project.icon {
                Image(icon)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(.rect(cornerRadius: 8))
                    .foregroundStyle(Color.accentColor)
                    .shadow(radius: 2, x: 0, y: 2)
            } else {
                Image(systemName: "folder")
                    .foregroundStyle(Color.accentColor)
                    .imageScale(.large)
            }

            VStack(alignment: .leading, spacing: 2) {

                HStack {
                    Text(project.title)
                        .font(.headline)
                        .truncationMode(.tail)
                }

                Text(project.desc)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
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
                        "\(project.date.formatted(.relative(presentation: .named, unitsStyle: .wide)))"
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
    }
}

#Preview {
    List {
        ProjectListRow(project: Project.startingSwiftUI.first!)
    }
}
