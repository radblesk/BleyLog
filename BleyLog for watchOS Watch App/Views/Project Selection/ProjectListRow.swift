//
//  ProjectListRow.swift
//  BleyLog
//
//  Created by Radoslav Bley on 19/08/2025.
//

import SwiftUI

struct ProjectListRow: View {
    @Environment(ModelData.self) var modelData

    var project: Project

    var body: some View {
        VStack(alignment: .leading) {
            if let icon = project.icon {
                Image(icon)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(.circle)
                    .apply {
                        if #available(watchOS 26, *) {
                            $0.glassEffect()
                        }
                    }
            } else {
                Image("empty-icon")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(.circle)
                    .apply {
                        if #available(watchOS 26, *) {
                            $0.glassEffect()
                        }
                    }
            }
            Spacer(minLength: 6)
            Text(project.title)
                .bold()
                .truncationMode(.tail)

            Text(modelData.formattedDate(project.date))
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical)
    }
}

#Preview {
    let modelData = ModelData()

    List {
        ProjectListRow(project: Project.exampleProject)
            .environment(modelData)
    }
}
