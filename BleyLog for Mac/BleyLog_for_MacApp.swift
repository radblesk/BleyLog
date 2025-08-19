//
//  BleyLog_for_MacApp.swift
//  BleyLog for Mac
//
//  Created by Radoslav Bley on 20/08/2025.
//

import SwiftData
import SwiftUI

@main
struct BleyLog_for_MacApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(ModelData.shared.modelContainer)

        Settings {
            SettingsView()
        }
    }
}
