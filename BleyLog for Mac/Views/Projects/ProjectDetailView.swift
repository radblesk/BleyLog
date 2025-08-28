//
//  ProjectDetailView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 13/08/2025.
//

import SwiftUI

struct ProjectDetailView: View {
    @Environment(ViewModel.self) var viewModel
    // DataModel
    var projectID: Project.ID?

    var body: some View {
        if let id = projectID, let project = viewModel.project(for: id) {
            ProjectView(project: project)
        }
    }
}
