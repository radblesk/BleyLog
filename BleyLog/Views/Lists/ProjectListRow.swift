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
                    .font(.caption2)
                    .foregroundStyle(.link)
                } else {
                    Text(
                        "\(project.date.formatted(date: .abbreviated, time: .omitted))"
                    )
                    .font(.caption2)
                    .foregroundStyle(.link)
                }

                Text(project.title)
                    .font(.headline)
                    .truncationMode(.tail)

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
    List {
        ProjectListRow(project: Project.consolidation2.first!)
    }
}
