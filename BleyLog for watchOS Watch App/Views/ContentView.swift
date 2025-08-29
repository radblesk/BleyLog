//
//  ContentView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 19/08/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(ModelData.self) var modelData
    @State private var pathStore = PathStore()

    var body: some View {
        NavigationSplitView {
            LessonsListView()
        } detail: {
            NavigationStack(path: $pathStore.path) {
                ProjectsListView(modelData: modelData)
                    .navigationDestination(for: Project.self) { project in
                        ProjectView(project: project).viewForProject()
                    }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
