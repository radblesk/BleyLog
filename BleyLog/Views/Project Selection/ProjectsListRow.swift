//
//  ProjectsListRow.swift
//  BleyLog
//
//  Created by Radoslav Bley on 28/08/2025.
//

import SwiftUI

struct ProjectsListRow: View {
    @Environment(ModelData.self) var modelData
    let project: Project

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                Image(project.icon)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(.rect(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.secondary.opacity(0.4), style: StrokeStyle(lineWidth: 0.2))
                    }
                    .apply {
                        if #available(iOS 26.0, *) {
                            $0.glassEffect(in: .rect(cornerRadius: 16))
                        } else {
                            $0.disabled(false)
                        }
                    }

                VStack(alignment: .leading, spacing: 4) {

                    Text(project.title)
                        .font(.title3)
                        .truncationMode(.tail)

                    Text(modelData.formattedDate(project.date))
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
    List {
        ProjectsListRow(project: Project.exampleProject)
            .environment(ModelData())
    }
}
