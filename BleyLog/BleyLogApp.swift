//
//  BleyLogApp.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftUI

@main
struct BleyLogApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(ModelData.shared.modelContainer)
        #if os(macOS)
        .defaultSize(width: 800, height: 600)
        .defaultPosition(.topLeading)
        #endif
    }
}
