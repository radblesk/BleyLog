//
//  BleyLogApp.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

@main
struct BleyLogApp: App {
    /// An object that manages the app's data and state.
    @State private var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(viewModel)
    }
}
