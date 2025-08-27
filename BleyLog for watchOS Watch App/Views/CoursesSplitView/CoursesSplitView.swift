//
//  CoursesSplitView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 25/08/2025.
//

import SwiftUI

struct CoursesSplitView: View {
    // MARK: Environments
    /// ViewModel
    @Environment(ViewModel.self) private var viewModel
    /// Search dismiss action
    @Environment(\.dismissSearch) private var dismissSearch

    // MARK: - Main View
    var body: some View {
        NavigationSplitView(
            sidebar: {
                LessonsListView()
            },
            detail: {
                ProjectsListView()
            }
        )
        .onAppear {
            dismissSearch()
        }
    }
}

// MARK: - Preview
#Preview {
    let viewModel = ViewModel()

    CoursesSplitView()
        .environment(viewModel)
}
