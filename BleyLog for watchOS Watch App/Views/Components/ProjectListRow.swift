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
                    .frame(width: 40, height: 40)
                    .clipShape(.circle)
            } else {
                Image("empty-icon")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(.circle)
            }
            Spacer(minLength: 6)
            Text(project.title)
                .bold()
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
                .font(.footnote)
                .foregroundStyle(.secondary)
            } else {
                Text(
                    "\(project.date.formatted(date: .abbreviated, time: .omitted))"
                )
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical)
        //        .frame(height: 150)
    }
}

#Preview {
    List {
        ProjectListRow(project: Project.startingSwiftUI.first!)
    }
}
