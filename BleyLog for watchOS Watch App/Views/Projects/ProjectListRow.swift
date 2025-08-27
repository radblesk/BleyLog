//
//  ProjectListRow.swift
//  BleyLog
//
//  Created by Radoslav Bley on 19/08/2025.
//

import SwiftUI

struct ProjectListRow: View {
    // MARK: Environments
    /// ViewModel
    @Environment(ViewModel.self) var viewModel

    // Passed data
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

            Text(viewModel.formattedDate(project.date))
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical)
    }
}

#Preview {
    let viewModel = ViewModel()

    List {
        ProjectListRow(project: Project.startingSwiftUI[0])
            .environment(viewModel)
    }
}
