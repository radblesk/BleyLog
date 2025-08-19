//
//  BleyLogWatchApp.swift
//  BleyLogWatch Watch App
//
//  Created by Radoslav Bley on 19/08/2025.
//

import SwiftData
import SwiftUI

@main
struct BleyLogWatch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(ModelData.shared.modelContainer)
        }
    }
}
