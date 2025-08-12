//
//  HWSApp.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftUI

@main
struct HWSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(ModelData.shared.modelContainer)
        }
    }
}
