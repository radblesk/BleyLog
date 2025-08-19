//
//  ProjectListRow.swift
//  BleyLog
//
//  Created by Radoslav Bley on 19/08/2025.
//

import SwiftUI

struct ProjectListRow: View {
    // DataModel
    var project: Project

    var body: some View {
        VStack(alignment: .leading) {

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
            Spacer()
            Text(project.title)
                .bold()
                .truncationMode(.tail)

            Text(project.desc)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
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
                .font(.footnote)
                .foregroundStyle(.link)
                .bold()
            } else {
                Text(
                    "\(project.date.formatted(date: .abbreviated, time: .omitted))"
                )
                .font(.footnote)
                .foregroundStyle(.link)
                .bold()
            }
        }
        .padding(.vertical)
        .frame(height: 150)
    }
}

#Preview {
    List {
        ProjectListRow(project: Project.startingSwiftUI.first!)
    }
}
