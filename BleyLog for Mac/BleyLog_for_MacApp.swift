//
//  BleyLog_for_MacApp.swift
//  BleyLog for Mac
//
//  Created by Radoslav Bley on 20/08/2025.
//

import SwiftUI

@main
struct BleyLog_for_MacApp: App {
    @State private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(modelData)
        .defaultSize(width: 2000, height: 1000)
        .defaultPosition(.center)

        WindowGroup(for: Project.ID.self) { $projectID in
            ProjectDetailView(projectID: $projectID.wrappedValue)
                .environment(modelData)
        }
        .windowResizability(.contentSize)

        Settings {
            SettingsView()
        }
        .defaultSize(width: 400, height: 400)
        .defaultPosition(.topLeading)
    }
}
