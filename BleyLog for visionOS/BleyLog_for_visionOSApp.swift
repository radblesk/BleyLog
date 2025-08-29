//
//  BleyLog_for_visionOSApp.swift
//  BleyLog for visionOS
//
//  Created by Radoslav Bley on 24/08/2025.
//

import SwiftData
import SwiftUI

@main
struct BleyLog_for_visionOSApp: App {
    @State private var ModelData = ModelData()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(ModelData)
    }
}
