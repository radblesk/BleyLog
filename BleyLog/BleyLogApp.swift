//
//  BleyLogApp.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftUI

@main
struct BleyLogApp: App {
    /// An object that manages the app's data and state.
    @State private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
                .frame(minWidth: 375, minHeight: 375)
        }
    }
}
