//
//  SettingsView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 19/08/2025.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            Tab("Data", systemImage: "swiftdata") {
                DataSettingsView()
            }
        }
        .scenePadding()
        .frame(minWidth: 350, minHeight: 100)
    }
}

#Preview {
    SettingsView()
}
