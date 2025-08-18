//
//  HomeView.swift
//  HWS
//
//  Created by Radoslav Bley on 13/08/2025.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility
        .doubleColumn
    @State private var preferredCompactColumn = NavigationSplitViewColumn
        .sidebar

    @Query private var courses: [Course]
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            preferredCompactColumn: $preferredCompactColumn
        ) {
            LessonList(
                courses: courses,
            )
            .navigationSplitViewColumnWidth(min: 200, ideal: 250)

        } content: {
            ProjectList()
                .navigationSplitViewColumnWidth(min: 300, ideal: 350)
        } detail: {
            ProjectDetailView()
                .navigationSplitViewColumnWidth(min: 300, ideal: 450)
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    HomeView()
        .modelContainer(ModelData.shared.modelContainer)
}
